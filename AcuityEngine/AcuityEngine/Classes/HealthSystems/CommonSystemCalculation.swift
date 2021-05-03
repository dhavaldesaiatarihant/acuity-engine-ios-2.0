//
//  CommonSystemCalculation.swift
//  AcuityEngine
//
//  Created by Bhoomi Jagani on 08/04/21.
//

import Foundation


//Total/Final System Score
func commonTotalSystemScoreWithDays(arrayDayWiseSystemScore:[Double]) -> Double{
    
    print("arrayDayWiseSystemScore",arrayDayWiseSystemScore)
    //Calculate average system core for 7 days/30 days/3 months
    let calculatedScore = arrayDayWiseSystemScore.average()
    
    print("calculatedScore",calculatedScore)
    return calculatedScore
}
//calculate system score for Cardio
func commonSystemScoreWithDays(arrayFraction:[Double])->[Double]{
    var arrayDayWiseSystemScore:[Double] = []
    
    print("abnormalFractionWithDays",arrayFraction)
    if arrayFraction.count > 0 {
        for i in 0...arrayFraction.count-1{
            let score = arrayFraction[i]
            let systemScore = (1-score)*100
            arrayDayWiseSystemScore.append(systemScore)
        }
    }
    return arrayDayWiseSystemScore
}

//Fraction of Score to calculate System score
func commonAbnormalFractionWithDays(arrayDayWiseTotalScore:[Double],maxTotalScore:Double)->[Double]{
    
    print("arrayDayWiseTotalScore",arrayDayWiseTotalScore)
    var arrayFraction:[Double] = []
    
    if arrayDayWiseTotalScore.count > 0 {
        for i in 0...arrayDayWiseTotalScore.count-1{
            let totalScore = arrayDayWiseTotalScore[i]
            let fraction = totalScore/maxTotalScore
            arrayFraction.append(fraction)
        }
    }
    return arrayFraction
}


//Metrix total score
func commonTotalMetrixScoreWithDays(totalScoreCondition:[Double],totalScoreSymptom:[Double],totalScoreVitals:[Double],totalScoreLab:[Double]) -> [Double]{
    var arrayDayWiseTotalScore:[Double] = []
    
    if totalScoreVitals.count == totalScoreSymptom.count,totalScoreCondition.count == totalScoreLab.count && totalScoreVitals.count>0,totalScoreCondition.count>0{
        print("commonTotalMetrixScoreWithDays totalScoreSymptom",totalScoreSymptom)
        print("commonTotalMetrixScoreWithDays totalScoreVitals",totalScoreVitals)
        for i in 0...totalScoreVitals.count - 1{
            
            let totalScore1 = totalScoreVitals[i] + totalScoreCondition[i]
            let totalScore2 =  totalScoreLab[i] + totalScoreSymptom[i]
            let totalScore = totalScore1 + totalScore2
            
            arrayDayWiseTotalScore.append(totalScore)
        }
    }
    
    return arrayDayWiseTotalScore
}

//MARK: Create or Get Vital Models..
func getVitalModel(item:VitalCalculation)->VitalsModel{
    let impData =  VitalsModel(title: item.title.rawValue, value: String(format: "%.2f", item.value))
    impData.color = item.getUIColorFromCalculatedValue()
    return impData
}
//MARK: Create or Get Conditions Models..
func getConditionsModel(condition:ConditionCalculation)->ConditionsModel{
    let conditionValue = condition.calculatedValue < 0 ? 0 : condition.calculatedValue
    return ConditionsModel(title: condition.type.rawValue, value: ConditionValue(rawValue: conditionValue)!)
}
func saveVitalsInArray(item:VitalCalculation)->VitalsModel{
    let impData =  VitalsModel(title: item.title.rawValue, value: String(format: "%.2f", item.value))
    impData.startTime = item.startTimeStamp
    impData.color = item.getUIColorFromCalculatedValue()
    return impData
}

func filterArrayWithSelectedSegmentInGraph(days:SegmentValueForGraph,array:[VitalCalculation])->[VitalCalculation]{
    let now = MyWellScore.sharedManager.todaysDate
    
    let timeIntervalByLastMonth:Double = getTimeIntervalBySelectedSegmentOfDays(days: days)
    let timeIntervalByNow:Double = now.timeIntervalSince1970
    var filteredArray:[VitalCalculation] = []
    
    filteredArray = array.filter { item in
        filterConditionForOtherMetrix(sampleItem: item, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
    }
    
    return filteredArray
}
