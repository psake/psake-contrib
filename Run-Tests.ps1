Import-Module Pester

Invoke-Pester tests\** -OutputFile TestResult.xml -OutputFormat NUnitXml

$appVeyorJobId = $env:APPVEYOR_JOB_ID
if ($appVeyorJobId) {
	$url = "https://ci.appveyor.com/api/testresults/nunit/$appVeyorJobId"

	$wc = New-Object 'System.Net.WebClient'
	$wc.UploadFile($url, (Resolve-Path '.\TestResult.xml'));
	
	"Uploaded test results to AppVeyor."
}
