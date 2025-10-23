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

## Compilation

1. Clone the repository
   ```
   git clone https://github.com/Ameliorated-LLC/trusted-uninstaller-cli.git
   ```
2. Build options

Option A — Visual Studio

1. Open `TrustedUninstaller.sln` with Visual Studio (Windows)
2. Select `Release` and `x64` and build the solution

Option B — GitHub Actions (CI build)

1. Trigger the workflow manually from the Actions tab or push to the `public` branch
2. The workflow `.github/workflows/build-windows.yml` runs on `windows-latest`, builds the solution, and uploads an artifact named `trusted-uninstaller-cli-build`
3. Download the artifact from the workflow run artifacts and extract the built `TrustedUninstaller.CLI.exe`

## License
This tool has an [MIT license](https://en.wikipedia.org/wiki/MIT_License), which waives any requirements or rules governing the source code’s use, removing politics from the equation.

Since this project makes major alterations to the operating system and has the ability to install software during this process, it is imperative that we **provide its source code for auditing purposes.**  
This has not only helped us build trust, and make our project stand out among the crowd, but has also led to many community contributions along the way.