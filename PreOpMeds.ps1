##### run ######
$MedData = Get-PatientMeds
Get-SimpleTextFiles($MedData)

Function Get-PatientMeds()
{
    $lhs = "select distinct top 100
    patient.PatientSSN,
    localDrug.LocalDrugNameWithDose
    from cdwwork.RxOut.RxOutpat as outpat
    inner join cdwwork.SPatient.SPatient as patient
           on patient.Sta3n = outpat.Sta3n and outpat.PatientSID = patient.PatientSID
    inner join cdwwork.dim.LocalDrug as localDrug
           on localDrug.LocalDrugSID = outpat.localDrugSID and localDrug.Sta3n = outpat.Sta3n
    where outpat.Sta3n = '612'
    and outpat.RxStatus ='ACTIVE'"

    $ssns = Get-Content C:\PreOpMeds\PatientSSN.txt
    $insert = 'and patient.PatientSSN  in ('+$ssns+')' 
    $rhs = "order by patient.PatientSSN"
    $QueryString  =$lhs+$insert+$rhs
    $ServerInstance = "vhacdwa01.vha.med.va.gov"
    $Database ="CDWWork"
    $data = (Invoke-Sqlcmd -QueryTimeout 30 -ServerInstance $ServerInstance  -Database $Database  -Query $QueryString)
    return $data
}
Function Get-SimpleTextFiles($data)
{
$uniq = $data.PatientSSN | select -Unique
foreach ($u in $uniq)
    {
    $udata = $data | Where-Object {$_.PatientSSN -eq $u}
    $fname = ($udata | Select-Object PatientSSN | select -Unique)
    New-Item -Name $fname -Path C:\PreOpMeds\ -ItemType file
    Add-Content -Path C:\PreOpMeds\$fname -Value $udata | Select-Object LocalDrugNameWithDose
    }
}

#Function Get-SimpleTextFiles($data)
#{
#$uniq = $data.PatientSSN | select -Unique
#foreach ($u in $uniq)
#    {
#    $udata = $data | Where-Object {$_.PatientSSN -eq $u}
#    $fname = ($udata | Select-Object PatientSSN | select -Unique)
#    New-Item -Name $fname -Path C:\PreOpMeds\ -ItemType file
#    Add-Content -Path C:\PreOpMeds\$fname -Value $udata | Select-Object -Name LocalDrugNameWithDose
#    }
#}