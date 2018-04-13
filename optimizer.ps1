$DateStamp = (Get-Date -UFormat %Y%m%d)

ForEach ($WIM in (Get-ChildItem -Recurse isos\install.wim))
	{
	$Images = (Get-WindowsImage -ImagePath $WIM.FullName | Select-Object *)
		ForEach ($Image in $Images | Where-Object	{$_.ImageName -eq "Windows 10 Enterprise" -or $_.ImageName -eq "Windows 10 Enterprise 2016 LTSB" -or $_.ImageName -eq "Windows Server 2016 SERVERSTANDARDACORE" -or $_.ImageName -eq "Windows Server 2016 SERVERSTANDARDCORE" -or $_.ImageName -eq "Windows Server 2016 SERVERSTANDARD"})
			{
			Write-Host " "
			Write-Host "Exporting:  " `"$Image.ImageName`" "from" $Image.ImagePath 
			$ImageDetail = ( Get-WindowsImage -ImagePath $WIM.FullName -Index $Image.ImageIndex | Select-Object * )
			$TargetWIM = (-Join (".\wims\","rtu-",$ImageDetail.ImageName,"-",$ImageDetail.MajorVersion,".",$ImageDetail.MinorVersion,".",$ImageDetail.Build,"-",$DateStamp,".wim"))
			Write-Host "ImageDetail " $ImageDetail
			Write-Host "TargetWIM   " $TargetWIM
			Export-WindowsImage -CompressionType Max -SourceImagePath $Image.ImagePath -SourceIndex $Image.ImageIndex -DestinationImagePath $TargetWIM
			}
	}