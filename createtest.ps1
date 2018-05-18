ForEach ($WIM in (Get-ChildItem -Recurse install.wim))
	{
	$Images = (Get-WindowsImage -ImagePath $WIM.FullName | Select-Object *)
		ForEach ($Image in $Images)
			{
            $ImageDetail = ( Get-WindowsImage -ImagePath $WIM.FullName -Index $Image.ImageIndex )
			$MountPoint = (-Join (".\mounts\",$Image.ImageName,"-",$ImageDetail.Version))
			#New-Item -Type Directory "$MountPoint"
            Write-Host $MountPoint
            }
    }