# SQLDEV300_HW2

## 1. Manually create a sample JSON file

![Image of JSON File](/images/jsonfile.png)

## 2. Create the SQL statements needed to generate such a JSON automatically and correctly

![Image of Query](/images/Query.png)

## 3. Discuss and implement how you could test the code in #2.
Consider both testing the output report on the live data, and testing the reporting code on dummy data you create for the test. Do not corrupt the live data during testing.

To verify the results, I created query to get the last two days of cases for the counties that are listed in the JSON file. As an example, see query result for Harris, Texas as shown below. The differences in cases should match the delta number in the JSON file.
![Image of Tests](/images/testResult.png)
![Image of Tests](/images/Test.png)

## 4. Create a PowerShell script that executes the JSON report in #2, and at least one test from #3

Please see `csv-import-json-export.ps1`

## 5.  Describe (in a couple paragraphs) your design choices (when you started) and your lessons (when your assignment was done) from this assignment and working with JSON.

I found T-SQL is easier to use than PowerShell when it comes to query and filtering data, whereas PowerShell is good at processing files and handling processed data.

To handle query result from `$res = Invoke-Sqlcmd -Query $sqlQuery -ConnectionString $connString` in PowerShell
Use the line below to filter out the noise and construct JSON file.
`$res | Select-Object -Property County, State, LastDay, Delta |  ConvertTo-Json -Depth 1 | Out-File -FilePath $fileName`

## 6. Describe (in a couple paragraphs) a hypothetical use for this JSON report/export
Great lesson to process data and generate report using JSON to store and transfer data.
