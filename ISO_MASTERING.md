# ISO Mastering Technical Documentation

## Overview

ISO Mastering allows you to inject AME Playbook configurations directly into Windows installation media, creating customized ISOs that apply modifications during the Windows installation process. This eliminates the need to run AME Wizard after Windows installation.

## Architecture

### Core Components

1. **ISO Extraction Engine** (`TrustedUninstaller.Shared/USB/ISO.cs`)
   - Supports both UDF and CDR ISO formats
   - Handles compressed (gzip) ISO files automatically
   - Extracts ISO contents to temporary staging directory

2. **WIM Processing** (`TrustedUninstaller.Shared/WimWrapper.cs`)
   - Mounts Windows Image (WIM/ESD) files for modification
   - Provides offline registry hive manipulation capabilities
   - Manages multiple Windows editions within a single WIM

3. **Registry Injection** (`Core/Actions/RegistryKeyAction.cs`, `Core/Actions/RegistryValueAction.cs`)
   - Applies registry modifications to offline Windows hives
   - Maps live registry paths to offline hive locations
   - Handles special cases for ISO vs live system operation

4. **OOBE Integration** (`TrustedUninstaller.Shared/OOBE.cs`)
   - Injects custom OOBE (Out of Box Experience) components
   - Configures automatic playbook execution after Windows installation
   - Manages user account creation and configuration

5. **ISO Rebuilding** (Uses `mkisofs.exe`)
   - Recreates bootable ISO with all modifications
   - Maintains Windows boot compatibility
   - Preserves original ISO structure and metadata

### Process Flow

```
Input ISO → Extract → Mount WIM → Apply Registry Changes → Inject OOBE → Rebuild ISO → Output ISO
```

## Technical Implementation Details

### Registry Path Mapping

During ISO mastering, registry paths are remapped from live system locations to offline hive locations:

- `HKEY_LOCAL_MACHINE` → `HKEY_USERS\HKLM-{GUID}`
- `HKEY_CURRENT_USER` → `HKEY_USERS\HKCU-{GUID}` (when user hive is mounted)

### Special Registry Handling

Some registry operations require special handling in ISO mode:

```csharp
// Example from ServiceAction.cs
using var root = !AmeliorationUtil.ISO ? 
    Registry.LocalMachine.OpenSubKey($@"SYSTEM\CurrentControlSet\Services\{ServiceName}") :
    Registry.Users.OpenSubKey("HKLM-" + AmeliorationUtil.ISOGuid + $@"\SYSTEM\ControlSet001\Services\{ServiceName}");
```

### Action Compatibility

Actions are marked with the `ISOSetting` enum to control execution during ISO mastering:

```csharp
public enum ISOSetting
{
    True,    // Run during ISO mastering AND normal installation
    Only,    // Run ONLY during ISO mastering
    False,   // Never run during ISO mastering (default)
}
```

#### Compatible Action Types

| Action Type | ISO Support | Notes |
|-------------|-------------|-------|
| `RegistryKeyAction` | Full | Registry modifications applied to offline hives |
| `RegistryValueAction` | Full | Registry values set in offline registry |
| `ServiceAction` | Limited | Only Delete and Change operations supported |
| `FileAction` | Full | Files copied to offline Windows image |
| `SoftwareAction` | Cached | Software packages cached for OOBE installation |
| `AppxAction` | Limited | AppX packages staged for installation |
| `CmdAction` | Limited | Commands executed in offline context where possible |
| `PowershellAction` | No | PowerShell not available in offline context |
| `RunAction` | Limited | Only static file operations supported |

#### Incompatible Operations

- Live system service manipulation
- Running executables that require active Windows session
- Operations requiring network connectivity during mastering
- Registry operations on volatile/session-specific keys

### WIM Image Processing

#### Multi-Edition Support

When processing ISOs with multiple Windows editions:

```csharp
// Remove superfluous images to reduce size
WimInstance.RemoveSuperfluousImages();

// Process each remaining edition
for (int i = 1; i <= WimInstance.ImageCount; i++)
{
    await ProcessWindowsEdition(i, nameList[i - 1]);
}
```

#### Registry Hive Mounting

The system mounts offline registry hives for modification:

```csharp
// Mount registry hives with unique GUID identifier
WimInstance.MountHives(ISOGuid);

// Registry operations now target offline hives
using var key = Registry.Users.OpenSubKey($"HKLM-{ISOGuid}\\SOFTWARE\\...");
```

### Hardware Requirement Bypasses

For playbooks configured to bypass Windows 11 hardware requirements:

```csharp
if (Playbook.ISO?.DisableHardwareRequirements == true)
{
    // Modify boot.wim to bypass TPM, Secure Boot, RAM, CPU checks
    using (var labKey = Registry.Users.CreateSubKey("BOOT-" + ISOGuid + @"\Setup\LabConfig"))
    {
        labKey.SetValue("BypassRAMCheck", 1, RegistryValueKind.DWord);
        labKey.SetValue("BypassSecureBootCheck", 1, RegistryValueKind.DWord);
        labKey.SetValue("BypassCPUCheck", 1, RegistryValueKind.DWord);
        labKey.SetValue("BypassTPMCheck", 1, RegistryValueKind.DWord);
    }
}
```

### Driver Integration

