Import-Module Dism
Set-Location C:\RTUBUILD

ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host $MountedImagePath
	Dismount-WindowsImage -Path "$MountedImagePath" -Save -Verbose
	}