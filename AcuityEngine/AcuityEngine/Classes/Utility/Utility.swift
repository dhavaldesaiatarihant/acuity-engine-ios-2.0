//
//  Helper.swift
//  HealthKitDemo
//
//  Created by Bhoomi Jagani on 17/02/21.
//

import Foundation
import JGProgressHUD

//MARK: Show Indicator
func showIndicatorInView(view:UIView)->JGProgressHUD{
    let hud = JGProgressHUD()
    hud.textLabel.text = "Loading"
    hud.show(in: view)
    return hud
}

func hideIndicator(){
    let hud = JGProgressHUD()
    hud.dismiss()
}
/// Standardize the display of dates within the app.
func createDefaultDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}

/// Used to unescape the FHIR JSON prior to displaying it in the FHIR Source view.
func unescapeJSONString(_ string: String) -> String {
    return string.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of: "\\\\", with: "\\")
}

//MARK: Chart Segment Color
func getThemeColor(index: String?,isForWheel:Bool) -> UIColor? {
    let indexValue = Double(index ?? "") ?? 0
    if indexValue > 0 && indexValue <= 75 {
        if isForWheel{
            return WheelColor.REDCOLOR
        }else{
            return ChartColor.REDCOLOR
        }
    } else if indexValue > 75 && indexValue <= 85 {
        if isForWheel{
            return WheelColor.YELLOWCOLOR
        }else{
            return ChartColor.YELLOWCOLOR
        }
        
    } else {
        if isForWheel{
            return WheelColor.GREENCOLOR
        }else{
            return ChartColor.GREENCOLOR
        }
        
    }
}

func isiPhone() -> Bool{
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        return true
    }
    return false
}


func getDateMediumFormat(time:Double)->String{
    
    let date = Date(timeIntervalSince1970: time)
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
    
}
func getDateMediumFormatWithDate(date:Date)->String{
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
    
}
func getDateWithTime(date:Date)->String{
    
    let formatter = DateFormatter()
    formatter.dateFormat = "M/dd/yyyy hh:mm a"
    let localDate = formatter.string(from: date)
    return localDate
    
}

//MARK: Daywise Filter
func getNumberOfTimesLoopToExecute(days:SegmentValueForGraph)->[String:AnyObject]{
    let now = MyWellScore.sharedManager.todaysDate
    var component = Calendar.Component.day
    var noOfTimesLoopExecute = 1
    
    switch days {
    case .SevenDays:
        component = .day
        noOfTimesLoopExecute = ValueForMonths.SevenDays.rawValue
    case .ThirtyDays:
        component = .weekOfMonth
       
        let prevmonth = Calendar.current.date(byAdding: .month, value: -1, to: now) ?? Date()
        let weekRange = Calendar.current.dateComponents([.weekOfMonth], from: prevmonth, to: now).weekOfMonth ?? 0
      
        noOfTimesLoopExecute = weekRange
        print("noOfTimesLoopExecute ThirtyDays=====>",noOfTimesLoopExecute)
    case .ThreeMonths:
        component = .month
        noOfTimesLoopExecute = ValueForMonths.ThreeMonths.rawValue
        
    case .OneDay:
        component = .day
        noOfTimesLoopExecute = ValueForMonths.One.rawValue
    }
    let componentAndLoopDictionary = ["component":component,"noOfTimesLoopExecute":noOfTimesLoopExecute] as [String : AnyObject]
   
    return componentAndLoopDictionary
}

