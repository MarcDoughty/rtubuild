**RTUBUILD - A helper script to automate and standardize Windows Offline Servicing**

Marc Doughty, 2018

Purpose:

Offline servicing is great, and there are mechanisms to do it in SCCM, but I wanted to create a simple, repeatable, logged offline servicing tool that would build updated WIMs from ISOs, CABs, and MSUs.

Usage:

1. Build a Windows 10 or Windows Server 2016 VM with the latest Windows ADK (only the deployment tools and preinstallation environment are required). Having sufficent RAM to keep the Windows image and update files in memory will make the process much faster. It is very I/O intensive. (I give my VM 20GB and it all gets used)
2. Git clone or download RTUBUILD to the root of your system drive.
3. Drop ISOs from the Windows versions you want installed into the 'isos' folder.
4. Drop update & package MSUs and CABs that you want installed into the corresponding 'packages' subfolder. Windows client images should have an RSAT included so they can run the postimageAD join scripts (they are included in Server). I put the latest servicing stack update, .NET 3.5 from the installer's 'sxs' folder, the latest cumulative monthly patch, and .NET 4.7 from Windows Update in mine.
5. Launch 'Deployment and Imaging Tools Environment' from the Windows ADK ' as administrator'.
6. Run 'powershell.exe -file c:\rtubuild\rtubuild.ps1'
7. When the process is complete, you can manually edit or service items in the 'mounts' folder, that's where the serviced WIMs are mounted. (e.g. copy the 'admin' folder)
8. Commit the changes to the WIMs by running 'powershell.exe -file c:\rtubuild\cleanup-save.ps1'
9. Create optimized WIMs by running 'powershell.exe -file c:\rtubuild\optimizer.ps1
10. The finalized WIMs should be in the 'wims' folder, ready to add to SCCM as 'Operating System Images'
