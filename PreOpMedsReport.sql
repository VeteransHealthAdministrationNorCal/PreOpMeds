--Column 1, Allowed Drugs
SELECT TOP 100
  patient.PatientSSN,
  patient.PatientFirstName,
  patient.PatientLastName,
  localDrug.LocalDrugNameWithDose,
  localDrug.DrugClass,
  outpat.RxStatus
FROM
  LSV.RxOut.RxOutpat AS outpat
  INNER JOIN LSV.SPatient.SPatient AS patient
    ON patient.Sta3n = outpat.Sta3n
	AND outpat.PatientSID = patient.PatientSID
  INNER JOIN LSV.dim.LocalDrug AS localDrug
    ON localDrug.LocalDrugSID = outpat.localDrugSID
	AND localDrug.Sta3n = outpat.Sta3n
WHERE
  outpat.Sta3n = '612'
  AND outpat.RxStatus ='ACTIVE'
  AND localDrug.DrugClass IN
    ('CV703','CV150','CV300','CV200','CV100','CV350','CV490','CV050') 
  AND patient.PatientSSN  = @SSN
ORDER BY
  Patient.PatientSSN

--Column 2, Forbidden Drugs
SELECT TOP 100
  patient.PatientSSN,
  patient.PatientFirstName,
  patient.PatientLastName,
  localDrug.LocalDrugNameWithDose,
  localDrug.DrugClass,
  outpat.RxStatus
FROM
  LSV.RxOut.RxOutpat AS outpat
  INNER JOIN LSV.SPatient.SPatient AS patient
    ON patient.Sta3n = outpat.Sta3n
	AND outpat.PatientSID = patient.PatientSID
  INNER JOIN LSV.dim.LocalDrug AS localDrug
    ON localDrug.LocalDrugSID = outpat.localDrugSID
	AND localDrug.Sta3n = outpat.Sta3n
WHERE
  outpat.Sta3n = '612'
  AND outpat.RxStatus ='ACTIVE'
  AND localDrug.DrugClass IN
    ('CV490','CV400','CV805','CV800','CV704','CV701','CV702','CV703') 
  AND patient.PatientSSN  = @SSN
ORDER BY
  Patient.PatientSSN