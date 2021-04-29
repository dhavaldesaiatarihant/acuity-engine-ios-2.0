//
//  EndocrineSymptoms.swift
//  HealthKitDemo
//
//  Created by Paresh Patel on 05/02/21.
//

import UIKit

class EndocrineSymptoms:SymptomsProtocol {
    /*
     dizziness
     fatigue
     Rapid or fluttering heartbeat
     hot flashes
     fainting
     Hair loss
     nausea
     vomiting
     Dry Skin
     */
    var dizzinessData:[EndocrineSymptomsPainData] = []
    var fatigueData:[EndocrineSymptomsPainData] = []
    var rapidHeartBeatData:[EndocrineSymptomsPainData] = []
    
    var hotFlashesData:[EndocrineSymptomsPainData] = []
    var faintingData:[EndocrineSymptomsPainData] = []
    var hairLossData:[EndocrineSymptomsPainData] = []
    
    var nauseaData:[EndocrineSymptomsPainData] = []
    var vomitingData:[EndocrineSymptomsPainData] = []
    var drySkinData:[EndocrineSymptomsPainData] = []
    
    var arrayDayWiseScoreTotal:[Double] = []
    
    func totalSymptomDataScore() -> Double {
        return 0
    }
    
    func getMaxSymptomDataScore() -> Double {
        let dizziness = EndocrineSymptomsRelativeImportance.dizziness.getConvertedValueFromPercentage()
        let fatigue = EndocrineSymptomsRelativeImportance.fatigue.getConvertedValueFromPercentage()
        let rapidPoundingOrFlutteringHeartbeat = EndocrineSymptomsRelativeImportance.rapidPoundingOrFlutteringHeartbeat.getConvertedValueFromPercentage()
        
        let hotFlashes = EndocrineSymptomsRelativeImportance.hotFlashes.getConvertedValueFromPercentage()
        let fainting = EndocrineSymptomsRelativeImportance.fainting.getConvertedValueFromPercentage()
        let hairLoss = EndocrineSymptomsRelativeImportance.hairLoss.getConvertedValueFromPercentage()
        
        let nausea = EndocrineSymptomsRelativeImportance.nausea.getConvertedValueFromPercentage()
        let vomiting = EndocrineSymptomsRelativeImportance.vomiting.getConvertedValueFromPercentage()
        let drySkin = EndocrineSymptomsRelativeImportance.drySkin.getConvertedValueFromPercentage()
        
        let totalLabScore1 = fatigue + dizziness + rapidPoundingOrFlutteringHeartbeat
        let totalLabScore2 =  hotFlashes + fainting  + hairLoss
        let totalLabScore3 =  nausea + vomiting  + drySkin
        
        return Double(totalLabScore1  + totalLabScore2 + totalLabScore3);
    }
    
