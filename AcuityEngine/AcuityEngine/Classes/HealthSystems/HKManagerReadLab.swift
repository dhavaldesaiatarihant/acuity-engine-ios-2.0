//
//  HKManagerReadSymptoms.swift
//  AcuityEngine
//
//  Created by Bhoomi Jagani on 23/03/21.
//

import Foundation
import HealthKit
import HealthKitReporter

class HKManagerReadLab: NSObject
{
    static let sharedManager = HKManagerReadLab()
    private var reporter: HealthKitReporter?
    
    override init() {
        super.init()
        
    }
    
    func readLabDataTemp(completion: @escaping (Bool, HealthkitSetupError?) -> Swift.Void){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        HKSetupAssistance.authorizeLabDataKit { (samples, success, error) in
            
            if(success){
                
                print("samples------>\(samples)")
                for sample in samples{
                    guard let clinicalRecord = sample as? HKClinicalRecord, let fhirResource = clinicalRecord.fhirResource else {
                        return
                    }
                    do {
                        let sourceObject = try JSONSerialization.jsonObject(with: fhirResource.data, options: [])
                        let prettyPrintedSourceData = try JSONSerialization.data(withJSONObject: sourceObject, options: [.prettyPrinted])
                        
                        let sourceString = String(data: prettyPrintedSourceData, encoding: .utf8) ?? "Unable to display FHIR source."
                        
                        print(unescapeJSONString(sourceString))
                        if let dictionary = sourceObject as? [String: AnyObject] {
                            let valueQuantity = dictionary["valueQuantity"] as? [String: AnyObject]
                            let code = dictionary["code"] as? [String: AnyObject]
                            if let value = (valueQuantity?["value"] as? Double)  ,let codeKey = (code?["text"])  {
                                // access individual value in dictionary
                                print("\(codeKey)----->\(value)")
                                
                            }
                        }
                        
                    } catch {
                        dispatchGroup.leave()
                        completion(false, HealthkitSetupError.dataParsingError)
                    }
                  
                }
                dispatchGroup.leave()
                dispatchGroup.notify(queue: .main) {
                    
                    DispatchQueue.main.async {
                        completion(success, nil)
                    }
                }
              
            }else{
                dispatchGroup.leave()
                completion(success, error)
            }
        }
        print("lab result error")
    }
    
    
}
