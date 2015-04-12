Add-Type -Path $PSScriptRoot\YamlDotNet.Core.dll
Add-Type -Path $PSScriptRoot\YamlDotNet.RepresentationModel.dll

function Convert-YamlMappingNodeToHash($node) {
    $hash = [ordered]@{}
    $yamlNodes = $node.Children

    foreach($key in $yamlNodes.Keys) {
        $hash.$($key.Value) = Convert-YamlNode $yamlNodes.$key
    }

    [PSCustomObject]$hash
}

function Convert-YamlNode($node) {
    switch ($node) {
        {$_ -is [YamlDotNet.RepresentationModel.YamlScalarNode]} {
            $_.Value
        }

        {$_ -is [YamlDotNet.RepresentationModel.YamlMappingNode]} {
            Convert-YamlMappingNodeToHash $_
        }

        {$_ -is [YamlDotNet.RepresentationModel.YamlSequenceNode]} {foreach($yamlNode in $_.Children) {
            Convert-YamlNode $yamlNode }
        }
    }
}

function ConvertFrom-Yaml {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$yaml
    )

    Process {
        $reader = New-Object System.IO.StringReader $yaml
        $yamlStream = New-Object YamlDotNet.RepresentationModel.YamlStream
        $yamlStream.Load($reader)
        $reader.Close()

        Convert-YamlNode $yamlStream.Documents.Rootnode
    }
}

function Import-Yaml {
    param(
        [Parameter(ValueFromPipeline)]
        $LiteralPath
    )
    
    Process {
        [System.IO.File]::ReadAllText($LiteralPath) | ConvertFrom-Yaml 
    }           
}