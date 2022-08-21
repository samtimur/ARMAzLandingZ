<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
July 13, 2021 1.0    
    - Initial script

  .DESCRIPTION
    This script requires the correct module to be installed first

    "For the current user" To install PSDocs for Azure for the current user use
    * Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope CurrentUser

    To update PSDocs for Azure for the current user use
    * Update-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope CurrentUser

    "For all users" To install PSDocs for Azure for all users (requires admin/ root permissions) use
    * Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope AllUsers

    To update PSDocs for Azure for all users (requires admin/ root permissions) use:
    * Update-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope AllUsers

#>

# Import module
Import-Module PSDocs.Azure;

# Scan for Azure template file recursively in the templates/ directory
Get-AzDocTemplateFile -Path managementGroupTemplates/ | ForEach-Object {
    # Generate a standard name of the markdown file. i.e. <name>_<version>.md
    $template = Get-Item -Path $_.TemplateFile;
    $templateName = $template.Directory.Parent.Name;
    $version = $template.Directory.Name;
    $docName = "$($templateName)_$version";

    # Generate markdown
    Invoke-PSDocument -Module PSDocs.Azure -OutputPath documentation -InputObject $template.FullName -InstanceName $docName;
}