Function Start-AzureLogin              {

    <#
    .Synopsis
       start-azurelogin
    .DESCRIPTION
       start-azurelogin
    .EXAMPLE
       start-azurelogin
    .EXAMPLE
       start-azurelogin -remove
    .NOTES
       Script created by Mark vd Waarsenburg (2017)
    #>

    [CmdletBinding(DefaultParameterSetName='Parameter Set 1')]

    Param(
        [Parameter(ParameterSetName='Parameter Set 1')]
        [switch]$remove,
        [Switch]$silent
    )

    Begin{
        #Remove Login Variable
        If($remove){Remove-Variable -name Login -Force}

    }#Begin

    Process{
    
            #Login to azure
            If($login -like ""){          
                    $script:Login = Login-AzureRmAccount
                    Write-host "[Login] : Welkom $($login.Context.Account.id). `n[Login] : You are logged on to $($login.Context.Environment.name) with subscriptin $($login.Context.Subscription.SubscriptionName)" -for Green
            }else{
                  If(!($silent)){
                    Write-host "[Login] : Hi $($login.Context.Account.id). `n[Login] : You are already logged on to $($login.Context.Environment.name) with subscription $($login.Context.Subscription.SubscriptionName)" -for Green
                  }#endIF
            } #Endif
    
    }#Process

    End{}#End

} #end Function
Function Select-Subscription           {
    <#
    .Synopsis
       Select-Subscription 
    .DESCRIPTION
       Select-Subscription
    .EXAMPLE
       Select-Subscription   
    .EXAMPLE
       Select-Subscription  | out-null          
    .EXAMPLE
       Select-Subscription -subscriptionnames $((Get-AzureRMSubscription).name)
    .EXAMPLE
       Select-Subscription -subscriptionnames $((Get-AzureRMSubscription).name | where {$_ -like "*blabla*"}) 
    .NOTES
       Script created by Mark vd Waarsenburg 15-12-2017
    #>
    
    param(
        $subscriptionnames = (Get-AzureRMSubscription).name 
    )

    Begin{}

    Process {

        If($subscriptionnames.count -gt 1){
            $i = 0
            Write-host "#####################################################################" -for cyan
            Write-host "# Select Subscription                                               #" -for White
            Write-host "#####################################################################" -for cyan

                foreach($_ in $subscriptionnames){
                    Write-host " $i = $($subscriptionnames[$i])"
                    $i++
                }

            Write-host "--------------------------------------------------------------------" -for cyan

            $SelectedSubscription  = $subscriptionnames[$(Read-host " Select Subscription number")]
            $connectedSubScription = Select-AzureRMSubscription -SubscriptionName $SelectedSubscription
        
            Write-host ""
            Write-host " Connected to $($connectedSubScription.Subscription.Name)" -for Green
        }
    }

    end{
        return $connectedSubScription 
    }

} #end Function