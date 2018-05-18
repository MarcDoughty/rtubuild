Import-Module Dism
Set-Location C:\RTUBUILD

$DateStamp = (Get-Date -UFormat %Y%m%d)
$LogPath   = (-Join ("logs\rtubuild-",$DateStamp,".log"))

Start-Transcript -Append -Path $LogPath

ForEach ($ISO in (Get-ChildItem -Recurse isos\*.ISO))
	{
	Write-Host "Unpacking: $ISO..."
	New-Item -Type Directory -Path (-join($ISO.DirectoryName,"\",$ISO.BaseName))
	$ExtractPath = (-Join ("-o",$ISO.DirectoryName,"\",$ISO.BaseName)) # we need to bake this up first
	Start-Process ".\7-Zip\7z.exe" -ArgumentList "e",$ISO.FullName,"*.wim","*.cab",$ExtractPath,"-r" -NoNewWindow -Wait
	Write-Host ""
	Write-Host ""
	Write-Host ""
	}

ForEach ($WIM in (Get-ChildItem -Recurse isos\install.wim))
	{
	$Images = (Get-WindowsImage -ImagePath $WIM.FullName | Select-Object *)
		ForEach ($Image in $Images | Where-Object	{$_.ImageName -eq "Windows 10 Enterprise" -or $_.ImageName -eq "Windows 10 Enterprise 2016 LTSB" -or $_.ImageName -eq "Windows Server 2016 SERVERSTANDARDACORE" -or $_.ImageName -eq "Windows Server 2016 SERVERSTANDARDCORE" -or $_.ImageName -eq "Windows Server 2016 SERVERSTANDARD"})
			{
			
			# Generate mountpoints
			$ImageDetail = ( Get-WindowsImage -ImagePath $WIM.FullName -Index $Image.ImageIndex )
			$MountPoint = (-Join (".\mounts\",$Image.ImageName,"-",$ImageDetail.Version))
			
			Write-Host "Creating Mountpoint: $MountPoint"
			New-Item -Type Directory "$MountPoint"

			# Mount images
			Write-Host "Mounting:" $Image.ImageName
			Mount-WindowsImage -Verbose  -Path "$MountPoint" -ImagePath $WIM.FullName -Index $Image.ImageIndex
			Write-Host ""
			Write-Host ""
			Write-Host ""
			}
	}

# On to the patching and features!
	
# Server 1607
ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0 "*Server 2016*10.0.14393.*"))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "NetFx3" -All -Source ".\packages\srv2016-1607"
	Add-WindowsPackage -Verbose -Path "$MountedImagePath" -PackagePath ".\packages\srv2016-1607"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "ActiveDirectory-PowerShell" -All
	#Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "WindowsServerBackup" -All
	Write-Host ""
	Write-Host ""
	Write-Host ""
	}

# Server 1709
ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0 "*Server 2016*10.0.16299.*"))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "NetFx3" -All -Source ".\packages\srv2016-1709"
	Add-WindowsPackage -Verbose -Path "$MountedImagePath" -PackagePath ".\packages\srv2016-1709"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "ActiveDirectory-PowerShell" -All
	#Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "WindowsServerBackup" -All
	Write-Host ""
	Write-Host ""
	Write-Host ""
	}

# Server 1803
ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0 "*Server 2016*10.0.17134.*"))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "NetFx3" -All -Source ".\packages\srv2016-1803"
	Add-WindowsPackage -Verbose -Path "$MountedImagePath" -PackagePath ".\packages\srv2016-1803"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "ActiveDirectory-PowerShell" -All
	#Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "WindowsServerBackup" -All
	Write-Host ""
	Write-Host ""
	Write-Host ""
	}

	
# Windows 1607
ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0 "Windows 10*10.0.14393.*"))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "NetFx3" -All -Source ".\packages\win10-1607"
	Add-WindowsPackage -Verbose -Path "$MountedImagePath" -PackagePath ".\packages\win10-1607"
	#Not needed with 1803 RSAT?# Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "RSATClient-Roles-AD-Powershell" -All
	Write-Host ""
	Write-Host ""
	Write-Host ""
	}

# Windows 1703
ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0 "Windows 10*10.0.15063.*"))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "NetFx3" -All -Source ".\packages\win10-1703"
	Add-WindowsPackage -Verbose -Path "$MountedImagePath" -PackagePath ".\packages\win10-1703"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "RSATClient-Roles-AD-Powershell" -All
  Write-Host ""
	}

# Windows 1709
ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0 "Windows 10*10.0.16299.*"))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "NetFx3" -All -Source ".\packages\win10-1709"
	Add-WindowsPackage -Verbose -Path "$MountedImagePath" -PackagePath ".\packages\win10-1709"
	Write-Host ""
	Write-Host ""
	Write-Host ""	}

# Windows 1803
ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0 "Windows 10*10.0.17134.*"))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Enable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "NetFx3" -All -Source ".\packages\win10-1803"
	Add-WindowsPackage -Verbose -Path "$MountedImagePath" -PackagePath ".\packages\win10-1709"
	Write-Host ""
	Write-Host ""
	Write-Host ""	}

ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0))
	{
	$MountedImagePath = ($MountedImage.FullName)
	Write-Host "Servicing $MountedImagePath"
	Disable-WindowsOptionalFeature -Verbose -Path "$MountedImagePath" -FeatureName "SMB1Protocol"
	Start-Process "dism.exe" -ArgumentList "/Image:`"$MountedImagePath`"","/Set-Timezone:`"US Eastern Standard Time`"" -Wait -NoNewWindow
	Write-Host ""
	Write-Host ""
	Write-Host ""
	}

	
#ForEach ($MountedImage in (Get-ChildItem -Path .\mounts\ -Depth 0))
#	{
#	$MountedImagePath = ($MountedImage.FullName)
#	Write-Host $MountedImagePath
#	Dismount-WindowsImage -Path "$MountedImagePath" -Save -Verbose
#   Write-Host ""
#	}

Stop-Transcript