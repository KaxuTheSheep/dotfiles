param(
    [string]$ThemeName
)

# Paths
$ConfigDir = "$env:USERPROFILE\.config\komorebi"
$ThemesDir = Join-Path $ConfigDir "themes"

$JsonFiles = @("komorebi.json")

# If no theme is specified, list available themes
if (-not $ThemeName) {
    if (Test-Path $ThemesDir) {
        $AvailableThemes = Get-ChildItem -Path $ThemesDir -Filter "*.komorebi.json" | 
            ForEach-Object { ($_).BaseName -replace "\.komorebi$","" } |
            Sort-Object -Unique
        if ($AvailableThemes.Count -gt 0) {
            Write-Output "Available themes:"
            $AvailableThemes | ForEach-Object { Write-Output " - $_" }
        } else {
            Write-Output "No themes found in $ThemesDir"
        }
    } else {
        Write-Output "Themes folder does not exist: $ThemesDir"
    }
    return
}

# Apply the theme
foreach ($File in $JsonFiles) {
    $Source = Join-Path $ThemesDir "$ThemeName.$File"
    $Destination = Join-Path $ConfigDir $File

    if (Test-Path $Source) {
        Copy-Item -Path $Source -Destination $Destination -Force
        Write-Output "Applied theme '$ThemeName' to $File"
    } else {
        Write-Warning "Theme file not found: $Source"
    }
}

Write-Output "Theme '$ThemeName' applied. Komorebi should auto-reload."
