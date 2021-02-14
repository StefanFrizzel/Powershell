#if first time running
Install-Module MSOnline



##Set these Params - Choose from "Disabled", "Enabled" or "Enforced"
$CurrentState = "Disabled"
$NewState = "Enabled"

Connect-MsolService

# Select users based on $CurrentState of MFA Status
$users Get-MsolUser -all | 
   select DisplayName,UserPrincipalName,@{Name="MFA Status"; Expression=
   { 
        if($_.StrongAuthenticationRequirements.Count -ne 0)
            { 
                $_.StrongAuthenticationRequirements[0].State
            } else 
            { 
                'Disabled'
            }
    }
} | where-Object -Property 'MFA Status' -eq $CurrentState | Sort-Object -Property 'DisplayName'


# Change MFAState to $NewState
$users | Set-MfaState -State $NewState



# Sets the MFA requirement state
function Set-MfaState {

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$True)]
        $ObjectId,
        [Parameter(ValueFromPipelineByPropertyName=$True)]
        $UserPrincipalName,
        [ValidateSet("Disabled","Enabled","Enforced")]
        $State
    )

    Process {
        Write-Verbose ("Setting MFA state for user '{0}' to '{1}'." -f $ObjectId, $State)
        $Requirements = @()
        if ($State -ne "Disabled") {
            $Requirement =
                [Microsoft.Online.Administration.StrongAuthenticationRequirement]::new()
            $Requirement.RelyingParty = "*"
            $Requirement.State = $State
            $Requirements += $Requirement
        }

        Set-MsolUser -ObjectId $ObjectId -UserPrincipalName $UserPrincipalName `
                     -StrongAuthenticationRequirements $Requirements
    }
}
