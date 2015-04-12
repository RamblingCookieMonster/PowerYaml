$pwd = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests", "")
. "$pwd\$sut"

Describe "when converting yaml it should have properties and values" {

    $employeeRecord1 = @"
---
# An employee record
name: Example Developer
job: Developer
skill: Elite
"@

        $employeeRecord2 = @"
---
# An employee record
{name: Example Developer, job: Developer, skill: Elite}
"@ 

    Context "Employee Record 1 Data" {

        $result = $employeeRecord1 | ConvertFrom-Yaml

        It "should these names and values" {
            $result.name | Should Be 'Example Developer' 
            $result.job | Should Be Developer 
            $result.skill | Should Be Elite
        }
    }

    Context "Employee Record 2 Data" {

        $result = $employeeRecord2 | ConvertFrom-Yaml

        It "should these names and values" {
            $result.name | Should Be 'Example Developer' 
            $result.job | Should Be Developer 
            $result.skill | Should Be Elite
        }
    }
}