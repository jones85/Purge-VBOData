# Purge-VBOData
### SYNOPSIS
To remove backup data from the VBO repository, there are a number of in-built PowerShell Cmdlets needed and can only process one entity at 
a time.  This function combines all those Cmdlets and removes the data in a simplified Cmdlet.  This fuction can also release the license 
from the entity as well.
### EXAMPLE
PS>Purge-VBOData -User Room -Repository PRD-BR-VRS-P-5 -Unlicense $true 
This example will remove all backups for all users with the word 'Room' in their name.  Once complete, it release any associated license to those users.  
### PARAMATER User (String)
A word used to filter all entities protected by the VBO server.
### PARAMATER Repository (String)
Defines the repository to search
### PARAMATER Unlicense (Boolean)
Specifies if to remove any associated licenses.
