#first time running

Install-Module ExchangeOnlineManagement


#run from here
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline


#params
$user = "john.doe@companyabc.co.uk"

# enable auto reply params
$start = "12/29/2020 15:11:00"
$finish = "12/29/2020 15:15:00"
$internalMessage = "auto-reply message for employees"
$externalMessage = "auto-reply message for everyone else"


# disable auto reply
Set-MailboxAutoReplyConfiguration -Identity $user -AutoReplyState Disabled

# enable auto reply
Set-MailboxAutoReplyConfiguration -Identity $user -AutoReplyState Scheduled -StartTime $start -EndTime $finish -InternalMessage $internalMessage -ExternalMessage $externalMessage











