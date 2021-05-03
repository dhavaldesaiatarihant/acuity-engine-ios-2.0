//
//  RenalManager.swift
//  HealthKitDemo
//
//  Created by  Bhoomi Jagani  on 03/02/21.
//


import Foundation
import HealthKit
import HealthKitReporter

class RenalManager: NSObject {
    
    
    static let sharedManager = RenalManager()
    
    //Initialize  data...
    var renalData = RenalData()
    
    override init() {
        //super.init()
        
    }
    //Reset Renal Data
    func resetRenalData(){
        renalData = RenalData()
    }
    
    //Save Vitals Data in renalVital Model
    func saveQuantityInArray(quantityType:QuantityType,element:Quantity) {
        
        if quantityType == QuantityType.bloodPressureSystolic {
            
            let systolicBP = RenalVitalsData(type: VitalsName.bloodPressureSystolic)
            systolicBP.value = Double(element.harmonized.value)
            systolicBP.startTimeStamp = element.startTimestamp
            self.renalData.renalVital.systolicBloodPressureData.append(systolicBP)
            
            print("---------\n bloodPressureSystolic \nValue \(systolicBP.value)\n Score \(systolicBP.score)\n Max Score\(systolicBP.maxScore ?? 0.0) \n---------")
        }
        else if quantityType == QuantityType.bloodPressureDiastolic {
            
            let diastolicBP = RenalVitalsData(type: VitalsName.bloodPressureDiastolic)
            diastolicBP.value = Double(element.harmonized.value)
            diastolicBP.startTimeStamp = element.startTimestamp
            self.renalData.renalVital.diastolicBloodPressureData.append(diastolicBP)
            
        }
        
    }
    
    
    //Save Symptoms data in renalData model
    func saveSymptomsData(category:CategoryType,element:CategoryData){
        
        let symptomsData = RenalSymptomsPainData(type: category)
        symptomsData.value = Double(element.harmonized.value)
        symptomsData.startTimeStamp = element.startTimestamp
        symptomsData.endTimeStamp = element.endTimestamp
        
        switch category {
        case .rapidPoundingOrFlutteringHeartbeat:
            RenalManager.sharedManager.renalData.renalSymptoms.rapidHeartBeatData.append(symptomsData)
        case .lowerBackPain:
            RenalManager.sharedManager.renalData.renalSymptoms.lowerBackPainData.append(symptomsData)
        case .dizziness:
            RenalManager.sharedManager.renalData.renalSymptoms.dizzinessData.append(symptomsData)
        case .fainting:
            RenalManager.sharedManager.renalData.renalSymptoms.faintingData.append(symptomsData)
        case .fatigue:
            RenalManager.sharedManager.renalData.renalSymptoms.fatigueData.append(symptomsData)
        case .nausea:
            RenalManager.sharedManager.renalData.renalSymptoms.nauseaData.append(symptomsData)
        case .vomiting:
            RenalManager.sharedManager.renalData.renalSymptoms.vomitingData.append(symptomsData)
        default:
            break
        }
        
        
    }
    
    //MARK: save condition data..
    func saveConditionsData(element:ConditionsModel){
        let conditionType = ConditionType(rawValue: element.title!)
        guard let conditionTypeData = conditionType else {
            return
        }
        let conditionData = RenalConditionData(type: conditionTypeData)
        conditionData.value = element.value.rawValue
        
        switch conditionType {
        case .kidneyDiease:
            RenalManager.sharedManager.renalData.renalCondition.kidneyDieaseData.append(conditionData)
        case .kidneyStones:
            RenalManager.sharedManager.renalData.renalCondition.kidneyStonesData.append(conditionData)
        case .hypertension:
            RenalManager.sharedManager.renalData.renalCondition.hypertensionData.append(conditionData)
        case .electrolyteDisorders:
            RenalManager.sharedManager.renalData.renalCondition.electrolyteDisordersData.append(conditionData)
        case .underweightOrMalnutrition:
            RenalManager.sharedManager.renalData.renalCondition.underweightMalnutritionData.append(conditionData)
        case .diabetes:
            RenalManager.sharedManager.renalData.renalCondition.diabetesData.append(conditionData)
        case .UTI:
            RenalManager.sharedManager.renalData.renalCondition.UTIData.append(conditionData)
            
        default:
            break
        }
    }
}