    func totalSymptomsScoreForDays(days:SegmentValueForGraph) -> [Double] {
        
        //print(totalAmount) // 4500.0
        arrayDayWiseScoreTotal = []
        
        var now = MyWellScore.sharedManager.todaysDate
        let getComponentAndLoop = getNumberOfTimesLoopToExecute(days: days)
        let component:Calendar.Component = getComponentAndLoop["component"] as! Calendar.Component
        let noOfTimesLoopExecute:Int = getComponentAndLoop["noOfTimesLoopExecute"] as! Int
        
        for _ in 0...noOfTimesLoopExecute-1{
            
            let day = Calendar.current.date(byAdding: component, value: -1, to: now)!
            
            let timeIntervalByLastMonth:Double = day.timeIntervalSince1970
            //print("timeIntervalByLastMonth",getDateMediumFormat(time:timeIntervalByLastMonth))
            let timeIntervalByNow:Double = now.timeIntervalSince1970
            //print("timeIntervalByNow",getDateMediumFormat(time:timeIntervalByNow))
            now = day
            
            //dizziness
            let scoredizziness = getScoreForSymptomsDataWithGivenDateRange(sampleItem: dizzinessData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            //fatigue
            let scoreFatigue = getScoreForSymptomsDataWithGivenDateRange(sampleItem: fatigueData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            //rapidHeartBeat
            let scoreRapidHeartBeat = getScoreForSymptomsDataWithGivenDateRange(sampleItem: rapidHeartBeatData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            
            //fainting
            let scorefainting = getScoreForSymptomsDataWithGivenDateRange(sampleItem: faintingData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            //hotFlashes
            let scoreHotFlashes = getScoreForSymptomsDataWithGivenDateRange(sampleItem: hotFlashesData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            //hairLossData
            let scoreHairloss = getScoreForSymptomsDataWithGivenDateRange(sampleItem: hairLossData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            
            //nausea
            let scorenausea = getScoreForSymptomsDataWithGivenDateRange(sampleItem: nauseaData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            //vomiting
            let scorevomiting = getScoreForSymptomsDataWithGivenDateRange(sampleItem: vomitingData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            //drySkin
            let scoreDrySkin = getScoreForSymptomsDataWithGivenDateRange(sampleItem: drySkinData, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            
            
            let totalScore1 = scoredizziness + scoreFatigue + scoreRapidHeartBeat
            let totalScore2 = scorefainting + scoreHotFlashes + scoreHairloss
            let totalScore3 = scorenausea + scorevomiting + scoreDrySkin
            
            arrayDayWiseScoreTotal.append(totalScore1 + totalScore2 + totalScore3)
        }
        
        return arrayDayWiseScoreTotal
    }
    
    func dictionaryRepresentation()->[SymptomsModel]{
        
        var arrSymptoms:[SymptomsModel] = []
        
        //dizziness
        if dizzinessData.count > 0{
            let symptom = dizzinessData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        //fatigue
        if fatigueData.count > 0{
            let symptom = fatigueData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        //rapidHeartBeat
        if rapidHeartBeatData.count > 0{
            let symptom = rapidHeartBeatData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        
        //hotFlashes
        if hotFlashesData.count > 0{
            let symptom = hotFlashesData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        //fainting
        if faintingData.count > 0{
            let symptom = faintingData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        //hairLoss
        if hairLossData.count > 0{
            let symptom = hairLossData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        
        //nausea
        if nauseaData.count > 0{
            let symptom = nauseaData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        //vomiting
        if vomitingData.count > 0{
            let symptom = vomitingData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        //drySkin
        if drySkinData.count > 0{
            let symptom = drySkinData[0]
            arrSymptoms.append(getSymptomsModel(symptom: symptom))
        }
        
        return arrSymptoms
    }
    func getSymptomsModel(symptom:EndocrineSymptomsPainData)->SymptomsModel{
        return SymptomsModel(title: symptom.title, value: symptom.getSymptomsValue())
    }
    
    func getArrayDataForSymptoms(days:SegmentValueForGraph,title:String)->[SymptomsModel]{
        var arrSymptoms:[SymptomsModel] = []
        let symptomsName = SymptomsName(rawValue: title)
        var filterArray:[SymptomCalculation] = []
        
        switch symptomsName {
        
        //dizziness
        case .dizziness:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: dizzinessData)
        //fatigue
        case .fatigue:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: fatigueData)
        //rapidHeartbeat
        case .rapidHeartbeat:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: rapidHeartBeatData)
            
        //hotFlashes
        case .hotFlashes:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: hotFlashesData)
        //fainting
        case .fainting:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: faintingData)
        //hairLoss
        case .hairLoss:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: hairLossData)
            
        //nausea
        case .nausea:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: nauseaData)
        //vomiting
        case .vomiting:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: vomitingData)
        //drySkin
        case .drySkin:
            filterArray = filterArrayWithSelectedSegmentInGraph(days: days, array: drySkinData)
            
            
        default:
            break
        }
        for item in filterArray{
            let hotFlashesValue = item.getSymptomsValue()
            let symptom1 =  SymptomsModel(title: title, value: hotFlashesValue)
            symptom1.startTime = item.startTimeStamp
            symptom1.endTime = item.endTimeStamp
            arrSymptoms.append(symptom1)
            
        }
        return arrSymptoms
    }
}

