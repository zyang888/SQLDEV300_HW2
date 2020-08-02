clear
try
{
    # This is a simple user/pass connection string.
    $connString = "Server=localhost;Database=H19;Trusted_Connection=True;"


    #Create a SQL connection object
    $conn = New-Object System.Data.SqlClient.SqlConnection $connString

    #Attempt to open the connection
    $conn.Open()
    if($conn.State -eq "Open")
    {
        # We have a successful connection here
        # Notify of successful connection
        Write-Host "Test connection successful"
        # test query
#Invoke-Sqlcmd -Query "Select * from e"  -ServerInstance "localhost\H19"
        $conn.Close()
    }
    # We could not connect here
    # Notify connection was not in the "open" state
}
catch
{
    # We could not connect here
    # Notify there was an error connecting to the database
    Write-Host "Test connection failed"
    exit
}

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
#Write-host "the current directory is $dir"

if ($(Get-ScheduledTask -TaskName "King import" -ErrorAction SilentlyContinue).TaskName -eq "King import") {
    Unregister-ScheduledTask -TaskName "King import" -Confirm:$False
}
if ($(Get-ScheduledTask -TaskName "WAOR import" -ErrorAction SilentlyContinue).TaskName -eq "WAOR import") {
    Unregister-ScheduledTask -TaskName "WAOR import" -Confirm:$False
}

# - King County information should be imported daily except

$kingtime=New-ScheduledTaskTrigger -Daily -At 3am
$kingaction=New-ScheduledTaskAction -Execute PowerShell.exe -WorkingDirectory $dir -Argument “$dir\kingcounty.ps1"
Register-ScheduledTask -TaskName "King import" -Trigger $kingtime -Action $kingaction -RunLevel Highest

# - WA and OR data should be imported on weekends

$waortime=New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Saturday -At 3am
$waoraction=New-ScheduledTaskAction -Execute PowerShell.exe -WorkingDirectory $dir -Argument “$dir\waor.ps1"
Register-ScheduledTask -TaskName "WAOR import" -Trigger $waortime -Action $waoraction -RunLevel Highest

# - empty table 'Uploads' with the columns: "SourceFile, DestTable, UploadStartTime, UploadEndTime, Status"

$sql = "
DROP TABLE IF EXISTS  dbo.Uploads;
CREATE TABLE Uploads (
    ID int,
    SourceFile varchar(255),
    DestTable varchar(255),
    UploadStartTime DATETIME,
    UploadEndTime DATETIME,
    Status varchar(255)
);"

Invoke-Sqlcmd -Query $sql -ConnectionString $connString


# Create another PowerShell script to import (and create necessary tables) for the US Population data
#.\population.ps1

# Execute a query displaying on the screen the total number of H-19 cases in King and Pierce counties yesterday 
# .\reporting.ps1