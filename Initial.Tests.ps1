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
        $employeeRecord3 = @"
---
# An employee record
name: Example Developer
job: Developer
skill: Elite
employed: True
foods:
    - Apple
    - Orange
    - Strawberry
    - Mango
languages:
    ruby: Elite
    python: Elite
    dotnet: Lame
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

    Context "Employee Record 3 Data" {

        $result = $employeeRecord3 | ConvertFrom-Yaml

        It "should have a name" {
            $result.name | Should Be "Example Developer"
        }

        It "should have a job" {
            $result.job | Should Be "Developer"
        }

        It "should have skill" {
            $result.skill | Should Be "Elite"
        }

        It "should have 4 foods" {
            $result.foods.count | Should Be 4
        }

        It "should be employeed" {
            $result.employed | Should Be 'true'
        }

        It "should have three languages" {
            ($result.languages|gm -MemberType NoteProperty).count | Should Be 3
        }

    }
}

Describe "a sequence" {
    $s = @"
foods:
    - Apple
    - Orange
    - Strawberry
    - Mango
"@

    $result = $s | ConvertFrom-Yaml
    
    Context "This sequence" {
        It "should be an array" {
            $result.foods.gettype().basetype.name | Should Be Array
        }

        It "should have 4 items" {
            $result.foods.count | Should Be 4
        }

        It "should have an Apple" {
            $result.foods[0] | Should Be Apple
        }

        It "should have an Orange" {
            $result.foods[1] | Should Be Orange
        }

        It "should have an Strawberry" {
            $result.foods[2] | Should Be Strawberry
        }

        It "should have an Mango" {
            $result.foods[3] | Should Be Mango
        }
    }
}

Describe "a map" {
    $s = @"
languages:
    ruby: Elite
    python: Elite
    dotnet: Lame
"@

    $result = $s | ConvertFrom-Yaml
    
    Context "This map" {
        It "should be an object" {
            $result.languages.gettype().basetype.name | Should Be Object
        }

        It "should have a property ruby with a value elite" {
            $result.languages.ruby | Should Be Elite
        }

        It "should have a property python with a value elite" {
            $result.languages.python | Should Be Elite
        }
    }
}