clear
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

$mydata = Import-Csv -Path $dir\us-counties-H19-another.csv 
$kingcounty_data = $mydata | Where-Object -Property state -eq "Washington" | Where-Object -Property county -eq "King" | Format-Table