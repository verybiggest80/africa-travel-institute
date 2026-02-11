$files = @(
    "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\TZ_article_04.html",
    "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\TZ_article_05.html",
    "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\TZ_article_06.html",
    "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\TZ_article_07.html",
    "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\TZ_article_08.html",
    "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\TZ_article_09.html"
)

foreach ($file in $files) {
    Write-Host "Processing: $(Split-Path -Leaf $file)"
    $content = Get-Content -Path $file -Raw-Encoding UTF8
    
    # Replace GA4 head code with GTM
    $content = $content -replace '(?s)    <!-- Google tag \(gtag\.js\) -->.*?    </script>', @'
    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-5ZDPBZM8');</script>
    <!-- End Google Tag Manager -->
'@
    
    # Add noscript to body if not present
    if ($content -notmatch "Google Tag Manager \(noscript\)") {
        $content = $content -replace '(<body[^>]*>)\r?\n(\r?\n)?    <header>', @'
$1

    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5ZDPBZM8"
    height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->

    <header>
'@
    }
    
    Set-Content -Path $file -Value $content -Encoding UTF8 -NoNewline
    Write-Host "  ✓ Completed"
}

Write-Host "`n✅ All article files updated with GTM code!"
