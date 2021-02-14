Install-Module -Name AzureAD

Connect-AzureAD

$userlist = "\\path\to\listOfUsers.txt"

#block each user
foreach($line in Get-Content $userlist)
{ 

   
    $user = Get-AzureADUser -ObjectID $line
    Set-AzureADUser -ObjectId $line -AccountEnabled 0
    
}


#check status for each user
foreach($line in Get-Content $userlist)
{ 
   
    $user = Get-AzureADUser -ObjectID $line
    Get-AzureADUser -ObjectID $user.ObjectId | Select DisplayName,UserPrincipalName,AccountEnabled
    
}

