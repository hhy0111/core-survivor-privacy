param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies 'System.Drawing' -TypeDefinition @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;

public static class GeneratedUiAssetExtractor
{
    private static int Max3(int a, int b, int c) { return Math.Max(a, Math.Max(b, c)); }
    private static int Min3(int a, int b, int c) { return Math.Min(a, Math.Min(b, c)); }
    private static byte ClampByte(double value)
    {
        if (value <= 0) return 0;
        if (value >= 255) return 255;
        return (byte)Math.Round(value);
    }

    public static void SaveCutoutByColor(
        string sourcePath,
        string targetPath,
        int brightnessMin,
        int saturationMin,
        int pad,
        bool keepDarkInterior)
    {
        using (var sourceOriginal = new Bitmap(sourcePath))
        using (var source = new Bitmap(sourceOriginal.Width, sourceOriginal.Height, PixelFormat.Format32bppArgb))
        {
            using (var g = Graphics.FromImage(source))
            {
                g.DrawImage(sourceOriginal, 0, 0, sourceOriginal.Width, sourceOriginal.Height);
            }

            int width = source.Width;
            int height = source.Height;
            var rect = new Rectangle(0, 0, width, height);
            var data = source.LockBits(rect, ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
            byte[] pixels = new byte[data.Stride * height];
            Marshal.Copy(data.Scan0, pixels, 0, pixels.Length);
            source.UnlockBits(data);

            int[][] corners = new int[][] {
                new int[] { 2, 2 },
                new int[] { width - 3, 2 },
                new int[] { 2, height - 3 },
                new int[] { width - 3, height - 3 }
            };
            int bgR = 0, bgG = 0, bgB = 0;
            foreach (var corner in corners)
            {
                int offset = corner[1] * data.Stride + corner[0] * 4;
                bgB += pixels[offset + 0];
                bgG += pixels[offset + 1];
                bgR += pixels[offset + 2];
            }
            bgR /= 4;
            bgG /= 4;
            bgB /= 4;

            int xMin = width;
            int yMin = height;
            int xMax = -1;
            int yMax = -1;

            for (int y = 0; y < height; y++)
            {
                int row = y * data.Stride;
                for (int x = 0; x < width; x++)
                {
                    int offset = row + x * 4;
                    int b = pixels[offset + 0];
                    int g = pixels[offset + 1];
                    int r = pixels[offset + 2];
                    int brightness = Max3(r, g, b);
                    int saturation = brightness - Min3(r, g, b);
                    int diff = Math.Abs(r - bgR) + Math.Abs(g - bgG) + Math.Abs(b - bgB);
                    bool hit = brightness >= brightnessMin && saturation >= saturationMin;
                    if (keepDarkInterior) hit = hit || diff >= 70;
                    if (!hit) continue;

                    if (x < xMin) xMin = x;
                    if (x > xMax) xMax = x;
                    if (y < yMin) yMin = y;
                    if (y > yMax) yMax = y;
                }
            }

            if (xMax < xMin || yMax < yMin)
            {
                throw new InvalidOperationException("No foreground detected: " + sourcePath);
            }

            xMin = Math.Max(0, xMin - pad);
            yMin = Math.Max(0, yMin - pad);
            xMax = Math.Min(width - 1, xMax + pad);
            yMax = Math.Min(height - 1, yMax + pad);

            int outWidth = xMax - xMin + 1;
            int outHeight = yMax - yMin + 1;
            using (var output = new Bitmap(outWidth, outHeight, PixelFormat.Format32bppArgb))
            {
                var outRect = new Rectangle(0, 0, outWidth, outHeight);
                var outData = output.LockBits(outRect, ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);
                byte[] outPixels = new byte[outData.Stride * outHeight];

                for (int oy = 0; oy < outHeight; oy++)
                {
                    int srcRow = (yMin + oy) * data.Stride;
                    int dstRow = oy * outData.Stride;
                    for (int ox = 0; ox < outWidth; ox++)
                    {
                        int srcOffset = srcRow + (xMin + ox) * 4;
                        int dstOffset = dstRow + ox * 4;
                        int b = pixels[srcOffset + 0];
                        int g = pixels[srcOffset + 1];
                        int r = pixels[srcOffset + 2];
                        int brightness = Max3(r, g, b);
                        int saturation = brightness - Min3(r, g, b);
                        int diff = Math.Abs(r - bgR) + Math.Abs(g - bgG) + Math.Abs(b - bgB);
                        byte alpha;

                        if (keepDarkInterior)
                        {
                            alpha = ClampByte((diff - 24) * 4.0);
                        }
                        else
                        {
                            double alphaBySat = (saturation - (saturationMin - 12)) * 3.1;
                            double alphaByBright = (brightness - (brightnessMin - 20)) * 2.0;
                            alpha = ClampByte(Math.Max(alphaBySat, alphaByBright));
                        }

                        if (alpha < 18) alpha = 0;
                        outPixels[dstOffset + 0] = (byte)b;
                        outPixels[dstOffset + 1] = (byte)g;
                        outPixels[dstOffset + 2] = (byte)r;
                        outPixels[dstOffset + 3] = alpha;
                    }
                }

                Marshal.Copy(outPixels, 0, outData.Scan0, outPixels.Length);
                output.UnlockBits(outData);
                Directory.CreateDirectory(Path.GetDirectoryName(targetPath));
                output.Save(targetPath, ImageFormat.Png);
            }
        }
    }
}
"@

$imageDir = Join-Path $Root 'image'
$assetDir = Join-Path $Root 'assets\images'
if (!(Test-Path -LiteralPath $assetDir)) {
    New-Item -ItemType Directory -Path $assetDir | Out-Null
}

Copy-Item -LiteralPath (Join-Path $imageDir '05-item-10.png') -Destination (Join-Path $assetDir 'lobby_background_v2.png') -Force

[GeneratedUiAssetExtractor]::SaveCutoutByColor(
    (Join-Path $imageDir '04-ui-9-slice.png'),
    (Join-Path $assetDir 'ui_button_teal.png'),
    66,
    34,
    24,
    $false
)

[GeneratedUiAssetExtractor]::SaveCutoutByColor(
    (Join-Path $imageDir '06-ui.png'),
    (Join-Path $assetDir 'ui_panel_cosmic.png'),
    48,
    22,
    30,
    $true
)

[GeneratedUiAssetExtractor]::SaveCutoutByColor(
    (Join-Path $imageDir '05-item-08.png'),
    (Join-Path $assetDir 'ui_ad_reward_badge_v2.png'),
    78,
    30,
    32,
    $false
)

[GeneratedUiAssetExtractor]::SaveCutoutByColor(
    (Join-Path $imageDir '05-item-09.png'),
    (Join-Path $assetDir 'ui_daily_reward_badge.png'),
    78,
    30,
    32,
    $false
)

Write-Host "Extracted generated UI assets to $assetDir"
