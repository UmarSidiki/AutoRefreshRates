# Auto Refresh Rate Manager

**Automatically adjusts your display refresh rate based on power state**

## Overview

This application automatically manages your display refresh rate to optimize battery life and performance:
- **On Battery**: Switches to lower refresh rates (60-75Hz) to conserve battery
- **On AC Power**: Switches to higher refresh rates (120Hz+) for optimal performance

The application intelligently works with your display's supported refresh rates and chooses the best settings automatically.

The application runs as a Windows scheduled task and triggers automatically when power events occur.

## Features

- ✅ Intelligent refresh rate detection and selection
- ✅ Supports all display types and refresh rates
- ✅ Automatic refresh rate switching based on power state
- ✅ Runs silently in the background
- ✅ No user interaction required after setup
- ✅ Secure encrypted configuration files
- ✅ Easy installation and uninstallation
- ✅ Requires minimal system resources

## System Requirements

- Windows 10 or later
- PowerShell 5.1 or later
- Administrator privileges (required for scheduled task creation)
- Compatible display adapter

## Installation

1. **Run the installer**:
   ```
   Double-click run.bat
   ```

2. **Grant administrator permissions** when prompted (required for scheduled task creation)

3. **Confirm installation** when asked to import the task into Task Scheduler

The application will automatically start working after installation.

## Uninstallation

1. **Run the uninstaller**:
   ```
   Double-click uninstall.bat
   ```

2. **Confirm removal** when prompted

This will remove the scheduled task and generated files while preserving the application folder.

## How It Works

1. **Event Monitoring**: The scheduled task monitors Windows power events
2. **Power Detection**: When power state changes, the VBS script executes
3. **Refresh Rate Adjustment**: PowerShell script detects power state and adjusts refresh rate accordingly
4. **Silent Operation**: All operations run silently in the background

## File Structure

```
AutoRefreshRates/
├── run.bat              # Main installer
├── uninstall.bat        # Uninstaller
├── README.md           # This file
├── lib/
│   ├── AutoSetRefreshRate.ps1  # PowerShell script for refresh rate control
│   └── RunSilent.vbs           # VBS wrapper for silent execution
└── template/
    └── template.enc            # Encrypted task template
```

## Technical Details

- **Trigger**: Windows power events (AC/Battery transitions)
- **Execution**: Silent VBS script calls PowerShell module
- **Detection**: Uses DisplayConfig PowerShell module for display management
- **Security**: Template files are base64 encoded for protection

## Troubleshooting

### Installation Issues
- Ensure you're running with administrator privileges
- Check that PowerShell execution policy allows script execution
- Verify Windows Task Scheduler service is running

### Refresh Rate Not Changing
- Confirm your display supports multiple refresh rates
- Check that the DisplayConfig module can be installed
- Verify the scheduled task is enabled in Task Scheduler
- Ensure your graphics drivers are up to date

### Manual Task Management
If needed, you can manually manage the task:
1. Open Task Scheduler (`taskschd.msc`)
2. Look for "Auto Refresh Rate" task
3. Right-click to enable/disable/modify as needed

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Verify your system meets the requirements
3. Ensure all files are present and unmodified

## License

This software is provided "as-is" without warranty. Use at your own risk.

## Credits

Developed by [Umar Sidiki](https://github.com/UmarSidiki)

---

**Version**: 1.0  
**Compatibility**: Windows 10/11  
**Last Updated**: July 2025
