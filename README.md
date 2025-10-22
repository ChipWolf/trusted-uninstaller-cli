# AME Wizard Core

Core functionality used by AME Wizard.

## CLI Usage

*We do not recommend CLI usage for normal users, instead use [AME Wizard](https://ameliorated.io/).*

### Standard Playbook Execution

1. Download `CLI-Standalone.zip` from the [latest release](https://github.com/Ameliorated-LLC/trusted-uninstaller-cli/releases/latest)

2. Extract the downloaded archive

3. Inside the extracted folder, place a Playbook of choice

4. Extract the Playbook with 7zip using the password `malte`

5. Open **Command Prompt** as administrator and navigate to the extracted CLI-Standalone folder

6. Run `TrustedUninstaller.CLI.exe "<Extracted Playbook Folder>"`

   Optionally, you can specify options like in the following example:
   ```
   TrustedUninstaller.CLI.exe "AME 11 v0.7" browser-firefox enhanced-security
   ```

### ISO Mastering (Injection Mode)

The CLI supports creating customized Windows installation ISOs by injecting playbook configurations directly into the Windows image. This allows for automated deployment of AME configurations during Windows installation.

#### Prerequisites

- Administrator privileges required
- Minimum 20GB free disk space (for extraction and processing)
- Windows ISO file (Windows 10/11 supported)
- AME Playbook compatible with ISO mastering
- `mkisofs.exe` available in the application directory (included with CLI releases)

#### Basic Usage

```cmd
TrustedUninstaller.CLI.exe ISO "<Playbook Path>" --ISOPath "<Input ISO>" --OutputPath "<Output ISO>"
```

#### Complete Example

```cmd
TrustedUninstaller.CLI.exe ISO "AME 11 v0.7" --ISOPath "Windows11.iso" --OutputPath "Windows11_AME.iso" --Architecture X64 --NetworkDrivers --GraphicsDrivers
```

#### Available Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--ISOPath` | String | *Required* | Path to the input Windows ISO file |
| `--OutputPath` | String | *Required* | Path where the modified ISO will be saved |
| `--ISOBuild` | String | *Auto-detected* | Windows build number (e.g., "22631") |
| `--ISOUpdateBuild` | String | *Auto-detected* | Windows update build number |
| `--Architecture` | Enum | `X64` | Target architecture: `X86`, `X64`, `Arm`, `Arm64` |
| `--NetworkDrivers` | Boolean | `false` | Include network drivers for offline installation |
| `--GraphicsDrivers` | Boolean | `false` | Include graphics drivers for better compatibility |
| `--SystemDrivers` | Boolean | `false` | Include system drivers for hardware compatibility |
| `--ESD` | Boolean | `false` | Output in ESD format instead of WIM |
| `--Verified` | Boolean | `false` | Mark the installation as verified |
| `--AutoLogon` | Boolean | `false` | Enable automatic logon during OOBE |
| `--Username` | String | *Optional* | Default username for OOBE setup |
| `--Password` | String | *Optional* | Default password for OOBE setup |
| `--AdminPassword` | String | *Optional* | Administrator account password |

#### Process Overview

1. **ISO Extraction**: The tool extracts the Windows ISO to a temporary directory
2. **WIM Processing**: Extracts and mounts the Windows installation image (install.wim/install.esd)
3. **Registry Modification**: Applies playbook registry changes to the offline Windows registry hives
4. **File Injection**: Copies playbook files and OOBE components into the Windows image
5. **Driver Integration**: Optionally integrates drivers for better hardware compatibility
6. **Boot Configuration**: Modifies boot.wim if hardware requirement bypasses are enabled
7. **ISO Creation**: Rebuilds the ISO with all modifications using mkisofs

#### Playbook Compatibility

Not all playbook actions are compatible with ISO mastering. The following action types support ISO mode:

- **Registry Actions**: `RegistryKeyAction`, `RegistryValueAction` (with `iso: true`)
- **Service Actions**: `ServiceAction` (Delete and Change operations only)
- **File Actions**: `FileAction` (for copying files to the offline image)
- **Software Actions**: `SoftwareAction` (cached for OOBE installation)
- **Task Actions**: Any action with `iso: true` or `iso: only`

Actions marked with `iso: only` will run exclusively during ISO mastering and not during normal installation.

#### ISO Configuration Files

The mastering process creates configuration files within the ISO:

- `iso.conf`: Contains playbook metadata and ISO-specific settings
- `sources\$OEM$\$$\Panther\unattend.xml`: Windows setup automation (if BitLocker/hardware bypasses enabled)
- `ProgramData\AME\OOBE\*`: OOBE application and configuration files

#### Example Workflows

**Creating a Basic AME ISO:**
```cmd
TrustedUninstaller.CLI.exe ISO "AME-Windows11" --ISOPath "Win11_22H2.iso" --OutputPath "Win11_AME_Basic.iso"
```

**Advanced ISO with Drivers:**
```cmd
TrustedUninstaller.CLI.exe ISO "AME-Windows11" ^
  --ISOPath "Win11_22H2.iso" ^
  --OutputPath "Win11_AME_Drivers.iso" ^
  --Architecture X64 ^
  --NetworkDrivers ^
  --GraphicsDrivers ^
  --SystemDrivers ^
  --Username "AMEUser" ^
  --AutoLogon
```

**ARM64 Surface Device ISO:**
```cmd
TrustedUninstaller.CLI.exe ISO "AME-Windows11-ARM" ^
  --ISOPath "Win11_ARM64.iso" ^
  --OutputPath "Win11_AME_Surface.iso" ^
  --Architecture Arm64 ^
  --SystemDrivers ^
  --GraphicsDrivers
```

#### Troubleshooting

**"Not enough free space"**: Ensure you have at least 20GB free space in your temp directory and output location.

**"ISO file not found"**: Verify the path to your Windows ISO file is correct and accessible.

**"mkisofs.exe not found"**: Make sure mkisofs.exe is in the same directory as TrustedUninstaller.CLI.exe.

**"Invalid playbook"**: Ensure your playbook contains ISO-compatible actions. Check the playbook documentation for ISO support.

**Registry errors during mastering**: Some registry operations may fail on offline hives. This is normal for certain system-specific keys.

#### Security Considerations

- ISO mastering requires TrustedInstaller privileges to modify system files
- The process temporarily mounts Windows registry hives for modification
- Output ISOs contain embedded AME configurations and OOBE applications
- Generated ISOs should be treated as modified system images

## Compilation

1. Clone the repository
   ```
   git clone https://github.com/Ameliorated-LLC/trusted-uninstaller-cli.git
   ```
2. Build options

Option A — Visual Studio (recommended)

1. Open `TrustedUninstaller.sln` with Visual Studio (Windows)
2. Select `Release` and `x64` and build the solution

Option B — Docker on Windows (Windows host with Windows containers)

1. Ensure Docker for Windows is running in **Windows Containers** mode
2. From repository root run:

```powershell
docker build -f Dockerfile.windows -t trusted-uninstaller-cli:windows .
docker run --rm -v ${PWD}:/out trusted-uninstaller-cli:windows
# The built files will be inside the image at C:\app — use docker cp to extract if needed
```

Option C — GitHub Actions (CI build)

1. Trigger the workflow manually from the Actions tab or push to the `public` branch
2. The workflow `.github/workflows/build-windows.yml` runs on `windows-latest`, builds the solution, and uploads an artifact named `trusted-uninstaller-cli-build`
3. Download the artifact from the workflow run artifacts and extract the built `TrustedUninstaller.CLI.exe`

Notes

- Building the project requires Windows because it targets .NET Framework 4.7.2 and uses Windows-only APIs. The Dockerfile windows image and the GitHub Actions runner both run on Windows.
- Building on Linux/WSL directly is not supported because .NET Framework reference assemblies aren't available there.


## License
This tool has an [MIT license](https://en.wikipedia.org/wiki/MIT_License), which waives any requirements or rules governing the source code’s use, removing politics from the equation.

Since this project makes major alterations to the operating system and has the ability to install software during this process, it is imperative that we **provide its source code for auditing purposes.**  
This has not only helped us build trust, and make our project stand out among the crowd, but has also led to many community contributions along the way.