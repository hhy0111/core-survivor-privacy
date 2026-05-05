param(
    [string]$IndexPath = "builds/web/index.html"
)

$resolved = Resolve-Path -LiteralPath $IndexPath -ErrorAction Stop
$html = Get-Content -LiteralPath $resolved -Raw -Encoding UTF8

$html = $html -replace '<html lang="en">', '<html lang="ko">'
$html = $html -replace '<canvas id="canvas">', '<canvas id="canvas" width="720" height="1280">'
$html = $html -replace '"canvasResizePolicy":\d+', '"canvasResizePolicy":0'
$html = $html -replace '<img id="status-splash" src="index.png" alt="">', ''
$html = $html -replace '#status-progress, #status-notice \{\s*display: none;\s*\}', "#status-progress, #status-notice {`n`t display: none;`n}`n`n#status-splash, #status-progress {`n`t display: none !important;`n}"
$html = $html -replace 'background-color: #242424;', 'background-color: #050813;'
$html = $html -replace 'setStatusMode\(''progress''\);', 'setStatusMode(''hidden'');'

$phoneCss = @'

html, body {
	width: 100%;
	height: 100%;
}

body {
	display: flex;
	justify-content: center;
	align-items: center;
	background-color: #050813;
}

#canvas {
	width: min(100vw, calc(100vh * 9 / 16)) !important;
	height: min(100vh, calc(100vw * 16 / 9)) !important;
	max-width: 100vw !important;
	max-height: 100vh !important;
	position: static !important;
}
'@

if ($html -notmatch 'calc\(100vh \* 9 / 16\).*important') {
    $html = $html -replace '</style>', "$phoneCss`n`t`t</style>"
}

Set-Content -LiteralPath $resolved -Value $html -Encoding UTF8
