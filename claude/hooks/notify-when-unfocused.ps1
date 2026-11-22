# Shows a Windows toast notification unless the foreground window belongs to
# one of the given processes.
#
# Usage: notify-when-unfocused.ps1 -Title <title> -Message <message>
#        [-HostProcess <name>,...]
#
# HostProcess names are compared with the process name of the foreground
# window, without the ".exe" suffix (e.g. "Code", "WindowsTerminal"). If no
# HostProcess is given, the notification is always shown.

param(
    [Parameter(Mandatory = $true)][string] $Title,
    [Parameter(Mandatory = $true)][string] $Message,
    [string[]] $HostProcess = @()
)

$ErrorActionPreference = 'Stop'

if ($HostProcess.Count -gt 0) {
    Add-Type -Namespace Win32 -Name User32 -MemberDefinition @'
[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();
[DllImport("user32.dll")]
public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);
'@
    $processId = 0
    [void][Win32.User32]::GetWindowThreadProcessId(
        [Win32.User32]::GetForegroundWindow(), [ref]$processId)
    $foreground = (Get-Process -Id $processId -ErrorAction SilentlyContinue).ProcessName
    if ($HostProcess -contains $foreground) {
        exit
    }
}

[void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
[void][Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime]

$xml = [Windows.Data.Xml.Dom.XmlDocument]::new()
$xml.LoadXml('<toast><visual><binding template="ToastGeneric"><text/><text/></binding></visual></toast>')
$texts = $xml.GetElementsByTagName('text')
[void]$texts.Item(0).AppendChild($xml.CreateTextNode($Title))
[void]$texts.Item(1).AppendChild($xml.CreateTextNode($Message))

# A toast must be attributed to a registered application. Windows PowerShell's
# own AppUserModelID is used because it exists on every Windows installation.
$appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show(
    [Windows.UI.Notifications.ToastNotification]::new($xml))
