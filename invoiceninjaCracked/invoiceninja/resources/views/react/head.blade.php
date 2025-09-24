@php
// Dynamically find the React build files - sort by modification time to get the newest
$reactPath = public_path('react-app/react');
$jsFiles = [];
$cssFiles = [];

if (is_dir($reactPath)) {
    $files = scandir($reactPath);
    foreach ($files as $file) {
        // Look for index-*.js patterns
        if (preg_match('/^index-.*\.js$/', $file)) {
            $jsFiles[$file] = filemtime($reactPath . '/' . $file);
        }
        if (preg_match('/^index-.*\.css$/', $file)) {
            $cssFiles[$file] = filemtime($reactPath . '/' . $file);
        }
    }

    // Sort by modification time (newest first)
    arsort($jsFiles);
    arsort($cssFiles);
}

$indexJs = $jsFiles ? key($jsFiles) : 'index.js';
$indexCss = $cssFiles ? key($cssFiles) : 'index.css';

// Find other CSS files
$monacoFiles = glob(public_path('react-app/react/monaco-editor-*.css'));
$datepickerFiles = glob(public_path('react-app/react/react-datepicker-*.css'));
$phoneFiles = glob(public_path('react-app/react/react-phone-number-input-*.css'));

$monacoCss = $monacoFiles ? basename($monacoFiles[0]) : '';
$datepickerCss = $datepickerFiles ? basename($datepickerFiles[0]) : '';
$phoneCss = $phoneFiles ? basename($phoneFiles[0]) : '';
@endphp

<link rel="stylesheet" href="/react-app/react/{{ $indexCss }}">
@if($monacoCss)
<link rel="stylesheet" href="/react-app/react/{{ $monacoCss }}">
@endif
@if($datepickerCss)
<link rel="stylesheet" href="/react-app/react/{{ $datepickerCss }}">
@endif
@if($phoneCss)
<link rel="stylesheet" href="/react-app/react/{{ $phoneCss }}">
@endif
<script type="module" src="/react-app/react/{{ $indexJs }}"></script>