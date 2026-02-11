# GTM Code Replacement Script for Article Pages
$articlePath = "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles\"
$files = Get-ChildItem -Path $articlePath -Filter "*.html"

$oldGA4Code = @'
  <!-- Google tag (gtag.js) -->
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-C5QZ8626XV"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag() { dataLayer.push(arguments); }
    gtag('js', new Date());

    gtag('config', 'G-C5QZ8626XV');
  </script>
'@

$newGTMCode = @'
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-5ZDPBZM8');</script>
  <!-- End Google Tag Manager -->
'@

$oldGA4Code = $oldGA4Code -replace "`r`n", "`n" -replace "`n", "`r`n"
$newGTMCode = $newGTMCode -replace "`r`n", "`n" -replace "`n", "`r`n"

$noscriptCode = @'

  <!-- Google Tag Manager (noscript) -->
  <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5ZDPBZM8"
  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
'@

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)"
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Replace GA4 code with GTM code
    $content = $content -replace [regex]::Escape($oldGA4Code), $newGTMCode
    
    # Add noscript after <body> tag if not already present
    if ($content -notmatch "Google Tag Manager \(noscript\)") {
        $content = $content -replace '(<body[^>]*>)', "`$1$noscriptCode"
    }
    
    # Save the updated content
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
    
    Write-Host "  ✓ Updated $($file.Name)"
}

Write-Host "`nCompleted replacement for $($files.Count) article files."
