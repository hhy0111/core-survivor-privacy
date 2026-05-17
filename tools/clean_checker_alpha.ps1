param(
    [Parameter(Mandatory = $true)]
    [string[]]$Paths,
    [int]$Columns = 1,
    [int]$Rows = 1
)

Add-Type -AssemblyName System.Drawing

$source = @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;

public static class CheckerAlphaCleaner
{
    private static bool IsBackground(byte r, byte g, byte b)
    {
        byte max = Math.Max(r, Math.Max(g, b));
        byte min = Math.Min(r, Math.Min(g, b));
        return r >= 205 && g >= 205 && b >= 205 && (max - min) <= 36;
    }

    private static int Index(int x, int y, int width)
    {
        return y * width + x;
    }

    public static void Clean(string path, int columns, int rows)
    {
        byte[] input = File.ReadAllBytes(path);
        using (var stream = new MemoryStream(input))
        using (var src = new Bitmap(stream))
        using (var bmp = new Bitmap(src.Width, src.Height, PixelFormat.Format32bppArgb))
        {
            using (var g = Graphics.FromImage(bmp))
            {
                g.DrawImage(src, 0, 0, src.Width, src.Height);
            }

            int width = bmp.Width;
            int height = bmp.Height;
            var rect = new Rectangle(0, 0, width, height);
            var data = bmp.LockBits(rect, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            int stride = data.Stride;
            int bytes = Math.Abs(stride) * height;
            byte[] pixels = new byte[bytes];
            Marshal.Copy(data.Scan0, pixels, 0, bytes);

            bool[] visited = new bool[width * height];
            Queue<int> queue = new Queue<int>();

            Action<int, int> trySeed = (x, y) =>
            {
                int idx = Index(x, y, width);
                if (visited[idx]) return;
                int p = y * stride + x * 4;
                if (IsBackground(pixels[p + 2], pixels[p + 1], pixels[p]))
                {
                    visited[idx] = true;
                    queue.Enqueue(idx);
                }
            };

            columns = Math.Max(1, columns);
            rows = Math.Max(1, rows);

            for (int x = 0; x < width; x++)
            {
                trySeed(x, 0);
                trySeed(x, height - 1);
            }
            for (int y = 0; y < height; y++)
            {
                trySeed(0, y);
                trySeed(width - 1, y);
            }

            for (int row = 0; row < rows; row++)
            {
                int y0 = (int)Math.Round(height * row / (double)rows);
                int y1 = (int)Math.Round(height * (row + 1) / (double)rows) - 1;
                y0 = Math.Max(0, Math.Min(height - 1, y0));
                y1 = Math.Max(0, Math.Min(height - 1, y1));
                for (int col = 0; col < columns; col++)
                {
                    int x0 = (int)Math.Round(width * col / (double)columns);
                    int x1 = (int)Math.Round(width * (col + 1) / (double)columns) - 1;
                    x0 = Math.Max(0, Math.Min(width - 1, x0));
                    x1 = Math.Max(0, Math.Min(width - 1, x1));
                    for (int x = x0; x <= x1; x++)
                    {
                        trySeed(x, y0);
                        trySeed(x, y1);
                    }
                    for (int y = y0; y <= y1; y++)
                    {
                        trySeed(x0, y);
                        trySeed(x1, y);
                    }
                }
            }

            int[] dx = new int[] { 1, -1, 0, 0 };
            int[] dy = new int[] { 0, 0, 1, -1 };

            while (queue.Count > 0)
            {
                int idx = queue.Dequeue();
                int x = idx % width;
                int y = idx / width;
                int p = y * stride + x * 4;
                pixels[p + 0] = 255;
                pixels[p + 1] = 255;
                pixels[p + 2] = 255;
                pixels[p + 3] = 0;

                for (int i = 0; i < 4; i++)
                {
                    int nx = x + dx[i];
                    int ny = y + dy[i];
                    if (nx < 0 || ny < 0 || nx >= width || ny >= height) continue;
                    int nidx = Index(nx, ny, width);
                    if (visited[nidx]) continue;
                    int np = ny * stride + nx * 4;
                    if (IsBackground(pixels[np + 2], pixels[np + 1], pixels[np + 0]))
                    {
                        visited[nidx] = true;
                        queue.Enqueue(nidx);
                    }
                }
            }

            Marshal.Copy(pixels, 0, data.Scan0, bytes);
            bmp.UnlockBits(data);

            string temp = path + ".clean.png";
            bmp.Save(temp, ImageFormat.Png);
            File.Copy(temp, path, true);
            File.Delete(temp);
        }
    }
}
"@

if (-not ("CheckerAlphaCleaner" -as [type])) {
    Add-Type -TypeDefinition $source -ReferencedAssemblies System.Drawing
}

foreach ($path in $Paths) {
    if ($path.EndsWith(".clean.png", [System.StringComparison]::OrdinalIgnoreCase)) {
        continue
    }
    $resolved = Resolve-Path -LiteralPath $path
    [CheckerAlphaCleaner]::Clean($resolved.Path, $Columns, $Rows)
    Write-Output "Cleaned $path (${Columns}x${Rows})"
}
