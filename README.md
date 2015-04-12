PowerYaml
-

PowerYaml is a wrapper around [Yaml.Net]() library. The wrapper was originally developed by [Scott Muc](https://github.com/scottmuc) and [Manoj Mahalingam](https://github.com/manojlds).

Sample
-	
	Import-Module PowerYaml

    $yaml = @"
	parent: 
	  child:
	    a: a value
	    b: b value
	    c: c value
	  child2: 
	    key4: value 4
	    key5: value 5
	"@

	$r=$yaml | ConvertFrom-Yaml

Results
-
	$r.parent.child  
	
	a       b       c      
	-       -       -      
	a value b value c value
	
	$r.parent.child2
	
	key4    key5   
	----    ----   
	value 4 value 5                                                  


Import-Yaml
-
Does Files

	dir *.yml|Import-Yaml

Results
-
	name              job       skill     
	----              ---       -----     
	Example Developer Developer Elite     
	John Doe          Developer PowerShell

On GitHub [Yaml.Net](https://github.com/aaubry/YamlDotNet)