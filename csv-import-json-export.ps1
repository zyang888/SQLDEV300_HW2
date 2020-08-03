clear
##############################################
# This is a simple user/pass connection string.
##############################################

$SQLDatabase = "H19"
$SQLTable = "cases5"
$CSVFileName = "\us-counties-H19-another.csv"

try
{
    $connString = "Server=localhost;Database=$SQLDatabase;Trusted_Connection=True;"


    #Create a SQL connection object
    $conn = New-Object System.Data.SqlClient.SqlConnection $connString

    #Attempt to open the connection
    $conn.Open()
    if($conn.State -eq "Open")
    {
        # We have a successful connection here
        # Notify of successful connection
        Write-Host "Test connection successful"

        $conn.Close()
    }
    # We could not connect here
    # Notify connection was not in the "open" state
}
catch
{
    # We could not connect here
    # Notify there was an error connecting to the database
    Write-Host "Connection failed"
    exit
}
##############################################
# find current directory
##############################################

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

##############################################
# import csv file
##############################################

Write-Host "create H19 table"
$sql = "
DROP TABLE IF EXISTS $SQLTable;
CREATE TABLE $SQLTable (
    Date DATE,
    County varchar(255),
    State varchar(255),
    FIPS int,
    Cases int,
    Deaths int
);"
Write-Host "Creating Table"
Invoke-Sqlcmd -Query $sql -ConnectionString $connString

$CSVImport = Import-Csv -Path $dir$CSVFileName
# $kingcounty_data = $CSVImport | Where-Object -Property state -eq "Washington" | Where-Object -Property county -eq "King" | Format-Table
$CSVRowCount = $CSVImport.Count
Write-Host "Inserting $CSVRowCount rows from CSV into SQL Table $SQLTable"
ForEach ($CSVLine in $CSVImport) {
  # Setting variables for the CSV line, ADD ALL 170 possible CSV columns here
  $CSVDateString = $CSVLine.date
  $CSVCounty = $CSVLine.county
  $CSVCounty = $CSVCounty -replace "'", "''"
  $CSVState = $CSVLine.state

  $CSVFIPS = $CSVLine.fips
  $CSVCases = $CSVLine.cases
  $CSVDeaths = $CSVLine.deaths
  # Translating Date to SQL compatible format
  $CSVDate =  "{0:yyyy-MM-dd}" -f ([DateTime]$CSVDateString)

  $SQLInsert = "USE $SQLDatabase INSERT INTO $SQLTable (Date, County, State, FIPS, Cases, Deaths) VALUES('$CSVDate', '$CSVCounty', '$CSVState', '$CSVFIPS', '$CSVCases', '$CSVDeaths');"
  # Running the INSERT Query
  # Write-Host $SQLInsert
  Invoke-Sqlcmd -Query $SQLInsert -ConnectionString $connString
  # End of ForEach CSV line below
}
Write-Host "Insertion Completed"

##############################################
# Get Day N, cases day N+1 for each county
##############################################

Write-Host "Get Day N, cases day N+1 for each county"
$sqlQuery =
"SELECT TOP 5 MAX(Date) AS LastDay, State, County, (MAX(Cases)-Min(Cases)) AS Delta
FROM (
		SELECT *,
			ROW_NUMBER() OVER (PARTITION BY State, County
			ORDER BY Date DESC) AS RowNumber
		FROM dbo.cases5
	) AS Temp
WHERE Temp.RowNumber<=2
GROUP BY State, County
ORDER BY Delta DESC
"

$fileName = "$dir\temp.json"
Write-Host "Convert to JSON and save to path $fileName"
$res = Invoke-Sqlcmd -Query $sqlQuery -ConnectionString $connString
$res | Select-Object -Property County, State, LastDay, Delta |  ConvertTo-Json -Depth 1 | Out-File -FilePath $fileName

Write-Host "Query Completed"

##############################################
# Test Result
##############################################

$sorteddata = Get-Content -Raw -Path $fileName | ConvertFrom-Json
$verifyCounty = $sorteddata[0].County
$verifyState = $sorteddata[0].State

Write-Output "To verify the JSON export"
Write-Output $sorteddata

Write-Output "Data for the last two days of $verifyCounty, $verifyState"

$sqlQuery =
"SELECT TOP 2 *
FROM dbo.cases5
WHERE County='$verifyCounty' AND State='$verifyState'
ORDER BY Date DESC
"

$verifyRes = Invoke-Sqlcmd -Query $sqlQuery -ConnectionString $connString
$verifyRes
