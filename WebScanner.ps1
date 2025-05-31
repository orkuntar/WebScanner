 # Orkun Tarhan Web Scanner
Write-Host "========================================="
Write-Host "        Orkun Tarhan Web Scanner         "
Write-Host "=========================================`n"

# Ask for target URL
$target = Read-Host "Enter the full target URL (e.g., https://example.com)"

# Ask for application type
Write-Host "`nSelect application type:"
Write-Host "1. ASP.NET"
Write-Host "2. WordPress"
Write-Host "3. JavaScript (Static Site)"
$appChoice = Read-Host "Enter number (1-3)"

# Define platform-specific paths
$aspPaths = @(
    "trace.axd", "WebResource.axd", "ScriptResource.axd",
    "default.aspx", "index.aspx", "home.aspx", "login.aspx", "logout.aspx", "register.aspx",
    "forgotpassword.aspx", "resetpassword.aspx", "error.aspx", "search.aspx", "terms.aspx",
    "admin/", "admin/login.aspx", "adminpanel/", "panel/", "cms/", "dashboard/", "control/", "manage/",
    "service.asmx", "service.svc", "test.ashx", "api/", "api/help", "api/swagger",
    "web.config", "web.config.bak", "web.config.old", "web.config~", "global.asax", "machine.config",
    "app.config", "packages.config", "connectionStrings.config", "appsettings.json", ".env", ".git/",
    "uploads/", "upload/", "files/", "docs/", "import/", "export/", "downloads/", "static/", "content/",
    "App_Data/", "App_Code/", "App_Themes/", "App_Browsers/", "bin/", "ClientBin/",
    "debug/", "test/", "dev/", "temp/", "tmp/", "example/", "demo/", "sandbox/",
    "backup/", "backup.bak", "db.bak", "database.bak", ".old/", ".svn/", ".vs/", ".vscode/", "_old/"
)

$wpPaths = @(
    "wp-login.php", "wp-admin/", "wp-config.php", "wp-config-sample.php",
    "readme.html", "license.txt", "xmlrpc.php", "wp-json/", "wp-cron.php",
    "wp-comments-post.php", "wp-trackback.php",
    "wp-content/", "wp-content/plugins/", "wp-content/themes/", "wp-content/uploads/",
    "wp-includes/",
    "wp-config.php.bak", "wp-config.php~", "wp-config.old", ".htaccess", ".env", "debug.log",
    "wp-content/plugins/revslider/", "wp-content/plugins/adminer/", "wp-content/plugins/filemanager/",
    "wp-content/plugins/wp-file-manager/", "wp-content/plugins/wp-db-backup/",
    "vendor/", "composer.json", "composer.lock", ".git/", ".gitignore"
)

$jsPaths = @(
    "index.html", "home.html", "404.html", "about.html", "contact.html", "robots.txt",
    "sitemap.xml", "favicon.ico", "manifest.json", "service-worker.js",
    "main.js", "app.js", "bundle.js", "runtime.js", "config.js", "settings.js",
    "assets/", "js/", "css/", "img/", "images/", "media/", "static/", "fonts/", "public/", "dist/", "build/",
    ".env", ".env.production", ".env.local", ".git/", ".gitignore", ".vscode/",
    "test/", "debug/", "temp/", "example/", "mock/", "mock-api/", "api/",
    "__tests__/", "node_modules/", "package.json", "webpack.config.js", "vite.config.js"
)

# Match choice
switch ($appChoice) {
    "1" { $paths = $aspPaths; $appName = "ASP.NET" }
    "2" { $paths = $wpPaths; $appName = "WordPress" }
    "3" { $paths = $jsPaths; $appName = "JavaScript/Static Site" }
    default {
        Write-Host "Invalid selection. Exiting..."
        exit
    }
}

Write-Host "`n[*] Scanning $target for $appName-specific paths..."
Write-Host "---------------------------------------------------`n"

foreach ($path in $paths) {
    $url = "$target/$path"
    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -ErrorAction Stop
        $statusCode = $response.StatusCode
    } catch {
        if ($_.Exception.Response -ne $null) {
            $statusCode = $_.Exception.Response.StatusCode.Value__
        } else {
            $statusCode = "Connection Failed"
        }
    }

    if ($statusCode -eq 200 -or $statusCode -eq 403 -or $statusCode -eq 500) {
        Write-Host "[+] $url --> $statusCode"
    }
}

Read-Host "`n[!] Scan complete. Press Enter to exit"
