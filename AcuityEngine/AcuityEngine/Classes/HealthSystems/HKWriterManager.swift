//
//  HKWriterManager.swift
//  AcuityEngine
//
//  Created by Bhoomi Jagani on 15/03/21.
//

import Foundation
import HealthKit
import UserNotifications
//@available(iOS 14.0, *)
class HKWriterManager {
    
    
    func saveQuantityData(value: Double,quantityTypeIdentifier:HKQuantityTypeIdentifier?,
                          date: Date,
                          completion: @escaping (Error?) -> Swift.Void) {
        
        guard let quantityTypeIdentifier = quantityTypeIdentifier else {
            fatalError("No identifier found")
        }
        
        let unit:HKUnit = HKUnit.count()
        var quantity = HKQuantity(unit: unit,
                                  doubleValue: value)
        //Heart Rate
        if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.heartRate.rawValue
        {
            quantity = saveHeartRate(value:value)
        }
        //Respiratory Rate
        else if  quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.respiratoryRate.rawValue{
            
            quantity = saveRespiratoryRate(value: value)
        }
        //peakExpiratoryFlowRate
        else if  quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.peakExpiratoryFlowRate.rawValue{
            
            quantity = savepeakExpiratoryFlowRate(value: value)
        }
        //bodyTemperature
        else if  quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.bodyTemperature.rawValue{
            quantity = saveBodyTemperature(value: value)
            
        }
        //bloodGlucose
        else if  quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.bloodGlucose.rawValue{
            quantity = saveBloodGlucose(value: value)
        }
        //oxygenSaturation
        else if  quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.oxygenSaturation.rawValue{
            /*
             oxygenSaturation save in health kit in range 0 - 1. so, when patient enter value > 1 convert it to 0-1 range.
             */
            var newValue = value
            if value > 1{
                newValue = value/100
            }
            quantity = saveOxygenSaturation(value: newValue)
        }
        //inhalerUsage
        else if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.inhalerUsage.rawValue
        {
            quantity = saveInhalerUsage(value: value)
        }
        //vo2Max
        else if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.vo2Max.rawValue
        {
            quantity = saveVO2Max(value: value)
        }
        //bodyMassIndex
        else if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.bodyMassIndex.rawValue
        {
            quantity = saveBodyMassIndex(value: value)
        }
        //bodyMass
        else if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.bodyMass.rawValue
        {
            quantity = saveBodyMass(value: value)
        }
        //stepCount
        else if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.stepCount.rawValue
        {
            quantity = saveStepCount(value: value)
        }
        //dietaryWater
        else if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.dietaryWater.rawValue
        {
            quantity = saveWaterIntake(value: value)
        }
        //step length
        if #available(iOS 14.0, *) {
            if quantityTypeIdentifier.rawValue == HKQuantityTypeIdentifier.walkingStepLength.rawValue
            {
                quantity = saveStepLength(value: value)
            }
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier) else { return  }
        let sample = HKQuantitySample(type: quantityType,
                                      quantity: quantity,
                                      start: date,
                                      end: date)
        
        
        HKSetupAssistance.healthKitStore.save(sample) { (success, error) in
            
            if let error = error {
                completion(error)
                print("Error Saving Sample \(quantityTypeIdentifier): \(error.localizedDescription)")
            } else {
                completion(nil)
                Log.d("Successfully saved \(quantityTypeIdentifier) Sample")
            }
        }
        
    }
    
    func saveHeartRate(value:Double)->HKQuantity{
        let unit:HKUnit = HKUnit.count()
        let quantity = HKQuantity(unit: unit.unitDivided(by: HKUnit.minute()), doubleValue: Double(value))
        return quantity
    }
    func savepeakExpiratoryFlowRate(value:Double)->HKQuantity{
        let unit:HKUnit  = HKUnit.liter()
        let quantity = HKQuantity(unit: unit.unitDivided(by: HKUnit.minute()), doubleValue: Double(value))
        return quantity
    }
    func saveBodyTemperature(value:Double)->HKQuantity{
        let unit = HKUnit(from: "degF")
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func saveBloodGlucose(value:Double)->HKQuantity{
        let unit = HKUnit(from: "mg/dl")
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func saveOxygenSaturation(value:Double)->HKQuantity{
        let unit = HKUnit.percent()
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func saveInhalerUsage(value:Double)->HKQuantity{
        let unit:HKUnit = HKUnit.count()
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func saveRespiratoryRate(value:Double)->HKQuantity{
        let unit:HKUnit = HKUnit.count()
        let quantity = HKQuantity(unit: unit.unitDivided(by: HKUnit.minute()), doubleValue: Double(value))
        return quantity
    }
    func saveVO2Max(value:Double)->HKQuantity{
        let kgmin = HKUnit.gramUnit(with: .kilo).unitMultiplied(by: .minute())
        let mL = HKUnit.literUnit(with: .milli)
        let VO₂Unit = mL.unitDivided(by: kgmin)
        let quantity = HKQuantity(unit: VO₂Unit, doubleValue: Double(value))
        return quantity
    }
    func saveBodyMass(value:Double)->HKQuantity{
        let unit:HKUnit = HKUnit.gramUnit(with: HKMetricPrefix.kilo)
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func saveBodyMassIndex(value:Double)->HKQuantity{
        //        let kilounit:HKUnit = HKUnit.gramUnit(with: .kilo)
        //        let m2 = HKUnit.meter().unitMultiplied(by: HKUnit.meter())
        //        let BMIUnit = kilounit.unitDivided(by: m2)
        let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(value))
        return quantity
    }
    func saveStepLength(value:Double)->HKQuantity{
        let unit:HKUnit = HKUnit.inch()
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func saveStepCount(value:Double)->HKQuantity{
        let unit:HKUnit = HKUnit.count()
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func saveWaterIntake(value:Double)->HKQuantity{
        let unit:HKUnit = HKUnit.literUnit(with: HKMetricPrefix.milli)
        let quantity = HKQuantity(unit: unit, doubleValue: Double(value))
        return quantity
    }
    func storeBloodPressure(systolic:Double,diastolic:Double,date: Date,
                            completion: @escaping (Error?) -> Swift.Void){
        let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let systolicQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: Double(systolic))
        let systolicSample = HKQuantitySample(type: systolicType, quantity: systolicQuantity, start: date, end: date)
        let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        let diastolicQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: Double(diastolic))
        let diastolicSample = HKQuantitySample(type: diastolicType, quantity: diastolicQuantity, start: date, end: date)
        // 3
        let bpCorrelationType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!
        let bpCorrelation = Set<HKSample>(arrayLiteral: systolicSample, diastolicSample)
        let bloodPressureSample = HKCorrelation(type: bpCorrelationType , start: date, end: date, objects: bpCorrelation)
        // 4 save
        
        HKSetupAssistance.healthKitStore.save(bloodPressureSample) { (success, error) in
            
            if let error = error {
                completion(error)
                print("Error Saving Sample \(diastolicType.identifier): \(error.localizedDescription)")
            } else {
                completion(nil)
                Log.d("Successfully saved \(diastolicType.identifier) Sample")
            }
        }
    }
    
    func saveSleepData(categoryValue: Int,caegoryTypeIdentifier:HKCategoryTypeIdentifier?,
                          startdate: Date,endDate: Date,
                          completion: @escaping (Error?) -> Swift.Void) {
        
        guard let caegoryTypeIdentifier = caegoryTypeIdentifier else {
            fatalError("No identifier found")
        }
        
        //Category Type
        guard let categoryType = HKObjectType.categoryType(forIdentifier: caegoryTypeIdentifier) else { return  }
       
        //Create sample for Category
        let sample = HKCategorySample(type: categoryType, value: categoryValue, start: startdate, end: endDate)
        
        HKSetupAssistance.healthKitStore.save(sample) { (success, error) in
            
            if let error = error {
                completion(error)
                print("Error Saving Sample \(caegoryTypeIdentifier): \(error.localizedDescription)")
            } else {
                completion(nil)
                Log.d("Successfully saved \(caegoryTypeIdentifier) Sample")
            }
        }
        
    }
}

extension HKWriterManager{
    func saveSymptomsData(categoryValue: SymptomsTextValue,caegoryTypeIdentifier:HKCategoryTypeIdentifier?,
                          startdate: Date,endDate: Date,
                          completion: @escaping (Error?) -> Swift.Void) {
        
        guard let caegoryTypeIdentifier = caegoryTypeIdentifier else {
            fatalError("No identifier found")
        }
        
        //Category Type
        guard let categoryType = HKObjectType.categoryType(forIdentifier: caegoryTypeIdentifier) else { return  }
        //Value for Category
        let value = getSymptomsValue(value: categoryValue)
        //Set Notification...
        if categoryValue != SymptomsTextValue.Not_Present{
            setNotificationForSymptoms()
        }
        //Create sample for Category
        let sample = HKCategorySample(type: categoryType, value: value, start: startdate, end: endDate)
        
        HKSetupAssistance.healthKitStore.save(sample) { (success, error) in
            
            if let error = error {
                completion(error)
                print("Error Saving Sample \(caegoryTypeIdentifier): \(error.localizedDescription)")
            } else {
                completion(nil)
                Log.d("Successfully saved \(caegoryTypeIdentifier) Sample")
            }
        }
        
    }
    private func setNotificationForSymptoms(){
      
        DispatchQueue.main.async{
            if Utility.fetchBool(forKey: Key.kIsNotificationOnOff) && AppDelegate.shared.isLocalNotificationGranted {
                UNUserNotificationCenter.current().removePendingNotificationRequests( withIdentifiers: [Key.kIsSymptomseminder])
                //
                //                //Prepare Notification Model...
                //                var dayComponent    = DateComponents()
                //                dayComponent.day    = NUMBER_OF_DAYS_FOR_APP_SYMPTOMS // For removing one day (yesterday): -1
                //                let theCalendar     = Calendar.current
                //                let newDate        = theCalendar.date(byAdding: dayComponent, to: Date())
                //
                let notificationModel = NotificationModel(title: AlertMessages.SYMPTOMS_NOTIFICATION_TITLE, body: AlertMessages.SYMPTOMS_NOTIFICATION_MESSAGE, numberOfDays: NUMBER_OF_DAYS_FOR_APP_SYMPTOMS, identifier: Key.kIsSymptomseminder, isRepeat: true)
                if notificationModel.numberOfDays ?? 0 > 0{
                    NotificationManager.shared.setNotificationForSymptoms(model: notificationModel)
                }
            }
        }
    }
    private func getSymptomsValue(value:SymptomsTextValue) -> Int {
        
        switch value {
        case SymptomsTextValue.Present:
            return 0
        case SymptomsTextValue.Not_Present:
            return 1
        case SymptomsTextValue.Mild:
            return 2
        case SymptomsTextValue.Moderate:
            return 3
        case SymptomsTextValue.Severe:
            return 4
            
        }
    }
}
