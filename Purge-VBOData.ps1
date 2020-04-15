function Purge-VBOData {
    <#
    .SYNOPSIS
        
        To remove backup data from the VBO repository, there are a number of in-built PowerShell Cmdlets needed and can only process one entity at a time.  This function 
        combines all those Cmdlets and removes the data in a simplified Cmdlet.  This fuction can also release the license from the entity as well.

    .EXAMPLE
        
        PS>Purge-VBOData -User Room -Repository PRD-BR-VRS-P-5 -Unlicense $true 

        This example will remove all backups for all users with the word 'Room' in their name.  Once complete, it release any associated license to those users.  
        
    .PARAMATER User (String)
        
        A word used to filter all entities protected by the VBO server.
                 
    .PARAMATER Repository (String)
        
        Defines the repository to search

    .PARAMATER Unlicense (Boolean)
        
        Specifies if to remove any associated licenses.
        
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory)]
        [string]$User,
        [Parameter(Mandatory)]
        [string]$Repository,
        [Parameter()]
        [Boolean]$Unlicense = $false
    )
    process 
        {
        try {
                $alldata = @()
                $alllicenses = @()

                $org = Get-VBOOrganization -Name "foods365.onmicrosoft.com"
                $repo = Get-VBORepository -Name $repository
                $Entities = Get-VBOEntityData -Type User -Repository $repo -Name *$User*

                Foreach ($Entity in $Entities) {

                    $alldata += Get-VBOEntityData -Type User -Repository $repo -Name $Entity.DisplayName
                    $alllicenses += Get-VBOLicensedUser -Organization $org -Name $Entity.Email
                }

                Foreach ($data in $alldata){
                    Remove-VBOEntityData -Repository $repo -User $data -Mailbox -ArchiveMailbox -OneDrive -Sites -Verbose -Confirm:$false
                }

                if($unlicense -eq $true){
                    Foreach ($license in $alllicenses) {
                        Remove-VBOLicensedUser -User $license -Verbose
                    }
                
                }
                Else {
                    break
                }
         
        } 
            catch {
               Write-Error "$($_.Exception.Message) -Line Number: $($_.InvocationInfo.ScriptLineNumber)"
            }
        }
    }
# EOF
