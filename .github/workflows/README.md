# GitHub Actions Workflows

## Build Windows Workflow

The `build-windows.yml` workflow builds the TrustedUninstaller CLI for Windows using .NET Framework and C++.

### Performance Optimizations

#### NuGet Package Caching

The workflow uses GitHub Actions cache to speed up NuGet package restoration:

- **Cache locations**:
  - `~/.nuget/packages` - Global NuGet packages folder
  - `~/AppData/Local/NuGet/v3-cache` - NuGet HTTP cache
  - `packages` - Solution-level packages folder (for legacy packages.config projects)

- **Cache key**: Based on hash of all `.csproj` and `packages.config` files
- **Fallback**: Uses prefix-based restore key for partial cache hits

- **Expected performance**:
  - First run: No cache (~4.5 minutes total)
  - Subsequent runs with cache hit: ~90-100 seconds faster (~2.5-3 minutes total)

### Build Steps

1. **Checkout**: Get the latest code
2. **Setup MSBuild**: Configure MSBuild environment
3. **Setup NuGet**: Configure NuGet environment
4. **Cache NuGet packages**: Restore or save NuGet package cache
5. **Restore NuGet packages**: Install dependencies
6. **Build C++ client-helper**: Compile C++ dependencies
7. **Build solution**: Compile .NET projects
8. **Collect output**: Gather build artifacts
9. **Test CLI functionality**: Basic smoke tests
10. **Upload artifact**: Publish build artifacts

### Maintenance

- The cache is automatically invalidated when `.csproj` or `packages.config` files change
- GitHub automatically removes caches not accessed for 7 days
- Maximum cache size per repository: 10 GB
