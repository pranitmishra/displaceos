# DisplaceOS - Lightweight Local Web Server (No Node.js Required)
# Run in PowerShell: .\start_server.ps1

$port = 3000
$prefix = "http://localhost:$port/"
$root = $PSScriptRoot

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  DisplaceOS - Disaster Relief Assistance Server" -ForegroundColor Green
Write-Host "  Serving from: $root" -ForegroundColor Gray
Write-Host "  URL: $prefix" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
    Write-Host "Server running at $prefix" -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the server." -ForegroundColor Gray
    
    # Open default browser
    Start-Process $prefix
} catch {
    Write-Host "Failed to start listener on port $port : $_" -ForegroundColor Red
    exit 1
}

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $urlPath = $request.Url.LocalPath
    if ($urlPath -eq "/" -or $urlPath -eq "") {
        $urlPath = "/index.html"
    }

    $filePath = Join-Path $root ($urlPath.TrimStart('/').Replace('/', '\'))

    if (Test-Path $filePath -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        switch ($ext) {
            ".html" { $response.ContentType = "text/html; charset=utf-8" }
            ".js"   { $response.ContentType = "application/javascript" }
            ".jsx"  { $response.ContentType = "text/plain" }
            ".css"  { $response.ContentType = "text/css" }
            ".json" { $response.ContentType = "application/json" }
            ".png"  { $response.ContentType = "image/png" }
            ".jpg"  { $response.ContentType = "image/jpeg" }
            ".svg"  { $response.ContentType = "image/svg+xml" }
            default { $response.ContentType = "application/octet-stream" }
        }

        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $response.StatusCode = 404
        $notFoundMsg = [System.Text.Encoding]::UTF8.GetBytes("404 - File Not Found")
        $response.ContentLength64 = $notFoundMsg.Length
        $response.OutputStream.Write($notFoundMsg, 0, $notFoundMsg.Length)
    }

    $response.OutputStream.Close()
}

