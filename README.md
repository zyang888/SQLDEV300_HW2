# SQLDEV300_HW2

## 1. Manually create a sample JSON file
Create a PowerShell script or scripts creating appropriate tables, and importing the information

- King County information should be imported daily except

- WA and OR data should be imported on weekends

![Image of Scheduled Tasks](/images/scheduledtasks.png)
![Image of Washington and Oregon data](/images/wa and or data.png)

- empty table 'Uploads' with the columns: "SourceFile, DestTable, UploadStartTime, UploadEndTime, Status"
![Image of empty table](/images/empty table.png)
Create another PowerShell script to import (and create necessary tables) for the

- US Population data

As an upload begins, the respective row in Uploads table should have Status='Started'. After the upload, it should be 'Finished' or 'Failed'. Update other fields as appropriate.

![Image of Population data](/images/testing.png)

## 2. Create the SQL statements needed to generate such a JSON automatically and correctly
Provide sanity testing for the US population data

### test total record count is within reason. Explain your choice in comments.



![Image of Population data](/images/testing.png)

## 3. Discuss and implement how you could test the code in #2.
Consider both testing the output report on the live data, and testing the reporting code on dummy data you create for the test. Do not corrupt the live data during testing.

![Image of reporting](/images/reporting.png)

## 4. Create a PowerShell script that executes the JSON report in #2, and at least one test from #3

`Generate daily and weekly report of import, export and report error.`

## 5.  Describe (in a couple paragraphs) your design choices (when you started) and your lessons (when your assignment was done) from this assignment and working with JSON.

Format is up to you but - for example:

`<data><county>King</county><data>1/1/2020</date><cases>999</cases></data>`

At this point, you can use a temporary table if you wish and the AS XML, or hand-craft the XML . Justify your choice.

![Image of King Count XML](/images/king_xml.png)
![Image of Pierce county XML](/images/pierce_xml.png)

### Describe in a paragraph another automated export task you could implement for the database, and why.

Generate daily and weekly report that shows the county cases in greater details.
 - total cases, heat map with fastest case growth
 - import/export error

## 6. Describe (in a couple paragraphs) a hypothetical use for this JSON report/export
