function MyGet-SetBuildNumber([string]$buildNumber) {
	MyGet-WriteServiceMessage 'buildNumber' $buildNumber
}

function MyGet-WriteBuildLogMessage([string]$text, [string]$errorDetails, [string]$status) {
	MyGet-WriteServiceMessage 'message ' @{ text=$text; errorDetails=$errorDetails; status=$status}
}

function MyGet-SetEnvironmentVariable([string]$name, [string]$value) {
	MyGet-WriteServiceMessage 'setParameter' @{ name=$name; value=$value}
}

function MyGet-ReportBuildProblem([string]$buildProblem) {
	MyGet-WriteServiceMessage 'buildProblem' @{ description=$buildProblem; }
}

function MyGet-WriteServiceMessage([string]$messageName, $messageAttributesHashOrSingleValue) {
	function escape([string]$value) {
		([char[]] $value | 
				%{ switch ($_) 
						{
								"|" { "||" }
								"'" { "|'" }
								"`n" { "|n" }
								"`r" { "|r" }
								"[" { "|[" }
								"]" { "|]" }
								([char] 0x0085) { "|x" }
								([char] 0x2028) { "|l" }
								([char] 0x2029) { "|p" }
								default { $_ }
						}
				} ) -join ''
		}

	if ($messageAttributesHashOrSingleValue -is [hashtable]) {
		$messageAttributesString = ($messageAttributesHashOrSingleValue.GetEnumerator() | 
			%{ "{0}='{1}'" -f $_.Key, (escape $_.Value) }) -join ' '
	} else {
		$messageAttributesString = ("'{0}'" -f (escape $messageAttributesHashOrSingleValue))
	}

	Write-Output "##myget[$messageName $messageAttributesString]"
}