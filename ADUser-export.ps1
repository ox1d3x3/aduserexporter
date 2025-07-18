# Set console colors and title
$Host.UI.RawUI.ForegroundColor = "Green"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
$Host.UI.RawUI.WindowTitle = "AD User Exporter - by X1 v0.2.6"

# Fancy Banner
Write-Host ""
Write-Host "        ================================" -ForegroundColor Cyan
Write-Host "          ___                      ___  " -ForegroundColor Cyan
Write-Host "         (o o)   AD User Exporter (o o) " -ForegroundColor Yellow
Write-Host "        (  V  )     by X1 v0.2.6 (  V  )" -ForegroundColor Yellow
Write-Host "        --m-m----------------------m-m--" -ForegroundColor Cyan
Write-Host ""
Write-Host "        GitHub : @ox1d3x3    Version: 0.2.6" -ForegroundColor DarkGray
Write-Host "       ===================================" -ForegroundColor Cyan
Write-Host ""

sleep 5

Write-Host " NOTE: Please double check the Raw input with the Stripped version" -ForegroundColor Red

sleep 5


# Load Active Directory module
Write-Host "[*] Loading Active Directory module..." -ForegroundColor Gray
Import-Module ActiveDirectory

# Get script directory
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }

# Set file paths
$rawExportPath = Join-Path $scriptDir "raw.csv"
$strippedExportPath = Join-Path $scriptDir "striped.csv"

# Exclusion keywords (case-insensitive match)
$excludedPatterns = @("admin", "svc", "service", "new era", "ingerop")

# Fetch active users with required attributes
Write-Host "[*] Fetching active AD users..." -ForegroundColor Gray
$activeUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties DisplayName, SamAccountName, Mail, Department, Company

# Export all active users to raw.csv
Write-Host "[+] Exporting raw list to raw.csv..." -ForegroundColor Green
$activeUsers |
    Select-Object DisplayName, SamAccountName, Mail, Department, Company |
    Export-Csv -Path $rawExportPath -NoTypeInformation -Encoding UTF8

# Filtering logic
Write-Host "[*] Filtering users with Company or Department populated..." -ForegroundColor Gray

$filteredUsers = $activeUsers | Where-Object {
    $company = ($_.Company -join "").Trim()
    $department = ($_.Department -join "").Trim()
    $hasOrgInfo = ($company -ne "") -or ($department -ne "")

    $combinedFields = "$($_.SamAccountName) $($_.DisplayName) $($_.Mail) $company $department".ToLower()
    $notExcluded = -not ($excludedPatterns | Where-Object { $combinedFields -like "*$_*" })

    return $hasOrgInfo -and $notExcluded
}

# Export filtered users
Write-Host "[+] Exporting filtered list to striped.csv..." -ForegroundColor Green
$filteredUsers |
    Select-Object DisplayName, SamAccountName, Mail, Department, Company |
    Export-Csv -Path $strippedExportPath -NoTypeInformation -Encoding UTF8

# Done!
Write-Host ""
Write-Host "✅ Export completed successfully!" -ForegroundColor Green
Write-Host "📁 Raw file saved to     : $rawExportPath" -ForegroundColor Cyan
Write-Host "📁 Stripped file saved to: $strippedExportPath" -ForegroundColor Cyan
Write-Host ""
