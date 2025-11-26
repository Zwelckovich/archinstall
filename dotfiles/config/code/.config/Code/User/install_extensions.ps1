# Title: Batch Install VS Code Extensions
# Description: Reads extension IDs from extensions.txt and installs them using the VS Code CLI.

$extensionFile = "extensions.txt"

# 1. Check if extensions.txt exists in the current folder
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

# 3. The Main Loop (The command you requested, but improved)
Get-Content $extensionFile | ForEach-Object {
    # Clean whitespace and ignore empty lines
    $ext = $_.Trim()
    
    if (-not [string]::IsNullOrWhiteSpace($ext)) {
        Write-Host "Installing extension: $ext" -ForegroundColor Green
        
        # Run the install command
        code --install-extension $ext
    }
}

Write-Host "--------------------------------" -ForegroundColor Cyan
Write-Host "All installation commands processed." -ForegroundColor Cyan