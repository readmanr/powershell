# Robs custom Get-Uptime function for Powershell 5.1
#
# PowerShell 7 C# cmdlet source https://github.com/PowerShell/PowerShell/blob/master/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetUptime.cs
#
# Usage examples to run at the end of the code.
#
# $startTime = Get-Uptime -Since
#
# $uptime = Get-Uptime
#
# Check if the uptime days are greater than 10 and if so restart the local computer
# $uptime = Get-Uptime
# if ($uptime.Days -gt 10) {
#     # This example requires administrative privileges to run
#     # Restart-Computer cmdlet will restart the local computer
#     # Restart the computer immediately
#     Write-Host "The system has been up for more than 10 days, restarting."
#     Restart-Computer
# }

# Check if an Get-Uptime cmdlet is found, if Get-Uptime is not found, let's define the custom function.
try {
    # Try to get the built-in Get-Uptime cmdlet
    $null = Get-Command Get-Uptime -ErrorAction Stop
}
catch {
# If Get-Uptime is not found, define the custom function
function Get-Uptime {
    param (
        [Switch]$Since
    )

    if ([System.Diagnostics.Stopwatch]::IsHighResolution) {
        $uptimeTicks = [System.Diagnostics.Stopwatch]::GetTimestamp()
        $uptimeFrequency = [System.Diagnostics.Stopwatch]::Frequency
        $uptimeSeconds = $uptimeTicks / $uptimeFrequency
        write-host $uptimeSeconds
        $uptime = [TimeSpan]::FromSeconds($uptimeSeconds)

        if ($Since) {
            return (Get-Date).AddSeconds(-$uptime.TotalSeconds)
        } else {
            return $uptime
        }
    } else {
        Write-Error "High-resolution timer not available."
    }
<#
.SYNOPSIS
   Gets the system uptime.

.DESCRIPTION
   The Get-Uptime function calculates the time elapsed since the system was last booted. 

.SYNTAX
   Get-Uptime [<CommonParameters>]

   Get-Uptime [-Since] [<CommonParameters>]

.PARAMETERS
    -Since
    If used, the function returns the DateTime when the system started.

    <CommonParameters>
    This cmdlet supports the common parameters: Verbose, Debug,
    ErrorAction, ErrorVariable, WarningAction, WarningVariable,
    OutBuffer, PipelineVariable, and OutVariable. 

.INPUTS
    None

.OUTPUTS
    System.TimeSpan
    If the -Since parameter is not used, the function returns a TimeSpan object representing the system uptime.

    System.DateTime
    If the -Since parameter is used, the function returns a DateTime object representing when the system was last started.

.EXAMPLE
   PS> Get-Uptime
   This command gets the current system uptime.

.EXAMPLE
   PS> Get-Uptime -Since
   This command gets the DateTime when the system was last started.

.NOTES
   This is a custom function similar to the Get-Uptime cmdlet available in PowerShell 7 and later.

.LINK
   https://go.microsoft.com/fwlink/?linkid=834862

#>
}
}
# Get-Uptime should now be able to be used.
