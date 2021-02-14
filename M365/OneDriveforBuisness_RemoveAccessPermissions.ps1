Install-Module -Name Microsoft.Online.SharePoint.PowerShell



#Set Runtime Parameters
$AdminSiteURL="https://companyabc.sharepoint.com/"

#users to remove permission from
$users = 
"john.doe@companyabc.com",
"jane.doe@companyabc.com",
"joe.bloggs@companyabc.com";


#reports export path
$csvPathRemovedPermissions ="C:\temp\export\RemovedListPermissions_$(get-date -f yyyy-MM-dd_THHmm).csv" 
$csvPathFullListPermissions ="C:\temp\export\FullListPermissions_$(get-date -f yyyy-MM-dd_THHmm).csv"
 
#Connect to SharePoint Online Admin Center
Connect-SPOService -Url $AdminSiteURL #–credential $Cred
 
#Get all OneDrive for Business Site collections
$OneDriveSites = Get-SPOSite -Template "SPSPERS" -Limit ALL -IncludePersonalSite $True
Write-Host -f Yellow "Total Number of OneDrive Sites Found: "$OneDriveSites.count



#check all onedrive sites
Foreach($Site in $OneDriveSites)
{
    $owner = (Get-SPOSite $Site.url).owner;

    Write-Host -f Yellow "Checking Site "$site.url
    
    #for each member of that site
    foreach($member in Get-SPOUser -Limit ALL -Site $Site.Url)
    {
        #add to export_FullListPermissions.csv
        $match = New-Object psobject;
        $match | Add-Member -MemberType NoteProperty -name URL -Value ($Site.Url)
        $match | Add-Member -MemberType NoteProperty -name MemberLogin -Value ($member.LoginName)
        $match | Add-Member -MemberType NoteProperty -name MemberDisplayName -Value ($member.DisplayName)
        $match | Add-Member -MemberType NoteProperty -name Owner -Value $owner
        $match | export-csv -Path $csvPathFullListPermissions  -append 
    }

    #for each user we want to remove
    foreach($user in $users)
    {        
        if( (Get-SPOUser -Site $Site.Url -LoginName $user) -ne 'null' -and ($user -ne $owner))
        {
        
            #remove the user
            #Remove-SPOUser -Site $Site.Url  -LoginName $user
                        
            #add to the removed perms CSV   
            $match = New-Object psobject;
            $match | Add-Member -MemberType NoteProperty -name URL -Value ($Site.Url)
            $match | Add-Member -MemberType NoteProperty -name RemovedUser -Value $user             
            $match | Add-Member -MemberType NoteProperty -name Owner -Value $owner
            $match | export-csv -Path $csvPathRemovedPermissions  -append 
        }
    } 
}

Write-Host "Scanned all OneDrive Sites Successfully!" -f Green






