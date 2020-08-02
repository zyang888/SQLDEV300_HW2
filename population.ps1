clear
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

$mydata = Import-Csv -Path $dir\US-population-short.csv
$record_sum =  $mydata | Where-Object -Property County -eq "All" | Select-Object -expand Population
$record_sum = [int] $record_sum
$calc_sum = $mydata | Where-Object -Property County -ne "All" | Measure-Object "Population" -sum | Select-Object -expand sum
$calc_sum = [int] $calc_sum
Write-Host "Total record count: $record_sum"
Write-Host "Calculated Total population: $calc_sum"

# test total record count is within reason. Explain your choice in comments.
# test the total 'US population' is within range. Explain your choice in comments.
# test a specific county population is within range.  Explain your choice in comments.
if($record_sum -eq $calc_sum) {
    Write-Host "Total record count is equal to the sum of all county population"
} else {
    Write-Host "Total record count is not equal to the sum of all county population"
} 

# To test population is within range, one can group and sum county population by state. 
$population_state = $mydata | Group-Object State |
Select-Object @{Name='State';Expression={$_.Values[0]}},
              @{Name='Population';Expression={($_.Group|Measure-Object Population -Sum).Sum}} | Format-Table

# The result shows invalid state entries such as the ones with trailing quotation mark. 
# Then, one can compare calculated population with published state population.