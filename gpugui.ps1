# Redirect stderr to null to suppress error pop-up windows
1>$null
2>$null
# Function to disable the NVIDIA GPU using Windows Device Manager
function DisableNvidiaGPU {
    $nvidiaGPU = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*NVIDIA*" }
    
    if ($nvidiaGPU) {
        $nvidiaGPU | Disable-PnpDevice -Confirm:$false
        Write-Host "NVIDIA GPU has been disabled."
    } else {
        Write-Host "NVIDIA GPU not found in Device Manager."
    }
}

# Function to enable the NVIDIA GPU using Windows Device Manager
function EnableNvidiaGPU {
    $nvidiaGPU = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*NVIDIA*" }
    
    if ($nvidiaGPU) {
        $nvidiaGPU | Enable-PnpDevice -Confirm:$false
        Write-Host "NVIDIA GPU has been enabled."
    } else {
        Write-Host "NVIDIA GPU not found in Device Manager."
    }
}

# Redirect stdout and stderr to null to suppress output
[Console]::Out.Flush()
[Console]::Error.Flush()
$null = [Console]::Out
$null = [Console]::Error

# Create a system tray icon with a default Windows icon
$notifyIcon = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Icon = [System.Drawing.SystemIcons]::Information
$notifyIcon.Visible = $true

# Add a context menu to the system tray icon
$contextMenu = New-Object System.Windows.Forms.ContextMenu
$enableMenuItem = New-Object System.Windows.Forms.MenuItem
$enableMenuItem.Text = "Enable NVIDIA GPU"
$enableMenuItem.Add_Click({
    EnableNvidiaGPU
})

$disableMenuItem = New-Object System.Windows.Forms.MenuItem
$disableMenuItem.Text = "Disable NVIDIA GPU"
$disableMenuItem.Add_Click({
    DisableNvidiaGPU
})

$exitMenuItem = New-Object System.Windows.Forms.MenuItem
$exitMenuItem.Text = "Exit"
$exitMenuItem.Add_Click({
    $notifyIcon.Dispose()
    exit
})

$contextMenu.MenuItems.Add($enableMenuItem)
$contextMenu.MenuItems.Add($disableMenuItem)
$contextMenu.MenuItems.Add($exitMenuItem)

$notifyIcon.ContextMenu = $contextMenu

# Run the tray application
$notifyIcon.Text = "NVIDIA GPU Toggler"
$notifyIcon.ShowBalloonTip(1000, "NVIDIA GPU Toggler", "Right-click the tray icon to enable/disable the NVIDIA GPU.", [System.Windows.Forms.ToolTipIcon]::Info)
[void][System.Windows.Forms.Application]::Run()
