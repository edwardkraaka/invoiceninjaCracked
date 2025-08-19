@php
// Dynamically find the React build files
$reactFiles = glob(public_path('react-app/react/index-*.js'));
$cssFiles = glob(public_path('react-app/react/index-*.css'));
$indexJs = $reactFiles ? basename($reactFiles[0]) : 'index.js';
$indexCss = $cssFiles ? basename($cssFiles[0]) : 'index.css';

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