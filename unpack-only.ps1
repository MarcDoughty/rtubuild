Import-Module Dism
Set-Location C:\RTUBUILD

ForEach ($ISO in (Get-ChildItem -Recurse isos\*.ISO))
	{
	Write-Host "Unpacking $ISO..."
	New-Item -Type Directory -Path (-join($ISO.DirectoryName,"\",$ISO.BaseName))
	$ExtractPath = (-Join ("-o",$ISO.DirectoryName,"\",$ISO.BaseName)) # we need to bake this up first
	Start-Process ".\7-Zip\7z.exe" -ArgumentList "e",$ISO.FullName,"*.wim","*.cab",$ExtractPath,"-r" -NoNewWindow -Wait
	}