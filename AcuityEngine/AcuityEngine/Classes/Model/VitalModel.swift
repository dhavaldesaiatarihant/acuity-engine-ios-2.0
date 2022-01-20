//
//  VitalModel.swift
//  AcuityEngine
//
//  Created by Bhoomi Jagani on 09/03/21.
//

import Foundation
import HealthKit

class VitalModel
{
    
    var name: VitalsName!
    var healthQuantityType: HKQuantityTypeIdentifier?
    var healthCategoryType: HKCategoryTypeIdentifier?
    
    init(name:VitalsName) {
        self.name = name
        getObjectType(name: self.name)
    }
    
    func getObjectType(name:VitalsName){
        
        switch name {
        case .heartRate: do {
            healthQuantityType =  .heartRate
        }
        case .highHeartRate: do {
            healthCategoryType = .highHeartRateEvent
        }
        case .bloodPressure: do {
            healthQuantityType = .bloodPressureSystolic
        }
        case .bloodPressureSystolic: do {
            healthQuantityType = .bloodPressureSystolic
        }
        case .bloodPressureDiastolic: do {
            healthQuantityType = .bloodPressureDiastolic
        }
        case .lowHeartRate: do {
            healthCategoryType = .lowHeartRateEvent
        }
        case .vo2Max: do {
            healthQuantityType = .vo2Max
        }
        case .irregularRhymesNotification: do {
            healthCategoryType = .irregularHeartRhythmEvent
        }
        case .peakflowRate:
            healthQuantityType = .peakExpiratoryFlowRate
            
            
        case .InhalerUsage:
            healthQuantityType = .inhalerUsage
            
        case .temperature:
            healthQuantityType = .bodyTemperature
            
        case .BMI:
            healthQuantityType = .bodyMassIndex
            
        case .bloodSugar:
            healthQuantityType = .bloodGlucose
            
        case .weight:
            healthQuantityType = .bodyMass
        case .oxygenSaturation:
            healthQuantityType = .oxygenSaturation
        case .respiratoryRate:
            healthQuantityType = .respiratoryRate
        case .stepLength:
            if #available(iOS 14.0, *) {
                healthQuantityType = .walkingStepLength
            } else {
                // Fallback on earlier versions
                break
            }
        case .headPhoneAudioLevel:
            healthQuantityType = .headphoneAudioExposure
        case .steps:
            healthQuantityType = .stepCount
        case .waterIntake:
            healthQuantityType = .dietaryWater
        case .sleep:
            healthCategoryType = .sleepAnalysis
        default:
            break
        }
        
    }
}


enum VitalsName:String {
    //Use in Algoritham...
    case age = "Age"
    case heartRate = "Heart Rate"
    case bloodPressureSystolic = "Blood Pressure Systolic"
    case bloodPressureDiastolic = "Blood Pressure Diastolic"
    case vo2Max = "VO2 Max"
    case irregularRhymesNotification = "Irregular Rhymes Notification"
    case respiratoryRate = "Respiratory Rate (breaths/min)"
    case peakflowRate = "Peak Flow Rate(L/min)"
    case temperature = "Temperature"
    case BMI = "BMI"
    case bloodSugar = "Blood Sugar"
    case oxygenSaturation = "Oxygen Saturation"
    case headPhoneAudioLevel = "Headphone Audio Levels"
    case steps = "Steps"
    case sleep = "Sleep"
    case waterIntake = "Water Intake"
    //In display
    case bloodPressure = "Blood Pressure"
    case bloodPressureSystolicDiastolic = "BP Systolic/Diastolic"
    //In Add section
    case weight = "Weight"
    //Not in use
    case highHeartRate = "High Heart Rate"
    case lowHeartRate = "Low Heart Rate"
    case InhalerUsage = "Inhaler Usage (times/day)"
    case stepLength = "Step Length"
}