func daywiseFilterMetrixsData(days:SegmentValueForGraph,array:[Metrix],metriXType:MetricsType)->[Double]{
    
    var now = MyWellScore.sharedManager.todaysDate
    let getComponentAndLoop = getNumberOfTimesLoopToExecute(days: days)
    let component:Calendar.Component = getComponentAndLoop["component"] as! Calendar.Component
    let noOfTimesLoopExecute:Int = getComponentAndLoop["noOfTimesLoopExecute"] as! Int
    var averageScoreArray:[Double] = []
    for _ in 0...noOfTimesLoopExecute-1{
        
        let day = Calendar.current.date(byAdding: component, value: -1, to: now)!
        
        let timeIntervalByLastMonth:Double = day.timeIntervalSince1970
        //print("timeIntervalByLastMonth",getDateMediumFormat(time:timeIntervalByLastMonth))
        let timeIntervalByNow:Double = now.timeIntervalSince1970
        //print("timeIntervalByNow",getDateMediumFormat(time:timeIntervalByNow))
        now = day
        
        var filteredArray:[Metrix] = []
        
        if metriXType == MetricsType.Sympotms{
            filteredArray = array.filter { item in
                filterMatricsForSymptoms(sampleItem: item, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            }
        }else{
            filteredArray = array.filter { item in
                filterMatricsForVitalOrLab(sampleItem: item, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
            }
        }
        let averageScore = (Double(filteredArray.sum(\.score)).isNaN ? 0 :  Double(filteredArray.sum(\.score)))
        averageScoreArray.append(averageScore)
        //print("filteredChestPain",filteredArray)
        
    }
    return averageScoreArray
}

//MARK: Get score for conditions in system
func getScoreForConditions(array:[Metrix],days:SegmentValueForGraph)->[Double]{
    let getComponentAndLoop = getNumberOfTimesLoopToExecute(days: days)

    let noOfTimesLoopExecute:Int = getComponentAndLoop["noOfTimesLoopExecute"] as! Int
    var averageScoreArray:[Double] = []
    for _ in 0...noOfTimesLoopExecute-1{
        /*
         Here, it will filter all condition array who has isOn switch on. If isOn switch on in ConditionList VC, it's calculated value will be 1.
         */
        var filteredArray:[Metrix] = []
        filteredArray = array.filter { item in
            return item.calculatedValue == 1
        }
        let averageScore = (Double(filteredArray.sum(\.score)).isNaN ? 0 :  Double(filteredArray.sum(\.score)))
        averageScoreArray.append(averageScore)
    }
    
    return averageScoreArray
}
//MARK: getScoreForVitalData
func getScoreForVitalDataWithGivenDateRange(sampleItem:[Metrix],timeIntervalByLastMonth:Double,timeIntervalByNow:Double)->Double{
    var filteredArray:[Metrix] = []
    
    filteredArray = sampleItem.filter { item in
        filterMatricsForVitalOrLab(sampleItem: item, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
    }
    
    let averageScore = (Double(filteredArray.average(\.score)).isNaN ? 0 :  Double(filteredArray.average(\.score)))
    return averageScore
}
//MARK: getScoreForLabData
func getScoreForLabDataWithGivenDateRange(sampleItem:[Metrix],timeIntervalByLastMonth:Double,timeIntervalByNow:Double)->Double{
    var filteredArray:[Metrix] = []
    
    filteredArray = sampleItem.filter { item in
        filterMatricsForVitalOrLab(sampleItem: item, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
    }
    
    let averageScore = (Double(filteredArray.average(\.score)).isNaN ? 0 :  Double(filteredArray.average(\.score)))
    return averageScore
}
//MARK: getScoreForSymptomsData
func getScoreForSymptomsDataWithGivenDateRange(sampleItem:[Metrix],timeIntervalByLastMonth:Double,timeIntervalByNow:Double)->Double{
    var filteredArray:[Metrix] = []
    
    filteredArray = sampleItem.filter { item in
        filterMatricsForSymptoms(sampleItem: item, timeIntervalByLastMonth: timeIntervalByLastMonth, timeIntervalByNow: timeIntervalByNow)
    }
    
    let averageScore = (Double(filteredArray.average(\.score)).isNaN ? 0 :  Double(filteredArray.average(\.score)))
    return averageScore
}

func getTimeIntervalBySelectedSegmentOfDays(days:SegmentValueForGraph)->Double{
    let now = MyWellScore.sharedManager.todaysDate
    var component = Calendar.Component.day
    var beforeDaysOrWeekOrMonth = ValueForMonths.One.rawValue
    
    switch days {
    case .SevenDays:
        component = .day
        beforeDaysOrWeekOrMonth = ValueForMonths.SevenDays.rawValue
    case .ThirtyDays:
        component = .month
        beforeDaysOrWeekOrMonth = ValueForMonths.One.rawValue
    case .ThreeMonths:
        component = .month
        beforeDaysOrWeekOrMonth = ValueForMonths.ThreeMonths.rawValue
    case .OneDay:
        component = .day
        break;
    }
    
    let daysAgo = Calendar.current.date(byAdding: component, value: -beforeDaysOrWeekOrMonth, to: now)!
    
    let startOfDaysAgo = Calendar.current.startOfDay(for: daysAgo)
    let timeIntervalByLastMonth:Double = startOfDaysAgo.timeIntervalSince1970
    
    return timeIntervalByLastMonth
}

func filterMatricsForSymptoms(sampleItem:Metrix,timeIntervalByLastMonth:Double,timeIntervalByNow:Double)->Bool{
    let timeIntervalStart = sampleItem.startTimeStamp
    let timeIntervalEnd = sampleItem.endTimeStamp
    if (timeIntervalStart >= timeIntervalByLastMonth && timeIntervalStart <= timeIntervalByNow) || (timeIntervalEnd >= timeIntervalByLastMonth && timeIntervalEnd <= timeIntervalByNow) || (timeIntervalStart <= timeIntervalByNow && timeIntervalEnd >= timeIntervalByNow){
        print("sampleItem Symptoms----->",sampleItem.value)
        return true
    }
    return false
}

func filterMatricsForVitalOrLab(sampleItem:Metrix,timeIntervalByLastMonth:Double,timeIntervalByNow:Double)->Bool{
    let timeIntervalStart = sampleItem.startTimeStamp
    /*
     Here it's checking vitals's start time with timeIntervalByNow/Current time and timeIntervalByMonth/Day. So, if vitals's start time is between timeIntervalByNow/Current time and timeIntervalByMonth/Da, you will get filter data.
     */
    if (timeIntervalStart >= timeIntervalByLastMonth && timeIntervalStart <= timeIntervalByNow){
        //print("sampleItem Vitals value----->",sampleItem.value)
        //print("sampleItem Vitals score----->",sampleItem.score)
        return true
    }
    return false
}
