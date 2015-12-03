Import-Module ".\teamcity.psm1" -DisableNameChecking -Force

Describe "TeamCity-WriteServiceMessage" {
    It "Writes ##teamcity[message 'Single parameter message.']" {
        TeamCity-WriteServiceMessage "message" "Single parameter message." | `
          Should BeExactly "##teamcity[message 'Single parameter message.']"
    }
    
    It "Writes ##teamcity[message key='value']" {
        TeamCity-WriteServiceMessage "message" @{ key = 'value'} | `
          Should BeExactly "##teamcity[message key='value']"
    }
}

Describe "TeamCity-TestSuiteStarted" {
    It "Writes ##teamcity[testSuiteStarted name='suiteName']" {
        TeamCity-TestSuiteStarted "suiteName" | `
          Should BeExactly "##teamcity[testSuiteStarted name='suiteName']"
    }
}

Describe "TeamCity-TestSuiteFinished" {
    It "Writes ##teamcity[testSuiteFinished name='suiteName']" {
        TeamCity-TestSuiteFinished "suiteName" | `
          Should BeExactly "##teamcity[testSuiteFinished name='suiteName']"
    }
}

Describe "TeamCity-TestStarted" {
    It "Writes ##teamcity[testStarted name='testName']" {
        TeamCity-TestStarted "testName" | `
          Should BeExactly "##teamcity[testStarted name='testName']"
    }
}

Describe "TeamCity-TestFinished" {
    It "Writes ##teamcity[testFinished duration='0' name='testName'] when no duration is given" {
        TeamCity-TestFinished "testName" | `
          Should BeExactly "##teamcity[testFinished duration='0' name='testName']"
    }
    
    It "Writes ##teamcity[testFinished duration='0' name='testName'] when 0 duration is given" {
        TeamCity-TestFinished "testName" 0 | `
          Should BeExactly "##teamcity[testFinished duration='0' name='testName']"
    }
    
    It "Writes ##teamcity[testFinished duration='247' name='testName'] when 247 duration is given" {
        TeamCity-TestFinished "testName" 247 | `
          Should BeExactly "##teamcity[testFinished duration='247' name='testName']"
    }
    
    It "Writes ##teamcity[testFinished duration='-1' name='testName'] when duration is negative number" {
        TeamCity-TestFinished "testName" -1 | `
          Should BeExactly "##teamcity[testFinished duration='-1' name='testName']"
    }
}

Describe "TeamCity-TestIgnored" {
    It "Writes ##teamcity[testIgnored message='' name='testName']" {
        TeamCity-TestIgnored "testName" | `
          Should BeExactly "##teamcity[testIgnored message='' name='testName']"
    }
    
    It "Writes ##teamcity[testIgnored message='ignore comment' name='testName']" {
        TeamCity-TestIgnored "testName" "ignore comment" | `
          Should BeExactly "##teamcity[testIgnored message='ignore comment' name='testName']"
    }
}

Describe "TeamCity-TestOutput" {
    It "Writes ##teamcity[testStdOut name='className.testName' out='text']" {
        TeamCity-TestOutput "className.testName" "text" | `
          Should BeExactly "##teamcity[testStdOut name='className.testName' out='text']"
    }
}

Describe "TeamCity-TestError" {
    It "Writes ##teamcity[testStdErr name='className.testName' out='error text']" {
        TeamCity-TestError "className.testName" "error text" | `
          Should BeExactly "##teamcity[testStdErr name='className.testName' out='error text']"
    }
}

Describe "TeamCity-TestFailed" {
    It "Writes ##teamcity[testFailed message='failure message' type='comparisonFailure' actual='actual value' expected='expected value' details='message and stack trace' name='MyTest.test2']" {
        TeamCity-TestFailed "MyTest.test2" "failure message" "message and stack trace" "comparisonFailure" "expected value" "actual value" | `
          Should BeExactly "##teamcity[testFailed message='failure message' type='comparisonFailure' actual='actual value' expected='expected value' details='message and stack trace' name='MyTest.test2']"
    }
}

Describe "TeamCity-ConfigureDotNetCoverage" {
    It "Writes ##teamcity[dotNetCoverage ncover3_home='C:\tools\ncover3']" {
        TeamCity-ConfigureDotNetCoverage "ncover3_home" "C:\tools\ncover3" | `
          Should BeExactly "##teamcity[dotNetCoverage ncover3_home='C:\tools\ncover3']"
    }
    
    It "Writes ##teamcity[dotNetCoverage partcover_report_xslts='file.xslt=>generatedFileName.html']" {
        TeamCity-ConfigureDotNetCoverage "partcover_report_xslts" "file.xslt=>generatedFileName.html" | `
          Should BeExactly "##teamcity[dotNetCoverage partcover_report_xslts='file.xslt=>generatedFileName.html']"
    }
}

Describe "TeamCity-ImportDotNetCoverageResult" {
    It "Writes ##teamcity[importData type='dotNetCoverage' tool='ncover3' path='C:\BuildAgent\work\build1\results.xml']" {
        TeamCity-ImportDotNetCoverageResult "ncover3" "C:\BuildAgent\work\build1\results.xml" | `
          Should BeExactly "##teamcity[importData path='C:\BuildAgent\work\build1\results.xml' tool='ncover3' type='dotNetCoverage']"
    }
}

Describe "TeamCity-ImportFxCopResult" {
    It "Writes ##teamcity[importData type='FxCop' path='C:\BuildAgent\work\results.xml']" {
        TeamCity-ImportFxCopResult "C:\BuildAgent\work\results.xml" | `
          Should BeExactly "##teamcity[importData type='FxCop' path='C:\BuildAgent\work\results.xml']"
    }
}

