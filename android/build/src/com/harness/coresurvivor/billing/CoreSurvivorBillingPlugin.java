package com.harness.coresurvivor.billing;

import android.app.Activity;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;

import com.android.billingclient.api.AcknowledgePurchaseParams;
import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.PendingPurchasesParams;
import com.android.billingclient.api.ProductDetails;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.QueryProductDetailsParams;
import com.android.billingclient.api.QueryProductDetailsResult;
import com.android.billingclient.api.QueryPurchasesParams;
import com.android.billingclient.api.UnfetchedProduct;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;
import org.godotengine.godot.plugin.UsedByGodot;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CoreSurvivorBillingPlugin extends GodotPlugin implements PurchasesUpdatedListener {
    private static final String TAG = "CoreSurvivorBilling";
    private static final String PLUGIN_NAME = "CoreSurvivorBilling";

    private final List<String> inAppProducts = Arrays.asList(
            "remove_ads",
            "starter_core_pack",
            "premium_core_skin_pack",
            "special_drone_pack",
            "growth_shard_pack"
    );
    private final List<String> subscriptionProducts = Arrays.asList("monthly_supply_pass");
    private final Set<String> consumableProducts = new HashSet<>(Arrays.asList("growth_shard_pack"));
    private final Map<String, ProductDetails> productDetails = new HashMap<>();
    private final Map<String, String> productTypes = new HashMap<>();

    private Activity activity;
    private BillingClient billingClient;
    private boolean connecting = false;

    public CoreSurvivorBillingPlugin(Godot godot) {
        super(godot);
        for (String productId : inAppProducts) {
            productTypes.put(productId, BillingClient.ProductType.INAPP);
        }
        for (String productId : subscriptionProducts) {
            productTypes.put(productId, BillingClient.ProductType.SUBS);
        }
    }

    @NonNull
    @Override
    public String getPluginName() {
        return PLUGIN_NAME;
    }

    @NonNull
    @Override
    public List<String> getPluginMethods() {
        return Arrays.asList(
                "initializeBilling",
                "queryProducts",
                "restorePurchases",
                "purchase",
                "isReady",
                "isProductAvailable",
                "getProductPrice",
                "getProductType"
        );
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals() {
        Set<SignalInfo> signals = new HashSet<>();
        signals.add(new SignalInfo("billing_ready"));
        signals.add(new SignalInfo("billing_disconnected"));
        signals.add(new SignalInfo("billing_error", String.class));
        signals.add(new SignalInfo("product_details", String.class, String.class, String.class, String.class));
        signals.add(new SignalInfo("product_unavailable", String.class, String.class));
        signals.add(new SignalInfo("purchase_completed", String.class, String.class));
        signals.add(new SignalInfo("purchase_pending", String.class));
        signals.add(new SignalInfo("purchase_cancelled", String.class));
        signals.add(new SignalInfo("purchase_failed", String.class, String.class));
        signals.add(new SignalInfo("purchase_acknowledged", String.class));
        signals.add(new SignalInfo("purchase_consumed", String.class));
        signals.add(new SignalInfo("purchase_restored", String.class, String.class));
        return signals;
    }

    @Override
    public View onMainCreate(Activity activity) {
        this.activity = activity;
        initializeBilling();
        return null;
    }

    @Override
    public void onMainDestroy() {
        if (billingClient != null) {
            billingClient.endConnection();
        }
    }

    @UsedByGodot
    public void initializeBilling() {
        if (activity == null) {
            emitSignal("billing_error", "Activity is not ready.");
            return;
        }
        if (billingClient == null) {
            PendingPurchasesParams pendingPurchasesParams = PendingPurchasesParams.newBuilder()
                    .enableOneTimeProducts()
                    .build();
            billingClient = BillingClient.newBuilder(activity)
                    .setListener(this)
                    .enablePendingPurchases(pendingPurchasesParams)
                    .enableAutoServiceReconnection()
                    .build();
        }
        connectIfNeeded();
    }

    @UsedByGodot
    public boolean isReady() {
        return billingClient != null && billingClient.isReady();
    }

    @UsedByGodot
    public boolean isProductAvailable(String productId) {
        return productDetails.containsKey(productId);
    }

    @UsedByGodot
    public String getProductPrice(String productId) {
        ProductDetails details = productDetails.get(productId);
        if (details == null) {
            return "";
        }
        return formattedPrice(details);
    }

    @UsedByGodot
    public String getProductType(String productId) {
        String type = productTypes.get(productId);
        return type == null ? "" : type;
    }

    @UsedByGodot
    public void queryProducts() {
        runWhenReady(() -> {
            queryProductType(BillingClient.ProductType.INAPP, inAppProducts);
            queryProductType(BillingClient.ProductType.SUBS, subscriptionProducts);
        });
    }

    @UsedByGodot
    public void restorePurchases() {
        runWhenReady(() -> {
            queryPurchases(BillingClient.ProductType.INAPP);
            queryPurchases(BillingClient.ProductType.SUBS);
        });
    }

    @UsedByGodot
    public void purchase(String productId) {
        runWhenReady(() -> {
            ProductDetails details = productDetails.get(productId);
            if (details == null) {
                emitSignal("purchase_failed", productId, "Product details are not loaded.");
                queryProducts();
                return;
            }
            BillingFlowParams.ProductDetailsParams.Builder productParams =
                    BillingFlowParams.ProductDetailsParams.newBuilder().setProductDetails(details);
            String offerToken = offerToken(details);
            if (!offerToken.isEmpty()) {
                productParams.setOfferToken(offerToken);
            }
            BillingFlowParams flowParams = BillingFlowParams.newBuilder()
                    .setProductDetailsParamsList(Arrays.asList(productParams.build()))
                    .build();
            BillingResult result = billingClient.launchBillingFlow(activity, flowParams);
            if (result.getResponseCode() != BillingClient.BillingResponseCode.OK) {
                emitSignal("purchase_failed", productId, result.getDebugMessage());
            }
        });
    }

    @Override
    public void onPurchasesUpdated(@NonNull BillingResult billingResult, List<Purchase> purchases) {
        int code = billingResult.getResponseCode();
        if (code == BillingClient.BillingResponseCode.OK && purchases != null) {
            for (Purchase purchase : purchases) {
                handlePurchase(purchase, false);
            }
        } else if (code == BillingClient.BillingResponseCode.USER_CANCELED) {
            emitSignal("purchase_cancelled", "");
        } else {
            emitSignal("purchase_failed", "", billingResult.getDebugMessage());
        }
    }

    private void connectIfNeeded() {
        if (billingClient == null || billingClient.isReady() || connecting) {
            return;
        }
        connecting = true;
        billingClient.startConnection(new BillingClientStateListener() {
            @Override
            public void onBillingSetupFinished(@NonNull BillingResult billingResult) {
                connecting = false;
                if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                    emitSignal("billing_ready");
                    queryProducts();
                    restorePurchases();
                } else {
                    emitSignal("billing_error", billingResult.getDebugMessage());
                }
            }

            @Override
            public void onBillingServiceDisconnected() {
                connecting = false;
                emitSignal("billing_disconnected");
            }
        });
    }

    private void runWhenReady(Runnable action) {
        if (activity == null) {
            emitSignal("billing_error", "Activity is not ready.");
            return;
        }
        runOnUiThread(() -> {
            if (billingClient != null && billingClient.isReady()) {
                action.run();
            } else {
                initializeBilling();
            }
        });
    }

    private void queryProductType(String productType, List<String> ids) {
        List<QueryProductDetailsParams.Product> products = new ArrayList<>();
        for (String id : ids) {
            products.add(QueryProductDetailsParams.Product.newBuilder()
                    .setProductId(id)
                    .setProductType(productType)
                    .build());
        }
        QueryProductDetailsParams params = QueryProductDetailsParams.newBuilder()
                .setProductList(products)
                .build();
        billingClient.queryProductDetailsAsync(params, (BillingResult result, QueryProductDetailsResult detailsResult) -> {
            if (result.getResponseCode() != BillingClient.BillingResponseCode.OK) {
                emitSignal("billing_error", result.getDebugMessage());
                return;
            }
            for (ProductDetails details : detailsResult.getProductDetailsList()) {
                productDetails.put(details.getProductId(), details);
                productTypes.put(details.getProductId(), details.getProductType());
                emitSignal(
                        "product_details",
                        details.getProductId(),
                        details.getProductType(),
                        details.getTitle(),
                        formattedPrice(details)
                );
            }
            for (UnfetchedProduct product : detailsResult.getUnfetchedProductList()) {
                emitSignal("product_unavailable", product.getProductId(), String.valueOf(product.getStatusCode()));
            }
        });
    }

    private void queryPurchases(String productType) {
        QueryPurchasesParams params = QueryPurchasesParams.newBuilder()
                .setProductType(productType)
                .build();
        billingClient.queryPurchasesAsync(params, (BillingResult result, List<Purchase> purchases) -> {
            if (result.getResponseCode() != BillingClient.BillingResponseCode.OK) {
                emitSignal("billing_error", result.getDebugMessage());
                return;
            }
            for (Purchase purchase : purchases) {
                handlePurchase(purchase, true);
            }
        });
    }

    private void handlePurchase(Purchase purchase, boolean restored) {
        if (purchase.getPurchaseState() == Purchase.PurchaseState.PENDING) {
            for (String productId : purchase.getProducts()) {
                emitSignal("purchase_pending", productId);
            }
            return;
        }
        if (purchase.getPurchaseState() != Purchase.PurchaseState.PURCHASED) {
            return;
        }
        for (String productId : purchase.getProducts()) {
            if (consumableProducts.contains(productId)) {
                consumePurchase(productId, purchase, restored);
            } else if (!purchase.isAcknowledged()) {
                acknowledgePurchase(productId, purchase, restored);
            } else {
                grantPurchase(productId, purchase, restored);
            }
        }
    }

    private void grantPurchase(String productId, Purchase purchase, boolean restored) {
        if (restored) {
            emitSignal("purchase_restored", productId, purchase.getPurchaseToken());
        } else {
            emitSignal("purchase_completed", productId, purchase.getPurchaseToken());
        }
    }

    private void acknowledgePurchase(String productId, Purchase purchase, boolean restored) {
        AcknowledgePurchaseParams params = AcknowledgePurchaseParams.newBuilder()
                .setPurchaseToken(purchase.getPurchaseToken())
                .build();
        billingClient.acknowledgePurchase(params, result -> {
            if (result.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                emitSignal("purchase_acknowledged", productId);
                grantPurchase(productId, purchase, restored);
            } else {
                emitSignal("purchase_failed", productId, result.getDebugMessage());
            }
        });
    }

    private void consumePurchase(String productId, Purchase purchase, boolean restored) {
        ConsumeParams params = ConsumeParams.newBuilder()
                .setPurchaseToken(purchase.getPurchaseToken())
                .build();
        billingClient.consumeAsync(params, (BillingResult result, String token) -> {
            if (result.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                emitSignal("purchase_consumed", productId);
                grantPurchase(productId, purchase, restored);
            } else {
                emitSignal("purchase_failed", productId, result.getDebugMessage());
            }
        });
    }

    private String formattedPrice(ProductDetails details) {
        List<ProductDetails.OneTimePurchaseOfferDetails> oneTimeOffers = details.getOneTimePurchaseOfferDetailsList();
        if (oneTimeOffers != null && !oneTimeOffers.isEmpty()) {
            return oneTimeOffers.get(0).getFormattedPrice();
        }
        ProductDetails.OneTimePurchaseOfferDetails legacyOneTime = details.getOneTimePurchaseOfferDetails();
        if (legacyOneTime != null) {
            return legacyOneTime.getFormattedPrice();
        }
        List<ProductDetails.SubscriptionOfferDetails> subscriptionOffers = details.getSubscriptionOfferDetails();
        if (subscriptionOffers != null && !subscriptionOffers.isEmpty()
                && !subscriptionOffers.get(0).getPricingPhases().getPricingPhaseList().isEmpty()) {
            return subscriptionOffers.get(0).getPricingPhases().getPricingPhaseList().get(0).getFormattedPrice();
        }
        return "";
    }

    private String offerToken(ProductDetails details) {
        List<ProductDetails.OneTimePurchaseOfferDetails> oneTimeOffers = details.getOneTimePurchaseOfferDetailsList();
        if (oneTimeOffers != null && !oneTimeOffers.isEmpty()) {
            String token = oneTimeOffers.get(0).getOfferToken();
            return token == null ? "" : token;
        }
        List<ProductDetails.SubscriptionOfferDetails> subscriptionOffers = details.getSubscriptionOfferDetails();
        if (subscriptionOffers != null && !subscriptionOffers.isEmpty()) {
            String token = subscriptionOffers.get(0).getOfferToken();
            return token == null ? "" : token;
        }
        return "";
    }
}
