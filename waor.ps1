clear
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

$mydata = Import-Csv -Path $dir\us-counties-H19-another.csv 
$washington_data = $mydata | Where-Object -Property state -eq "Washington" | Format-Table
$oregon_data = $mydata | Where-Object -Property state -eq "Oregon" | Format-Table
