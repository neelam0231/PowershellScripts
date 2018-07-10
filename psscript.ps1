# Installling & Importing Sql Server Modules
Install-Module SqlServer -Scope CurrentUser
Install-Module AzureRM -Scope CurrentUser
Import-Module SqlServer
Import-Module AzureRM
# Parameters to connect Azure SQl Datavbase
$DbServer = 'neelamdbserver.database.windows.net'
$db1 = 'auth'
$username = 'hneelam'
$pwd = 'inno@123'
###########Adding Contracting Entities to Auth Database
# Using $MyQuery1 to search BilliansId value in ContractingEntity Table.
$MyQuery1 = "SELECT TOP (1000) ContractingEntityCwid, Name, CeAdminCount HasVestaCare, BilliansID
             FROM $db1.dbo.ContactingEntity 
             WHERE BilliansId like 'CwDemoBillians1'"

#Uisng $MyQuesry2 to create new ContractingEntity Table if it is not exist in auth databese.             

$MyQuery2 = "CREATE TABLE $db1.dbo.ContractingEntity (
	ContractingEntityCwid NVARCHAR(25) NULL,
	Name NVARCHAR(25) NULL,
	CeAdminCount NVARCHAR(25) NULL,
	HasVestCare NVARCHAR(25) NULL,
	BilliansId NVARCHAR(25) NULL
);"

$SearchBilliansID = Invoke-Sqlcmd -Query $MyQuery1 -ServerInstance $DbServer -Database $db1 -Username $username -Password $pwd
$CreateContactingEntity = Invoke-Sqlcmd -Query $MyQuery2 -ServerInstance $DbServer -Database $db1 -Username $username -Password $pwd
$InsertingData = "INSERT INTO $db1.dbo.ContractingEntity (BilliansId) VALUES ('CwDemoBillians1')"

if ($SearchBilliansID)
 {
    Print 'Value of BilliansId is available'
}
else 
{ 
    Print " creating a new CantractingEntity "
    $CreateContactingEntity
    Invoke-Sqlcmd -Query $InsertingData -ServerInstance $DbServer -Database $db1 -Username $username -Password $pwd
}

# Add Facilities To Auth Database

$Facilities1 = "SELECT TOP (1000) Name, ContractingEntityCwid, NumberOfFacilityAdmin, BilliansID, FacilityCwId
             FROM $db1.dbo.Facilities 
             WHERE ContractingEntityCwID = 1"
$SearchCwid = Invoke-Sqlcmd -Query $Facilities1 -ServerInstance $DbServer -Database $db1 -Username $username -Password $pwd
$NewFacilities = "CREATE TABLE $db1.dbo.Facilities ( 
    Name NVARCHAR(255) NULL, 
    ContractingEntityCwId INT NULL, 
    NumberOfFacilityAdmins INT NULL, 
    BilliansId NVARCHAR(50) NULL, 
    FacilityCwId INT NULL);"
$InsertDataInFacilities = "INSERT INTO $db1.dbo.Facilities (Name, ContractingEntityCwId, NumberOfFacilityAdmins, BilliansId, FacilityCwId) 
VALUES ('Demo',754,0,'SP9988',3007),('Demo2',755,10,'SP0088',3997)"

if ($SearchCwid){
    Print "Value of CwID is available"
}
else {
    Print "Creating New Facilities table in Auth Database"
    Invoke-Sqlcmd -Query $NewFacilities -ServerInstance $DbServer -Database $db1 -Username $username -Password $pwd
    Invoke-Sqlcmd -Query $InsertDataInFacilities -ServerInstance $DbServer -Database $db1 -Username $username -Password $pwd
}

