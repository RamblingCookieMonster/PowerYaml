Add-Type -Path $PSScriptRoot\YamlDotNet.dll

function Convert-YamlNode($node) {
    $h=[Ordered]@{}
    foreach ($item in $node) {
        switch ($item) {

            {$_.Value -is [YamlDotNet.RepresentationModel.YamlScalarNode]} {
                $h.$($_.key) = $_.Value
            }

            {$_.Value -is [YamlDotNet.RepresentationModel.YamlSequenceNode]} {
                $h.($_.key) = $_.Value.Value
            }

            {$_.Value -is [YamlDotNet.RepresentationModel.YamlMappingNode]} {

                $inner=[Ordered]@{}

                foreach ($element in $_.Value) {
                    $inner.$($element.key.value) = $element.value.value

                }

                $h.$($_.key)=[PSCustomObject]$inner
            }
        }
    }

    [PSCustomObject]$h
}

function ConvertFrom-Yaml {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$yaml
    )

    Process {
        $reader     = New-Object System.IO.StringReader $yaml
        $yamlStream = New-Object YamlDotNet.RepresentationModel.YamlStream
        $yamlStream.Load($reader)
        $reader.Close()

        Convert-YamlNode $yamlStream.Documents.Rootnode $h
    }
}

function ConvertFrom-YamlUri {
    param($uri)

    Invoke-RestMethod $uri | ConvertFrom-Yaml
}