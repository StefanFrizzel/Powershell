
$Credential = Get-Credential
Import-Module MsOnline
Connect-MsolService -Credential $credential
$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $exchangeSession -DisableNameChecking

#Output file declaration
$ExportCSV=".\InboxRulesReport_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm` tt).ToString()).csv"


#actual task
$users = (get-mailbox -resultsize unlimited).UserPrincipalName
foreach ($user in $users)
{
	Get-InboxRule -Mailbox $user | Select-Object MailboxOwnerID,Name,Description,Enabled,RedirectTo, MoveToFolder,ForwardTo | Export-CSV -path $ExportCSV -NoTypeInformation -Append
}