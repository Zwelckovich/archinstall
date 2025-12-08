# Title: Batch Install VS Code Extensions
# Description: Reads extension IDs from code_extensions.txt and installs them using the VS Code CLI.

$extensionFile = "code_extensions.txt"

# 1. Check if code_extensions.txt exists in the current folder
if (-not (Test-Path $extensionFile)) {
    Write-Host "Error: Could not find '$extensionFile' in the current directory." -ForegroundColor Red
    Write-Host "Please create the file or move this script to the correct folder."
    exit
}

# 2. Check if VS Code CLI is available
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "Error: The 'code' command is not found." -ForegroundColor Red
    Write-Host "Please ensure VS Code is installed and added to your PATH."
    exit
}

Write-Host "Starting installation from $extensionFile..." -ForegroundColor Cyan

# 3. Get list of already installed extensions (prevents V8 crash on re-install)
Write-Host "Checking installed extensions..." -ForegroundColor Cyan
$installedExtensions = (code --list-extensions 2>$null) | ForEach-Object { $_.ToLower() }

# 4. The Main Loop
Get-Content $extensionFile | ForEach-Object {
    # Clean whitespace and ignore empty lines
    $ext = $_.Trim()

    if (-not [string]::IsNullOrWhiteSpace($ext)) {
        # Check if extension is already installed (case-insensitive)
        if ($installedExtensions -contains $ext.ToLower()) {
            Write-Host "Skipping (already installed): $ext" -ForegroundColor Cyan
            return
        }

        Write-Host "Installing extension: $ext" -ForegroundColor Green

        # Run the install command
        code --install-extension $ext
    }
}

Write-Host "--------------------------------" -ForegroundColor Cyan
Write-Host "All installation commands processed." -ForegroundColor Cyan