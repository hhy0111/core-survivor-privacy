package com.harness.coresurvivor.ads;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;
import org.godotengine.godot.plugin.UsedByGodot;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CoreSurvivorAdMobPlugin extends GodotPlugin {
    private static final String TAG = "CoreSurvivorAdMob";
    private static final String PLUGIN_NAME = "CoreSurvivorAdMob";
    private static final String TEST_REWARDED_ID = "ca-app-pub-3940256099942544/5224354917";

    private final Map<String, String> productionAdUnits = new HashMap<>();
    private final Map<String, RewardedAd> rewardedAds = new HashMap<>();
    private final Set<String> loadingPlacements = new HashSet<>();

    private Activity activity;
    private boolean initialized = false;

    public CoreSurvivorAdMobPlugin(Godot godot) {
        super(godot);
        productionAdUnits.put("daily_bonus", "ca-app-pub-4402708884038037/4886167222");
        productionAdUnits.put("free_chest", "ca-app-pub-4402708884038037/6772070321");
        productionAdUnits.put("level_reroll", "ca-app-pub-4402708884038037/9264395931");
        productionAdUnits.put("revive", "ca-app-pub-4402708884038037/5077738911");
        productionAdUnits.put("run_reward_2x", "ca-app-pub-4402708884038037/8352745300");
        productionAdUnits.put("temp_drone", "ca-app-pub-4402708884038037/5458988651");
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
                "preloadAllRewarded",
                "loadRewarded",
                "isRewardedReady",
                "showRewarded",
                "isUsingTestAds"
        );
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals() {
        Set<SignalInfo> signals = new HashSet<>();
        signals.add(new SignalInfo("ad_loaded", String.class));
        signals.add(new SignalInfo("ad_failed_to_load", String.class, String.class));
        signals.add(new SignalInfo("ad_rewarded", String.class));
        signals.add(new SignalInfo("ad_closed", String.class));
        signals.add(new SignalInfo("ad_failed_to_show", String.class, String.class));
        return signals;
    }

    @Override
    public View onMainCreate(Activity activity) {
        this.activity = activity;
        initializeSdk();
        return null;
    }

    @Override
    public void onMainResume() {
        preloadAllRewarded();
    }

    @UsedByGodot
    public void preloadAllRewarded() {
        for (String placement : productionAdUnits.keySet()) {
            loadRewarded(placement);
        }
    }

    @UsedByGodot
    public void loadRewarded(final String placement) {
        if (!productionAdUnits.containsKey(placement)) {
            emitSignal("ad_failed_to_load", placement, "Unknown placement: " + placement);
            return;
        }
        if (activity == null) {
            emitSignal("ad_failed_to_load", placement, "Activity is not ready.");
            return;
        }
        if (loadingPlacements.contains(placement) || rewardedAds.containsKey(placement)) {
            return;
        }
        runOnUiThread(() -> {
            loadingPlacements.add(placement);
            RewardedAd.load(
                    activity,
                    resolveAdUnitId(placement),
                    new AdRequest.Builder().build(),
                    new RewardedAdLoadCallback() {
                        @Override
                        public void onAdLoaded(@NonNull RewardedAd rewardedAd) {
                            loadingPlacements.remove(placement);
                            rewardedAds.put(placement, rewardedAd);
                            emitSignal("ad_loaded", placement);
                        }

                        @Override
                        public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
                            loadingPlacements.remove(placement);
                            rewardedAds.remove(placement);
                            String message = loadAdError.getMessage();
                            Log.w(TAG, "Rewarded ad failed to load: " + placement + " / " + message);
                            emitSignal("ad_failed_to_load", placement, message);
                        }
                    }
            );
        });
    }

    @UsedByGodot
    public boolean isRewardedReady(String placement) {
        return rewardedAds.containsKey(placement);
    }

    @UsedByGodot
    public void showRewarded(final String placement) {
        if (activity == null) {
            emitSignal("ad_failed_to_show", placement, "Activity is not ready.");
            return;
        }
        runOnUiThread(() -> {
            RewardedAd ad = rewardedAds.remove(placement);
            if (ad == null) {
                emitSignal("ad_failed_to_show", placement, "Rewarded ad is not ready.");
                loadRewarded(placement);
                return;
            }
            ad.setFullScreenContentCallback(new FullScreenContentCallback() {
                @Override
                public void onAdDismissedFullScreenContent() {
                    emitSignal("ad_closed", placement);
                    loadRewarded(placement);
                }

                @Override
                public void onAdFailedToShowFullScreenContent(@NonNull AdError adError) {
                    String message = adError.getMessage();
                    Log.w(TAG, "Rewarded ad failed to show: " + placement + " / " + message);
                    emitSignal("ad_failed_to_show", placement, message);
                    loadRewarded(placement);
                }

                @Override
                public void onAdShowedFullScreenContent() {
                    Log.d(TAG, "Rewarded ad showed: " + placement);
                }
            });
            ad.show(activity, rewardItem -> emitSignal("ad_rewarded", placement));
        });
    }

    @UsedByGodot
    public boolean isUsingTestAds() {
        return isDebuggable();
    }

    private void initializeSdk() {
        if (initialized || activity == null) {
            return;
        }
        initialized = true;
        new Thread(() -> MobileAds.initialize(activity, initializationStatus -> preloadAllRewarded())).start();
    }

    private String resolveAdUnitId(String placement) {
        if (isDebuggable()) {
            return TEST_REWARDED_ID;
        }
        return productionAdUnits.get(placement);
    }

    private boolean isDebuggable() {
        if (activity == null) {
            return true;
        }
        return (activity.getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;
    }
}