The system can integrate drivers during ISO mastering:

```csharp
await DriverManager.HandleDrivers(
    driversProgress => progress.Report((decimal)(driversProgress / 10) + 10),
    statusReporter,
    graphicsDrivers,
    networkDrivers,
    systemDrivers,
    "https://download.ameliorated.io/drivers.json",
    Environment.ExpandEnvironmentVariables(@"%PROGRAMDATA%\AME\DriverCache"),
    Path.Combine(WimPath, @"ProgramData\AME\OOBE\Drivers")
);
```

### OOBE Configuration

The mastering process creates several configuration files:

#### iso.conf
```xml
<ISO>
    <Name>AME Windows 11</Name>
    <Creator>AME Team</Creator>
    <UniqueId>12345678-1234-1234-1234-123456789abc</UniqueId>
    <Version>1.0</Version>
    <WindowsVersion>22631</WindowsVersion>
    <Options>
        <string>enhanced-security</string>
        <string>browser-firefox</string>
    </Options>
    <HardwareRequirementsDisabled>true</HardwareRequirementsDisabled>
    <BitLockerDisabled>true</BitLockerDisabled>
</ISO>
```

#### oobe.conf
```xml
<OOBE>
    <Username>AMEUser</Username>
    <AutoLogon>true</AutoLogon>
    <Verified>false</Verified>
    <Options>
        <string>enhanced-security</string>
    </Options>
    <Software>
        <Software>
            <Name>firefox</Name>
            <Title>Firefox Browser</Title>
            <Description>Privacy-focused web browser</Description>
        </Software>
    </Software>
</OOBE>
```

## Error Handling

### Common Issues and Solutions

1. **Insufficient Disk Space**
   ```csharp
   if (ISO)
       ThrowIfNotEnoughFreeSpace(isoPath, Path.GetTempPath());
   ```

2. **Registry Access Errors**
   - Some registry operations may fail on offline hives
   - Non-critical failures are logged but don't stop the process
   - Critical system keys may require special handling

3. **WIM Mount Failures**
   - Cleanup processes ensure mounted WIMs are properly unmounted
   - Multiple retry mechanisms handle temporary file locks
   - Staging directories are cleaned up even on failure

### Cleanup and Resource Management

```csharp
// Comprehensive cleanup in finally block
finally
{
    if (ISO)
    {
        if (!unhooked)
            Wrap.ExecuteSafe(() => WimInstance.UnmountHives(ISOGuid), true);
        
        WimInstance?.Dispose();
        
        // Clean up temporary directories with proper attribute reset
        if (Directory.Exists(WimPath))
        {
            DirectoryInfo dir = new DirectoryInfo(WimPath);
            foreach (FileInfo file in dir.GetFiles("*", SearchOption.AllDirectories))
                Wrap.ExecuteSafe(() => file.Attributes = FileAttributes.Normal);
            Wrap.ExecuteSafe(() => Directory.Delete(WimPath, true));
        }
    }
}
```

## Performance Considerations

- **Memory Usage**: WIM processing can require significant RAM (2-4GB recommended)
- **Disk I/O**: ISO extraction and rebuilding are disk-intensive operations
- **CPU Usage**: Compression/decompression during WIM operations
- **Temporary Space**: Requires 2-3x the ISO size in temporary disk space

## Security Implications

### Elevated Privileges
- ISO mastering requires TrustedInstaller privileges
- Registry hive mounting requires administrative access
- File system modifications require elevated permissions

### Modified Boot Process
- Custom OOBE components modify Windows first-boot process
- Registry modifications affect system security settings
- Driver integration may affect system stability

### Integrity Considerations
- Output ISOs contain embedded modifications
- Windows Update compatibility may be affected
- System restore points should be created before using modified ISOs

## CLI Integration

The CLI wrapper (`TrustedUninstaller.CLI/CLI.cs`) provides a user-friendly interface:

```csharp
private static async Task<int> HandleISOCommand(string[] args)
{
    // Parse command line arguments
    var isoData = CommandLine.ParseArguments(args) as CommandLine.Execute;
    
    // Validate inputs
    if (!Directory.Exists(iso.PlaybookPath) || !File.Exists(iso.ISOPath))
        return -1;
    
    // Execute ISO mastering with progress reporting
    await InterLink.ExecuteAsync(() => AmeliorationUtil.RunPlaybook(
        playbookPath: iso.PlaybookPath,
        isoPath: iso.ISOPath,
        isoDest: iso.OutputPath,
        // ... other parameters
    ));
}
```

## Future Enhancements

Potential areas for improvement:

1. **Parallel Processing**: Multi-threaded WIM processing for multiple editions
2. **Delta Updates**: Incremental ISO modifications for updated playbooks  
3. **Validation**: Pre-flight checks for playbook ISO compatibility
4. **Recovery**: Better error recovery and partial completion support
5. **Optimization**: Reduced temporary disk space requirements
6. **Integration**: Direct integration with Windows ADK tools

## Debugging

Enable detailed logging by examining:

- `Log.yml`: Detailed operation logs with timestamps
- Console output: Real-time progress and error messages  
- Temporary directories: Inspect extracted/modified files before cleanup
- Registry dumps: Examine offline registry modifications

For development debugging, temporary directories can be preserved by modifying cleanup logic in the finally blocks.