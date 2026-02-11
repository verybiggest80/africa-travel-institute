# Finish GTM Replacement for All Article Files
# This script will replace the remaining article files

$files = @(
    "TZ_article_02.html",
    "TZ_article_03.html",
    "TZ_article_04.html",
    "TZ_article_05.html",
    "TZ_article_06.html",
    "TZ_article_07.html",
    "TZ_article_08.html",
    "TZ_article_09.html",
    "article-template.html"
)

$basePath = "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\"

foreach ($file in $files) {
    $fullPath = Join-Path $basePath $file
    $content = Get-Content -Path $fullPath -Raw -Encoding UTF8
    
    # Replace GA4 with GTM in head
    $content = $content -replace '(?s)  <!-- Google tag \(gtag\.js\) -->.*?</script>', @'
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-5ZDPBZM8');</script>
  <!-- End Google Tag Manager -->
'@
    
    # Add noscript if not present  
    if ($content -notm atch 'Google Tag Manager \(noscript\)') {
        $content = $content -replace '(<body[^>]*>)', @'
$1
  <!-- Google Tag Manager (noscript) -->
  <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5ZDPBZM8"
  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
'@
    }
    
    Set-Content -Path $fullPath -Value $content -Encoding UTF8 -NoNewline
    Write-Host "✓ $file"
}

Write-Host "`nAll article files updated!"
