# Execute a query displaying on the screen the total number of H-19 cases in King and Pierce counties yesterday
clear
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

$mydata = Import-Csv -Path $dir\us-counties-H19-another.csv 
$king_sum =  $mydata | Where-Object -Property County -eq "King" | Where-Object -Property date -eq "2020-03-17" | Measure-Object cases -sum
$pierce_sum =  $mydata | Where-Object -Property County -eq "Pierce" | Where-Object -Property date -eq "2020-03-17" | Measure-Object cases -sum

write-output (“The total case number in King and Pierce county as of 2020-03-17 is {0}” -f $king_sum.Sum + $pierce_sum.Sum)

# Export an XML file with a limited output of the reporting
$king_sum | Export-Clixml -Path $dir\king.xml
$pierce_sum | Export-Clixml -Path $dir\pierce.xml

# Describe in a paragraph another automated export task you could implement for the database, and why.
# Generate daily and weekly report that shows the county cases in greater details.
# - total cases, heat map with fastest case growth
# - import/export error  