Describe "TeamCity-ImportDuplicatesResult" {
    It "Writes ##teamcity[importData type='DotNetDupFinder' path='C:\BuildAgent\work\results.xml']" {
        TeamCity-ImportDuplicatesResult "C:\BuildAgent\work\results.xml" | `
          Should BeExactly "##teamcity[importData type='DotNetDupFinder' path='C:\BuildAgent\work\results.xml']"
    }
}

Describe "TeamCity-ImportInspectionCodeResult" {
    It "Writes ##teamcity[importData type='ReSharperInspectCode' path='C:\BuildAgent\work\results.xml']" {
        TeamCity-ImportInspectionCodeResult "C:\BuildAgent\work\results.xml" | `
          Should BeExactly "##teamcity[importData type='ReSharperInspectCode' path='C:\BuildAgent\work\results.xml']"
    }
}

Describe "TeamCity-ImportNUnitReport" {
    It "Writes ##teamcity[importData type='nunit' path='C:\BuildAgent\work\results.xml']" {
        TeamCity-ImportNUnitReport "C:\BuildAgent\work\results.xml" | `
          Should BeExactly "##teamcity[importData type='nunit' path='C:\BuildAgent\work\results.xml']"
    }
}

Describe "TeamCity-ImportJSLintReport" {
    It "Writes ##teamcity[importData type='jslint' path='C:\BuildAgent\work\results.xml']" {
        TeamCity-ImportJSLintReport "C:\BuildAgent\work\results.xml" | `
          Should BeExactly "##teamcity[importData type='jslint' path='C:\BuildAgent\work\results.xml']"
    }
}

Describe "TeamCity-PublishArtifact" {
    It "Writes ##teamcity[publishArtifacts 'artifacts\*.exe -> App.zip']" {
        TeamCity-PublishArtifact "artifacts\*.exe -> App.zip" | `
          Should BeExactly "##teamcity[publishArtifacts 'artifacts\*.exe -> App.zip']"
    }
}

Describe "TeamCity-ReportBuildStart" {
    It "Writes ##teamcity[progressStart 'Compilation started']" {
        TeamCity-ReportBuildStart "Compilation started" | `
          Should BeExactly "##teamcity[progressStart 'Compilation started']"
    }
}

Describe "TeamCity-ReportBuildProgress" {
    It "Writes ##teamcity[progressMessage 'Build progress message']" {
        TeamCity-ReportBuildProgress "Build progress message" | `
          Should BeExactly "##teamcity[progressMessage 'Build progress message']"
    }
}

Describe "TeamCity-ReportBuildFinish" {
    It "Writes ##teamcity[progressFinish 'Build finished.']" {
        TeamCity-ReportBuildFinish "Build finished." | `
          Should BeExactly "##teamcity[progressFinish 'Build finished.']"
    }
}

Describe "TeamCity-ReportBuildStatus" {
    It "Writes ##teamcity[buildStatus text='{build.status.text}, 10/10 tests passed' status='SUCCESS']" {
        TeamCity-ReportBuildStatus "SUCCESS" "{build.status.text}, 10/10 tests passed" | `
          Should BeExactly "##teamcity[buildStatus text='{build.status.text}, 10/10 tests passed' status='SUCCESS']"
    }
    
    It "Writes ##teamcity[buildStatus text='{build.status.text}, 10/10 tests passed'] without optional status attribute." {
        TeamCity-ReportBuildStatus -text "{build.status.text}, 10/10 tests passed" | `
          Should BeExactly "##teamcity[buildStatus text='{build.status.text}, 10/10 tests passed']"
    }
}

Describe "TeamCity-SetBuildNumber" {
    It "Writes ##teamcity[buildNumber '1.2.3_{build.number}-ent']" {
        TeamCity-SetBuildNumber "1.2.3_{build.number}-ent" | `
          Should BeExactly "##teamcity[buildNumber '1.2.3_{build.number}-ent']"
    }
}

Describe "TeamCity-SetParameter" {
    It "Writes ##teamcity[setParameter value='value1' name='system.p1']" {
        TeamCity-SetParameter "system.p1" "value1" | `
          Should BeExactly "##teamcity[setParameter value='value1' name='system.p1']"
    }
}

Describe "TeamCity-SetBuildStatistic" {
    It "Writes ##teamcity[buildStatisticValue key='unittests.count' value='19']" {
        TeamCity-SetBuildStatistic "unittests.count" "19" | `
          Should BeExactly "##teamcity[buildStatisticValue key='unittests.count' value='19']"
    }
}

Describe "TeamCity-EnableServiceMessages" {
    It "Writes ##teamcity[enableServiceMessages]" {
        TeamCity-EnableServiceMessages| `
          Should BeExactly "##teamcity[enableServiceMessages]"
    }
}

Describe "TeamCity-DisableServiceMessages" {
    It "Writes ##teamcity[disableServiceMessages]" {
        TeamCity-DisableServiceMessages | `
          Should BeExactly "##teamcity[disableServiceMessages]"
    }
}
