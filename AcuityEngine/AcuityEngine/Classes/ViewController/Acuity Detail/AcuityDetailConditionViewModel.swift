//
//  AcuityDetailConditionViewModel.swift
//  AcuityEngine
//
//  Created by Bhoomi Jagani on 10/03/21.
//

import Foundation

class AcuityDetailConditionViewModel: NSObject
{
    
    //MARK: Default system data...
    
    func getConditionData()->[ConditionsModel] {
        var arrConditions:[ConditionsModel] = []
        
        let Condition1 =  ConditionsModel(title: "Hypertension", value: .No)
        let Condition2 =  ConditionsModel(title: "Arrhythmia", value: .Yes)
        let Condition3 =  ConditionsModel(title: "Congestive Heart Failure", value: .No)
        let Condition4 =  ConditionsModel(title: "Coronary Artery Disease", value: .No)
        arrConditions = [Condition1,Condition2,Condition3,Condition4]
        return arrConditions
    }
    
    func getLabData()->[LabModel] {
        var arrLabs:[LabModel] = []
        
        let lab1 =  LabModel(title: "Potassium Level", value: "3.3")
        lab1.color = ChartColor.REDCOLOR
        let lab2 =  LabModel(title: "Magnesium Level", value: "2")
        lab2.color = ChartColor.GREENCOLOR
        let lab3 =  LabModel(title: "Blood oxygen level", value: "97%")
        lab3.color = ChartColor.GREENCOLOR
        let lab4 =  LabModel(title: "B-peptide", value: "0")
        lab4.color = ChartColor.GREENCOLOR
        let lab5 =  LabModel(title: "Troponin Level", value: "0.03")
        lab5.color = ChartColor.GREENCOLOR
        let lab6 =  LabModel(title: "Hemoglobin", value: "17.6")
        lab6.color = ChartColor.REDCOLOR
        arrLabs = [lab1,lab2,lab3,lab4,lab5,lab6]
        
        return arrLabs
    }
    
    func getSymptomsData()->[SymptomsModel] {
        //Cardiovascular
        if MyWellScore.sharedManager.selectedSystem == SystemName.Cardiovascular{
            return CardioManager.sharedManager.cardioData.cardioSymptoms.dictionaryRepresentation()
        }
        //Respiratory
        else if MyWellScore.sharedManager.selectedSystem == SystemName.Respiratory{
            return RespiratoryManager.sharedManager.respiratoryData.respiratorySymptoms.dictionaryRepresentation()
        }
        //Renal
        else if MyWellScore.sharedManager.selectedSystem == SystemName.Renal{
            return RenalManager.sharedManager.renalData.renalSymptoms.dictionaryRepresentation()
        }
        //InfectiousDisease
        else if MyWellScore.sharedManager.selectedSystem == SystemName.InfectiousDisease{
            return IDiseaseManager.sharedManager.iDiseaseData.iDiseaseSymptoms.dictionaryRepresentation()
        }
        //FNE
        else if MyWellScore.sharedManager.selectedSystem == SystemName.Fluids{
            return FNEManager.sharedManager.fneData.fneSymptoms.dictionaryRepresentation()
        }
        return []
    }
    
    func getVitals()->[VitalsModel] {
        //Cardiovascular
        if MyWellScore.sharedManager.selectedSystem == SystemName.Cardiovascular{
            return CardioManager.sharedManager.cardioData.cardioVital.dictionaryRepresentation()
        }
        //Respiratory
        else if MyWellScore.sharedManager.selectedSystem == SystemName.Respiratory{
            return RespiratoryManager.sharedManager.respiratoryData.respiratoryVital.dictionaryRepresentation()
        }
        //Renal
        else if MyWellScore.sharedManager.selectedSystem == SystemName.Renal{
            return RenalManager.sharedManager.renalData.renalVital.dictionaryRepresentation()
        }
        //InfectiousDisease
        else if MyWellScore.sharedManager.selectedSystem == SystemName.InfectiousDisease{
            return IDiseaseManager.sharedManager.iDiseaseData.iDiseaseVital.dictionaryRepresentation()
        }
        //FNE
        else if MyWellScore.sharedManager.selectedSystem == SystemName.Fluids{
            return FNEManager.sharedManager.fneData.fneVital.dictionaryRepresentation()
        }
        return []
    }
}
