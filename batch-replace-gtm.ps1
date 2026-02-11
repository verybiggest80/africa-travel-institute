# Batch GTM Replacement Script
$ErrorActionPreference = "Stop"

$articlesDir = "d:\非洲遊獵網站\Version Publish\africa-travel-institute\articles"

# Get all HTML files
$files = @(
    "$articlesDir\TZ_article_01.html",
    "$articlesDir\TZ_article_02.html",
    "$articlesDir\TZ_article_03.html",
    "$articlesDir\TZ_article_04.html",
    "$articlesDir\TZ_article_05.html",
    "$articlesDir\TZ_article_06.html",
    "$articlesDir\TZ_article_07.html",
    "$articlesDir\TZ_article_08.html",
    "$articlesDir\TZ_article_09.html",
    "$articlesDir\article-template.html"
)

$count = 0

foreach ($filePath in $files) {
    if (Test-Path $filePath) {
        $content = Get-Content -Path $filePath -Raw -Encoding UTF8
        
        # Check if file still has GA4 code
        if ($content -match 'gtag\.js\?id=G-C5QZ8626XV') {
            # Replace head section
            $content = $content -replace '(?s)  <!-- Google tag \(gtag\.js\) -->.*?gtag\(''config'', ''G-C5QZ8626XV''\);.*?\r\n  </script>', @'
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-5ZDPBZM8');</script>
  <!-- End Google Tag Manager -->
'@
            
            # Add noscript if not present
            if ($content -notmatch 'Google Tag Manager \(noscript\)') {
                $content = $ content -replace '(<body[^>]*>\r?\n)', "`$1  <!-- Google Tag Manager (noscript) -->`r`n  <noscript><iframe src=`"https://www.googletagmanager.com/ns.html?id=GTM-5ZDPBZM8`"`r`n  height=`"0`" width=`"0`" style=`"display:none;visibility:hidden`"></iframe></noscript>`r`n  <!-- End Google Tag Manager (noscript) -->`r`n"
            }
            
            Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
            $count++
            Write-Host "✓ Updated: $(Split-Path -Leaf $filePath)"
        } else {
            Write-Host "- Skipped (already updated): $(Split-Path -Leaf $filePath)"
        }
    }
}

Write-Host "`nProcessed $count files"
