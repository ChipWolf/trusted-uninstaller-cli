# Multi-stage build for .NET Framework application
# Stage 1: Use Windows container for building
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 AS build

# Set the working directory
WORKDIR /src

# Copy solution and project files first for better layer caching
COPY *.sln ./
COPY TrustedUninstaller.CLI/*.csproj TrustedUninstaller.CLI/
COPY TrustedUninstaller.Shared/*.csproj TrustedUninstaller.Shared/
COPY Core/Core.shproj Core/
COPY Interprocess/Interprocess.shproj Interprocess/
COPY ManagedWimLib/*.csproj ManagedWimLib/

# Restore NuGet packages
RUN nuget restore TrustedUninstaller.sln

# Copy the rest of the source code
COPY . .

# Build the solution in Release configuration
RUN msbuild TrustedUninstaller.sln /p:Configuration=Release /p:Platform=x64 /p:OutputPath=C:\build-output\ /verbosity:minimal

# Stage 2: Create a runtime image (optional, for testing)
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019 AS runtime

# Create app directory and copy the built application
WORKDIR C:\\app
COPY --from=build C:\\build-output\\ .

# Default command (optional)
CMD ["TrustedUninstaller.CLI.exe"]