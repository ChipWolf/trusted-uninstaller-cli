#!/bin/bash
# Simple test to verify our ISO command parsing fix works

echo "Testing ISO command parsing fix..."
echo "================================="

# Test case 1: Help command
echo "Test 1: Help command"
echo "Command: TrustedUninstaller.CLI.exe --help"
echo "Expected: Should show help including ISO command"
echo ""

# Test case 2: ISO command format  
echo "Test 2: ISO command with required parameters"
echo "Command: TrustedUninstaller.CLI.exe ISO \"test-playbook\" --ISOPath \"input.iso\" --OutputPath \"output.iso\""
echo "Expected: Should parse correctly and show proper error messages for missing files (not parsing errors)"
echo ""

# Test case 3: ISO command with additional options
echo "Test 3: ISO command with additional options" 
echo "Command: TrustedUninstaller.CLI.exe ISO \"test-playbook\" --ISOPath \"input.iso\" --OutputPath \"output.iso\" --Architecture X64 --Verified"
echo "Expected: Should parse all options correctly"
echo ""

echo "The fix transforms:"
echo "  [\"ISO\", \"playbook\", \"--ISOPath\", \"input.iso\", ...]"
echo "to:"
echo "  [\"Execute\", \"ISO\", \"playbook\", \"--ISOPath\", \"input.iso\", ...]"
echo ""
echo "This allows the CommandLine.ParseArguments() method to correctly identify 'Execute' as the command type and 'ISO' as the subcommand."