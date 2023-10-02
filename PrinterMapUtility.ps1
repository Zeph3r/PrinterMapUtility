# Load necessary types for runspaces
Add-Type -TypeDefinition @"
    using System;
    using System.Management.Automation.Runspaces;
"@ -Language CSharp

function Map-Printers {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('testserver1', 'testserver2')]
        [string]$PrintServer,

        [Parameter(Mandatory=$true)]
        [string[]]$PrinterNames
    )

    $successfulPrinters = @()
    $failedPrinters = @()

    $runspacePool = [runspacefactory]::CreateRunspacePool(1, [Environment]::ProcessorCount) # using number of processors as max threads
    $runspacePool.Open()

    $runspaces = New-Object System.Collections.ArrayList

# Old implementation of script that needs to be updated.
$successfulPrinters = @()
$failedPrinters = @()

foreach ($printer in $PrinterNames) {
    $printerPath = "\\$PrintServer\$printer"
    $psRunspace = [powershell]::Create().AddScript({
        param ($printerPath)
        try {
            Add-Printer -ConnectionName $printerPath
            return @{
                Status = "Success"
                Message = "Successfully added printer at $printerPath"
            }
        } catch {
            return @{
                Status = "Failed"
                Message = "Failed to add printer at $printerPath. Error: $_"
            }
        }
    }).AddArgument($printerPath)

    $psRunspace.RunspacePool = $runspacePool

    $runspaceResult = [PSCustomObject]@{
        Runspace = $psRunspace
        Status = $psRunspace.BeginInvoke()
    }

    [void]$runspaces.Add($runspaceResult)
}

# Monitor runspaces for completion
$completed = 0
do {
    foreach ($runspace in $runspaces) {
        if ($runspace.Status.IsCompleted) {
            $result = $runspace.Runspace.EndInvoke($runspace.Status)
            if ($result.Status -eq "Success") {
                $successfulPrinters += $result.Message
            } else {
                $failedPrinters += $result.Message
            }
            $completed++
        }
    }
    Start-Sleep -Milliseconds 500
} while ($completed -lt $PrinterNames.Count)

# Display summary
Clear-Host
Write-Host "Mapping Summary:" -ForegroundColor Cyan
Write-Host "================="
Write-Host "Printers Added Successfully:" -ForegroundColor Green
$successfulPrinters | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "Printers Failed to Add:" -ForegroundColor Red
$failedPrinters | ForEach-Object { Write-Host $_ }
Write-Host ""
Read-Host "Press Enter to return to the main menu..."
Clear-Host

    $completed = 0
    do {
        foreach ($runspace in $runspaces) {
            if ($runspace.Status.IsCompleted) {
                $result = $runspace.Runspace.EndInvoke($runspace.Status)
                Write-Host $result.Message -ForegroundColor $(if ($result.Status -eq 'Success') { 'Green' } else { 'Red' })
                $completed++
            }
        }
        # Calculate and display load percentage
        $percentage = ($completed / $PrinterNames.Count) * 100
        Write-Progress -PercentComplete $percentage -Status "Adding Printers" -Activity "$completed out of $($PrinterNames.Count) printers added"
        Start-Sleep -Milliseconds 500 # Polling interval, can be adjusted
    } while ($completed -lt $PrinterNames.Count)

    $runspacePool.Close()
    $runspacePool.Dispose()
}



function Show-Menu {
    param (
        [string]$Title = 'Select Print Server'
    )

    Clear-Host
    Write-Host "================ $Title ================"

    Write-Host "1: testserver1"
    Write-Host "2: testserver2"
    Write-Host "Q: Quit"
}

while ($true) {
    Show-Menu
    $input = Read-Host "Please select a print server (1/2/Q)"

    switch ($input) {
        '1' {
            $printers = Read-Host "Enter the printer names (comma separated) for testserver1"
            Map-Printers -PrintServer 'MVP-PRT-FNT01' -PrinterNames ($printers -split ',')
        }
        '2' {
            $printers = Read-Host "Enter the printer names (comma separated) for testserver2"
            Map-Printers -PrintServer 'printserver' -PrinterNames ($printers -split ',')
        }
        'Q' { return }
    }
}
