
#Add-Type -Path  .\YamlDotNet.Core.dll
#Add-Type -Path .\YamlDotNet.RepresentationModel.dll

Add-Type -Path  .\Libs\YamlDotNet.Core.dll
Add-Type -Path .\Libs\YamlDotNet.RepresentationModel.dll

function Convert-YamlMappingNodeToHash($node) {
    $hash = [ordered]@{}
    $yamlNodes = $node.Children

    foreach($key in $yamlNodes.Keys) {
        $hash.$($key.Value) = Explode-Node $yamlNodes.$key
    }

    [PSCustomObject]$hash
}

function Explode-Node($node) {
    switch ($node) {
        {$_ -is [YamlDotNet.RepresentationModel.YamlScalarNode]} {
            $_.Value
        }
        
        {$_ -is [YamlDotNet.RepresentationModel.YamlMappingNode]} {
            Convert-YamlMappingNodeToHash $_
        }
        
        {$_ -is [YamlDotNet.RepresentationModel.YamlSequenceNode]} {foreach($yamlNode in $_.Children) { 
            Explode-Node $yamlNode }
        }
    }
}

function ConvertFrom-Yaml {
    param(
        [Parameter(ValueFromPipeline)]
        $yaml
    )
    
    Process {
        $r=New-Object System.IO.StringReader $yaml
        $obj = New-Object YamlDotNet.RepresentationModel.YamlStream
        $obj.Load($r)
        $r.Close()

        Explode-Node $obj.Documents.Rootnode
    }
}

function Import-Yaml {
}

cls

$yaml = @"
sudo: false

language: go

go:
  - 1.2
  - 1.3
  - 1.4
  - tip

install: make updatedeps

script:
  - GOMAXPROCS=2 make test
  #- go test -race ./...

branches:
  only:
    - master

notifications:
  irc:
    channels:
      - "irc.freenode.org#packer-tool"
    skip_join: true
    use_notice: true

matrix:
  fast_finish: true
  allow_failures:
    - go: tip
"@

#$yaml | ConvertFrom-Yaml
@"
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
"@ | ConvertFrom-Yaml

return
@"
---
# An employee record
{name: Example Developer, job: Developer, skill: Elite}
"@ | ConvertFrom-Yaml

@"
---
# An employee record
name: Example Developer
job: Developer
skill: PowerShell
"@ | ConvertFrom-Yaml