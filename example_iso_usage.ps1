# AME Trusted Uninstaller - ISO Mastering PowerShell Examples
# Requires Administrator privileges and Windows environment

param(
    [string]$PlaybookPath = "",
    [string]$ISOPath = "",
    [string]$OutputPath = ""
)

Write-Host "AME Trusted Uninstaller - ISO Mastering Examples" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host ""

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

# Function to validate prerequisites
function Test-Prerequisites {
    Write-Host "Checking prerequisites..." -ForegroundColor Yellow
    
    # Check if TrustedUninstaller.CLI.exe exists
    if (-not (Test-Path ".\TrustedUninstaller.CLI.exe")) {
        Write-Host "ERROR: TrustedUninstaller.CLI.exe not found in current directory!" -ForegroundColor Red
        return $false
    }
    
    # Check if mkisofs.exe exists
    if (-not (Test-Path ".\mkisofs.exe")) {
        Write-Host "WARNING: mkisofs.exe not found. ISO creation will fail without it." -ForegroundColor Yellow
    }
    
    # Check free disk space (approximate check)
    $freeSpace = (Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object -ExpandProperty FreeSpace) / 1GB
    if ($freeSpace -lt 20) {
        Write-Host "WARNING: Less than 20GB free space available. ISO mastering may fail." -ForegroundColor Yellow
    }
    
    Write-Host "Prerequisites check completed." -ForegroundColor Green
    return $true
}

# Function to run ISO mastering with error handling
function Start-IsoMastering {
    param(
        [string]$Playbook,
        [string]$InputISO,
        [string]$Output,
        [string[]]$AdditionalParams = @()
    )
    
    if (-not (Test-Path $Playbook)) {
        Write-Host "ERROR: Playbook directory not found: $Playbook" -ForegroundColor Red
        return $false
    }
    
    if (-not (Test-Path $InputISO)) {
        Write-Host "ERROR: ISO file not found: $InputISO" -ForegroundColor Red
        return $false
    }
    
    # Ensure output directory exists
    $outputDir = Split-Path $Output
    if ($outputDir -and (-not (Test-Path $outputDir))) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }
    
    # Build command arguments
    $arguments = @("ISO", "`"$Playbook`"", "--ISOPath", "`"$InputISO`"", "--OutputPath", "`"$Output`"") + $AdditionalParams
    
    Write-Host "Starting ISO mastering..." -ForegroundColor Yellow
    Write-Host "Command: TrustedUninstaller.CLI.exe $($arguments -join ' ')" -ForegroundColor Cyan
    
    $process = Start-Process -FilePath ".\TrustedUninstaller.CLI.exe" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0) {
        Write-Host "ISO mastering completed successfully!" -ForegroundColor Green
        Write-Host "Output file: $Output" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ISO mastering failed with exit code: $($process.ExitCode)" -ForegroundColor Red
        return $false
    }
}

# Main execution
if (-not (Test-Prerequisites)) {
    exit 1
}

Write-Host ""
Write-Host "Available Examples:" -ForegroundColor Yellow
Write-Host "1. Basic ISO mastering"
Write-Host "2. Advanced ISO with drivers"
Write-Host "3. ARM64 ISO for Surface devices"
Write-Host "4. ESD format output"
Write-Host "5. Custom parameters (manual input)"
Write-Host "6. Run with provided parameters"
Write-Host ""

if ($PlaybookPath -and $ISOPath -and $OutputPath) {
    Write-Host "Running with provided parameters..." -ForegroundColor Green
    Start-IsoMastering -Playbook $PlaybookPath -InputISO $ISOPath -Output $OutputPath
    exit
}

$choice = Read-Host "Enter your choice (1-6)"

switch ($choice) {
    "1" {
        Write-Host "Example 1: Basic ISO mastering" -ForegroundColor Green
        $playbook = Read-Host "Enter playbook path"
        $iso = Read-Host "Enter input ISO path"
        $output = Read-Host "Enter output ISO path"
        Start-IsoMastering -Playbook $playbook -InputISO $iso -Output $output
    }
    
    "2" {
        Write-Host "Example 2: Advanced ISO with drivers" -ForegroundColor Green
        $playbook = Read-Host "Enter playbook path"
        $iso = Read-Host "Enter input ISO path"
        $output = Read-Host "Enter output ISO path"
        $params = @("--NetworkDrivers", "--GraphicsDrivers", "--SystemDrivers", "--Username", "AMEUser", "--AutoLogon")
        Start-IsoMastering -Playbook $playbook -InputISO $iso -Output $output -AdditionalParams $params
    }
    
    "3" {
        Write-Host "Example 3: ARM64 ISO for Surface devices" -ForegroundColor Green
        $playbook = Read-Host "Enter playbook path"
        $iso = Read-Host "Enter input ARM64 ISO path"
        $output = Read-Host "Enter output ISO path"
        $params = @("--Architecture", "Arm64", "--SystemDrivers", "--GraphicsDrivers")
        Start-IsoMastering -Playbook $playbook -InputISO $iso -Output $output -AdditionalParams $params
    }
    
    "4" {
        Write-Host "Example 4: ESD format output" -ForegroundColor Green
        $playbook = Read-Host "Enter playbook path"
        $iso = Read-Host "Enter input ISO path"
        $output = Read-Host "Enter output ISO path"
        $params = @("--ESD")
        Start-IsoMastering -Playbook $playbook -InputISO $iso -Output $output -AdditionalParams $params
    }
    
    "5" {
        Write-Host "Example 5: Custom parameters" -ForegroundColor Green
        Write-Host "Available options:" -ForegroundColor Cyan
        Write-Host "  --ISOBuild <build>          Windows build number"
        Write-Host "  --ISOUpdateBuild <build>    Windows update build"
        Write-Host "  --Architecture <arch>       X86, X64, Arm, Arm64"
        Write-Host "  --NetworkDrivers            Include network drivers"
        Write-Host "  --GraphicsDrivers           Include graphics drivers"
        Write-Host "  --SystemDrivers             Include system drivers"
        Write-Host "  --ESD                       Output as ESD format"
        Write-Host "  --Verified                  Mark as verified"
        Write-Host "  --AutoLogon                 Enable auto logon"
        Write-Host "  --Username <name>           OOBE username"
        Write-Host "  --Password <pass>           OOBE password"
        Write-Host "  --AdminPassword <pass>      Administrator password"
        Write-Host ""
        
        $playbook = Read-Host "Enter playbook path"
        $iso = Read-Host "Enter input ISO path"
        $output = Read-Host "Enter output ISO path"
        $customParams = Read-Host "Enter additional parameters (space-separated)"
        
        $params = if ($customParams) { $customParams.Split(' ') } else { @() }
        Start-IsoMastering -Playbook $playbook -InputISO $iso -Output $output -AdditionalParams $params
    }
    
    "6" {
        Write-Host "Usage: .\example_iso_usage.ps1 -PlaybookPath 'path' -ISOPath 'path' -OutputPath 'path'" -ForegroundColor Yellow
    }
    
    default {
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "For more information, see README.md and ISO_MASTERING.md" -ForegroundColor Cyan