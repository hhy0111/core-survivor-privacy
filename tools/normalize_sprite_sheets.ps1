param(
    [string]$Root = ".",
    [string]$OutputDir = "assets/images/normalized",
    [switch]$IncludeNextContent
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$source = @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

public static class SpriteSheetNormalizer
{
    public static void Normalize(string inputPath, string outputPath, int columns, int rows, int highAlpha, int copyAlpha, int margin, bool darkAnchor)
    {
        using (var src = new Bitmap(inputPath))
        using (var dst = new Bitmap(src.Width, src.Height, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(dst))
        {
            g.Clear(Color.Transparent);
            dst.SetResolution(src.HorizontalResolution, src.VerticalResolution);

            for (int row = 0; row < rows; row++)
            {
                for (int frame = 0; frame < columns; frame++)
                {
                    NormalizeCell(src, dst, columns, rows, frame, row, highAlpha, copyAlpha, margin, darkAnchor);
                }
            }

            Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
            dst.Save(outputPath, ImageFormat.Png);
        }
    }

    public static void RemapRow(string imagePath, int columns, int rows, int row, int[] sourceFrames)
    {
        string tempPath = imagePath + ".tmp.png";
        using (var src = new Bitmap(imagePath))
        using (var dst = new Bitmap(src.Width, src.Height, PixelFormat.Format32bppArgb))
        {
            for (int y = 0; y < src.Height; y++)
            {
                for (int x = 0; x < src.Width; x++)
                {
                    dst.SetPixel(x, y, src.GetPixel(x, y));
                }
            }

            int width = src.Width;
            int height = src.Height;
            row = Clamp(row, 0, rows - 1);
            for (int frame = 0; frame < columns; frame++)
            {
                int sourceFrame = sourceFrames[frame % sourceFrames.Length];
                sourceFrame = Clamp(sourceFrame, 0, columns - 1);

                int srcX0 = Clamp((int)Math.Round((double)width * sourceFrame / columns), 0, width - 1);
                int dstX0 = Clamp((int)Math.Round((double)width * frame / columns), 0, width - 1);
                int cellW = Clamp((int)Math.Round((double)width * (frame + 1) / columns) - 1, dstX0, width - 1) - dstX0 + 1;
                int y0 = Clamp((int)Math.Round((double)height * row / rows), 0, height - 1);
                int y1 = Clamp((int)Math.Round((double)height * (row + 1) / rows) - 1, y0, height - 1);

                for (int yy = y0; yy <= y1; yy++)
                {
                    for (int xx = 0; xx < cellW; xx++)
                    {
                        dst.SetPixel(dstX0 + xx, yy, src.GetPixel(srcX0 + xx, yy));
                    }
                }
            }

            dst.Save(tempPath, ImageFormat.Png);
        }
        File.Delete(imagePath);
        File.Move(tempPath, imagePath);
    }

    public static void RebuildRowFromSource(string inputPath, string outputPath, int columns, int rows, int row, int[] sourceFrames, int copyAlpha, bool darkAnchor)
    {
        string tempPath = outputPath + ".tmp.png";
        using (var src = new Bitmap(inputPath))
        using (var current = new Bitmap(outputPath))
        using (var dst = new Bitmap(current.Width, current.Height, PixelFormat.Format32bppArgb))
        {
            for (int y = 0; y < current.Height; y++)
            {
                for (int x = 0; x < current.Width; x++)
                {
                    dst.SetPixel(x, y, current.GetPixel(x, y));
                }
            }

            int width = src.Width;
            int height = src.Height;
            row = Clamp(row, 0, rows - 1);
            int cellW = Clamp((int)Math.Round((double)width / columns), 1, width);
            int cellH = Clamp((int)Math.Round((double)height / rows), 1, height);
            double centerX = (cellW - 1) * 0.5;
            double centerY = (cellH - 1) * 0.5;

            for (int frame = 0; frame < columns; frame++)
            {
                int dstX0 = Clamp((int)Math.Round((double)width * frame / columns), 0, width - 1);
                int dstX1 = Clamp((int)Math.Round((double)width * (frame + 1) / columns) - 1, dstX0, width - 1);
                int dstY0 = Clamp((int)Math.Round((double)height * row / rows), 0, height - 1);
                int dstY1 = Clamp((int)Math.Round((double)height * (row + 1) / rows) - 1, dstY0, height - 1);
                for (int yy = dstY0; yy <= dstY1; yy++)
                {
                    for (int xx = dstX0; xx <= dstX1; xx++)
                    {
                        dst.SetPixel(xx, yy, Color.Transparent);
                    }
                }

                int sourceFrame = Clamp(sourceFrames[frame % sourceFrames.Length], 0, columns - 1);
                int srcX0 = Clamp((int)Math.Round((double)width * sourceFrame / columns), 0, width - 1);
                int srcX1 = Clamp((int)Math.Round((double)width * (sourceFrame + 1) / columns) - 1, srcX0, width - 1);
                int srcY0 = dstY0;
                int srcY1 = dstY1;
                Bounds bounds = FindAlphaBounds(src, srcX0, srcX1, srcY0, srcY1, copyAlpha);
                if (!bounds.Found)
                    continue;

                double anchorX = 0.0;
                double anchorY = 0.0;
                double weight = 0.0;
                if (darkAnchor)
                {
                    for (int sy = srcY0; sy <= srcY1; sy++)
                    {
                        for (int sx = srcX0; sx <= srcX1; sx++)
                        {
                            Color c = src.GetPixel(sx, sy);
                            if (!IsCoreBodyPixel(c))
                                continue;
                            double a = c.A / 255.0;
                            anchorX += (sx - srcX0) * a;
                            anchorY += (sy - srcY0) * a;
                            weight += a;
                        }
                    }
                }
                if (weight < 20.0)
                {
                    anchorX = (bounds.MinX + bounds.MaxX) * 0.5 - srcX0;
                    anchorY = (bounds.MinY + bounds.MaxY) * 0.5 - srcY0;
                }
                else
                {
                    anchorX /= weight;
                    anchorY /= weight;
                }

                int boundsW = bounds.MaxX - bounds.MinX + 1;
                int boundsH = bounds.MaxY - bounds.MinY + 1;
                double scale = Math.Min(1.0, Math.Min((cellW - 20.0) / boundsW, (cellH - 20.0) / boundsH));
                for (int sy = srcY0; sy <= srcY1; sy++)
                {
                    for (int sx = srcX0; sx <= srcX1; sx++)
                    {
                        Color c = src.GetPixel(sx, sy);
                        if (c.A < copyAlpha || IsCheckerPixel(c))
                            continue;
                        int tx = (int)Math.Round(dstX0 + centerX + ((sx - srcX0) - anchorX) * scale);
                        int ty = (int)Math.Round(dstY0 + centerY + ((sy - srcY0) - anchorY) * scale);
                        if (tx < dstX0 || tx > dstX1 || ty < dstY0 || ty > dstY1)
                            continue;
                        if (c.A >= dst.GetPixel(tx, ty).A)
                            dst.SetPixel(tx, ty, c);
                    }
                }
            }

            dst.Save(tempPath, ImageFormat.Png);
        }
        File.Delete(outputPath);
        File.Move(tempPath, outputPath);
    }

    private static void NormalizeCell(Bitmap src, Bitmap dst, int columns, int rows, int frame, int row, int highAlpha, int copyAlpha, int margin, bool darkAnchor)
    {
        int width = src.Width;
        int height = src.Height;
        int x0 = Clamp((int)Math.Round((double)width * frame / columns), 0, width - 1);
        int x1 = Clamp((int)Math.Round((double)width * (frame + 1) / columns) - 1, x0, width - 1);
        int y0 = Clamp((int)Math.Round((double)height * row / rows), 0, height - 1);
        int y1 = Clamp((int)Math.Round((double)height * (row + 1) / rows) - 1, y0, height - 1);
        int cellW = x1 - x0 + 1;
        int cellH = y1 - y0 + 1;
        bool[] mask = new bool[cellW * cellH];
        bool[] visited = new bool[cellW * cellH];

        for (int yy = 0; yy < cellH; yy++)
        {
            for (int xx = 0; xx < cellW; xx++)
            {
                Color c = src.GetPixel(x0 + xx, y0 + yy);
                mask[yy * cellW + xx] = c.A >= highAlpha && !IsCheckerPixel(c);
            }
        }

        Component best = null;
        int[] dx = new int[] {-1, 0, 1, -1, 1, -1, 0, 1};
        int[] dy = new int[] {-1, -1, -1, 0, 0, 1, 1, 1};
        var queue = new Queue<int>();

        for (int start = 0; start < mask.Length; start++)
        {
            if (!mask[start] || visited[start])
                continue;

            var comp = new Component();
            queue.Clear();
            queue.Enqueue(start);
            visited[start] = true;

            while (queue.Count > 0)
            {
                int idx = queue.Dequeue();
                int lx = idx % cellW;
                int ly = idx / cellW;
                int ax = x0 + lx;
                int ay = y0 + ly;

                comp.Count++;
                comp.SumX += ax;
                comp.SumY += ay;
                if (ax < comp.MinX) comp.MinX = ax;
                if (ax > comp.MaxX) comp.MaxX = ax;
                if (ay < comp.MinY) comp.MinY = ay;
                if (ay > comp.MaxY) comp.MaxY = ay;

                for (int n = 0; n < 8; n++)
                {
                    int nx = lx + dx[n];
                    int ny = ly + dy[n];
                    if (nx < 0 || nx >= cellW || ny < 0 || ny >= cellH)
                        continue;
                    int ni = ny * cellW + nx;
                    if (mask[ni] && !visited[ni])
                    {
                        visited[ni] = true;
                        queue.Enqueue(ni);
                    }
                }
            }

            if (comp.Count >= 10 && (best == null || comp.Count > best.Count))
                best = comp;
        }

        if (best == null)
            return;

        int cropX0 = Clamp(best.MinX - margin, x0, x1);
        int cropX1 = Clamp(best.MaxX + margin, x0, x1);
        int cropY0 = Clamp(best.MinY - margin, y0, y1);
        int cropY1 = Clamp(best.MaxY + margin, y0, y1);

        double anchorX = best.SumX / best.Count;
        double anchorY = best.SumY / best.Count;
        if (darkAnchor)
        {
            double darkSumX = 0.0;
            double darkSumY = 0.0;
            double darkWeight = 0.0;
            for (int sy = cropY0; sy <= cropY1; sy++)
            {
                for (int sx = cropX0; sx <= cropX1; sx++)
                {
                    Color c = src.GetPixel(sx, sy);
                    if (!IsCoreBodyPixel(c))
                        continue;
                    double a = c.A / 255.0;
                    darkSumX += sx * a;
                    darkSumY += sy * a;
                    darkWeight += a;
                }
            }
            if (darkWeight >= 20.0)
            {
                anchorX = darkSumX / darkWeight;
                anchorY = darkSumY / darkWeight;
            }
        }

        double destCenterX = (x0 + x1) * 0.5;
        double destCenterY = (y0 + y1) * 0.5;

        for (int sy = cropY0; sy <= cropY1; sy++)
        {
            for (int sx = cropX0; sx <= cropX1; sx++)
            {
                Color c = src.GetPixel(sx, sy);
                if (c.A < copyAlpha || IsCheckerPixel(c))
                    continue;

                int tx = (int)Math.Round(sx - anchorX + destCenterX);
                int ty = (int)Math.Round(sy - anchorY + destCenterY);
                if (tx < x0 || tx > x1 || ty < y0 || ty > y1)
                    continue;

                dst.SetPixel(tx, ty, c);
            }
        }
    }

    private static int Clamp(int value, int min, int max)
    {
        if (value < min) return min;
        if (value > max) return max;
        return value;
    }

    private static bool IsCheckerPixel(Color c)
    {
        return false;
    }

    private static bool IsCoreBodyPixel(Color c)
    {
        return c.A > 50 && c.R < 95 && c.G < 170 && c.B < 190;
    }

    private static Bounds FindAlphaBounds(Bitmap src, int x0, int x1, int y0, int y1, int copyAlpha)
    {
        var bounds = new Bounds();
        for (int y = y0; y <= y1; y++)
        {
            for (int x = x0; x <= x1; x++)
            {
                Color c = src.GetPixel(x, y);
                if (c.A < copyAlpha || IsCheckerPixel(c))
                    continue;
                bounds.Found = true;
                if (x < bounds.MinX) bounds.MinX = x;
                if (x > bounds.MaxX) bounds.MaxX = x;
                if (y < bounds.MinY) bounds.MinY = y;
                if (y > bounds.MaxY) bounds.MaxY = y;
            }
        }
        return bounds;
    }

    private sealed class Component
    {
        public int Count = 0;
        public int MinX = int.MaxValue;
        public int MaxX = int.MinValue;
        public int MinY = int.MaxValue;
        public int MaxY = int.MinValue;
        public double SumX = 0.0;
        public double SumY = 0.0;
    }

    private sealed class Bounds
    {
        public bool Found = false;
        public int MinX = int.MaxValue;
        public int MaxX = int.MinValue;
        public int MinY = int.MaxValue;
        public int MaxY = int.MinValue;
    }
}
"@

Add-Type -TypeDefinition $source -ReferencedAssemblies System.Drawing

$sheetConfigs = @(
    @{ Name = "core_purify_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 58; DarkAnchor = $true; StableIdleMap = [int[]](1, 2, 3, 4, 3, 2) },
    @{ Name = "core_attack_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 58; DarkAnchor = $true; StableIdleMap = [int[]](1, 2, 3, 4, 3, 2) },
    @{ Name = "core_absorb_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 58; DarkAnchor = $true; SourceIdleMap = [int[]](0, 1, 5, 1, 0, 5); SourceRows = [int[]](0, 1, 2, 3) },
    @{ Name = "enemy_drifter_sheet.png"; Columns = 8; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 42; DarkAnchor = $false },
    @{ Name = "enemy_chaser_sheet.png"; Columns = 8; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 42; DarkAnchor = $false },
    @{ Name = "enemy_bulwark_sheet.png"; Columns = 8; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 44; DarkAnchor = $false },
    @{ Name = "enemy_splitter_sheet.png"; Columns = 8; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 44; DarkAnchor = $false },
    @{ Name = "enemy_elite_guard_sheet.png"; Columns = 8; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 54; DarkAnchor = $false },
    @{ Name = "enemy_boss_warden_sheet.png"; Columns = 8; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 60; DarkAnchor = $false; StableIdleMap = [int[]](6, 7, 6, 7, 6, 7, 6, 7); StableRows = [int[]](0, 1, 2, 3) },
    @{ Name = "drone_purify_sheet.png"; Columns = 6; Rows = 3; HighAlpha = 64; CopyAlpha = 8; Margin = 46; DarkAnchor = $false },
    @{ Name = "projectile_purify_bolt_sheet.png"; Columns = 8; Rows = 1; HighAlpha = 46; CopyAlpha = 8; Margin = 34; DarkAnchor = $false },
    @{ Name = "xp_blue_gem_sheet.png"; Columns = 6; Rows = 1; HighAlpha = 60; CopyAlpha = 8; Margin = 32; DarkAnchor = $false },
    @{ Name = "xp_large_gem_sheet.png"; Columns = 6; Rows = 1; HighAlpha = 60; CopyAlpha = 8; Margin = 36; DarkAnchor = $false }
)

if ($IncludeNextContent) {
    $sheetConfigs += @(
        @{ Name = "weapon_plasma_ring_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 36; CopyAlpha = 6; Margin = 22; DarkAnchor = $false },
        @{ Name = "weapon_spark_chain_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 18; DarkAnchor = $false },
        @{ Name = "weapon_laser_lance_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 14; DarkAnchor = $false },
        @{ Name = "weapon_purge_bomb_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 56; CopyAlpha = 8; Margin = 34; DarkAnchor = $false },
        @{ Name = "weapon_purge_bomb_explosion_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 18; DarkAnchor = $false },
        @{ Name = "evolution_photon_storm_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 16; DarkAnchor = $false },
        @{ Name = "evolution_comet_battery_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 36; CopyAlpha = 6; Margin = 24; DarkAnchor = $false },
        @{ Name = "evolution_solar_halo_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 36; CopyAlpha = 6; Margin = 22; DarkAnchor = $false },
        @{ Name = "evolution_thunder_web_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 16; DarkAnchor = $false },
        @{ Name = "evolution_rail_prism_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 14; DarkAnchor = $false },
        @{ Name = "evolution_cleanser_nova_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 20; DarkAnchor = $false },
        @{ Name = "drone_targeting_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 64; CopyAlpha = 8; Margin = 46; DarkAnchor = $false },
        @{ Name = "drone_capacitor_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 64; CopyAlpha = 8; Margin = 46; DarkAnchor = $false },
        @{ Name = "drone_shield_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 64; CopyAlpha = 8; Margin = 48; DarkAnchor = $false },
        @{ Name = "drone_magnet_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 64; CopyAlpha = 8; Margin = 48; DarkAnchor = $false },
        @{ Name = "drone_repair_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 64; CopyAlpha = 8; Margin = 46; DarkAnchor = $false },
        @{ Name = "enemy_stage2_solar_imp_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 42; DarkAnchor = $false },
        @{ Name = "enemy_stage2_flare_chaser_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 42; DarkAnchor = $false },
        @{ Name = "enemy_stage2_ember_tank_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 50; DarkAnchor = $false },
        @{ Name = "enemy_stage2_splitter_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 44; DarkAnchor = $false },
        @{ Name = "enemy_stage2_elite_guard_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 54; DarkAnchor = $false },
        @{ Name = "enemy_stage2_boss_solar_devourer_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 72; CopyAlpha = 8; Margin = 60; DarkAnchor = $false },
        @{ Name = "boss_stage2_flame_wave_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 16; DarkAnchor = $false },
        @{ Name = "boss_stage2_meteor_impact_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 18; DarkAnchor = $false },
        @{ Name = "boss_stage2_solar_laser_sheet.png"; Columns = 6; Rows = 4; HighAlpha = 34; CopyAlpha = 6; Margin = 14; DarkAnchor = $false }
    )
}

$rootPath = Resolve-Path $Root
$outPath = Join-Path $rootPath $OutputDir
New-Item -ItemType Directory -Force -Path $outPath | Out-Null

foreach ($config in $sheetConfigs) {
    $input = Join-Path $rootPath ("assets/images/" + $config.Name)
    $output = Join-Path $outPath $config.Name
    if (-not (Test-Path $input)) {
        Write-Warning "Missing source sheet: $input"
        continue
    }

    [SpriteSheetNormalizer]::Normalize(
        $input,
        $output,
        [int]$config.Columns,
        [int]$config.Rows,
        [int]$config.HighAlpha,
        [int]$config.CopyAlpha,
        [int]$config.Margin,
        [bool]$config.DarkAnchor
    )
    if ($config.ContainsKey("SourceIdleMap")) {
        $sourceRows = @(0)
        if ($config.ContainsKey("SourceRows")) {
            $sourceRows = @($config.SourceRows)
        }
        foreach ($sourceRow in $sourceRows) {
            [SpriteSheetNormalizer]::RebuildRowFromSource(
                $input,
                $output,
                [int]$config.Columns,
                [int]$config.Rows,
                [int]$sourceRow,
                [int[]]$config.SourceIdleMap,
                [int]$config.CopyAlpha,
                [bool]$config.DarkAnchor
            )
        }
        Write-Host "rebuilt rows $([string]::Join(',', [int[]]$sourceRows)) $($config.Name) from source frame map $([string]::Join(',', [int[]]$config.SourceIdleMap))"
    }
    elseif ($config.ContainsKey("StableIdleMap")) {
        $stableRows = @(0)
        if ($config.ContainsKey("StableRows")) {
            $stableRows = @($config.StableRows)
        }
        foreach ($stableRow in $stableRows) {
            [SpriteSheetNormalizer]::RemapRow(
                $output,
                [int]$config.Columns,
                [int]$config.Rows,
                [int]$stableRow,
                [int[]]$config.StableIdleMap
            )
        }
        Write-Host "stabilized rows $([string]::Join(',', [int[]]$stableRows)) $($config.Name) with frame map $([string]::Join(',', [int[]]$config.StableIdleMap))"
    }
    Write-Host "normalized $($config.Name) -> $OutputDir/$($config.Name)"
}
