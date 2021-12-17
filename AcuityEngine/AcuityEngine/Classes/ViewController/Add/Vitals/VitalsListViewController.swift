//
//  VitalsViewController.swift
//  AcuityEngine
//
//  Created by Bhoomi Jagani on 08/03/21.
//

import UIKit

typealias CompletionaddVitalsViewOpen = (_ open: Bool?) -> Void
class VitalsListViewController: UIViewController {
    
    @IBOutlet weak var tblVitals: UITableView!
    var arrayOfStringsSymptom: [String] = []
    var vitalsArray : [VitalModel] = []
    var addVitalsVC : AddVitalsViewController?
    var bmiCalculatorVC : BMICalculatorViewController?
    var handler: CompletionaddVitalsViewOpen?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vitalView: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set font for title
        setFontForLabel()
        
        //Load Vitals from File
        loadVitalsData()
        //
        tblVitals.reloadData()
        // Do any additional setup after loading the view.
    }
    func  setFontForLabel() {
        self.lblTitle.font = Fonts.kCellTitleFontListInAddSection
    }
    func setHandler(handler: @escaping CompletionaddVitalsViewOpen){
        self.handler = handler
    }
    
    func loadVitalsData(){
        
        //List all vitals from Doc sheet for 14 systems..
        //VitalModel contain Name,quantityTypeIdentifier for each vital..
        //quantityTypeIdentifier will use to authorize and save in Healthkit...
        vitalsArray = [VitalModel(name: VitalsName.bloodPressure),
                       //VitalModel(name: VitalsName.heartRate),
                       //VitalModel(name: VitalsName.vo2Max),
                       VitalModel(name: VitalsName.peakflowRate),
                       //VitalModel(name: VitalsName.InhalerUsage),
                       VitalModel(name: VitalsName.temperature),
                       VitalModel(name: VitalsName.bloodSugar),
                       //VitalModel(name: VitalsName.weight),
                       VitalModel(name: VitalsName.oxygenSaturation),
                       VitalModel(name: VitalsName.respiratoryRate),
                       VitalModel(name: VitalsName.BMI),]
        
        //============= Append BMI calculator ===========//
        
        /* if #available(iOS 14.0, *) {
         vitalsArray.append(VitalModel(name: VitalsName.stepLength))
         }*/
        
        /*
         VitalModel(name: VitalsName.lowHeartRate),
         VitalModel(name: VitalsName.highHeartRate),
         VitalModel(name: VitalsName.irregularRhymesNotification),
         VitalModel(name: VitalsName.headPhoneAudioLevel),
         */
        
    }
}
extension VitalsListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vitalsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LabelInListAddSectionCell = tableView.dequeueReusableCell(withIdentifier: "LabelInListAddSectionCell", for: indexPath as IndexPath) as? LabelInListAddSectionCell else {
            fatalError("LabelInListAddSectionCell cell is not found")
        }
        let vitalModel = vitalsArray[indexPath.row]
        cell.displayData(title: vitalModel.name.rawValue )
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vitalModel = vitalsArray[indexPath.row]
        if vitalModel.name == VitalsName.BMI{
            openBMICalculatorViewController(index: indexPath.row)
        }else{
            openAddVitalsViewController(index: indexPath.row)
        }
    }
    
    func openAddVitalsViewController(index:Int){
        
        //Add detail value view as child view
        addVitalsVC = UIStoryboard(name: Storyboard.add.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddVitalsViewController") as? AddVitalsViewController
        self.addChild(addVitalsVC!)
        addVitalsVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        //Show animation when view added.....
        animationForDetailViewWhenAdded(subviewToAdd: (addVitalsVC?.view)!, in: self.view)
        
        addVitalsVC?.view.setNeedsDisplay()
        addVitalsVC?.didMove(toParent: self)
        addVitalsVC?.view.tag = 111
        
        //Pass selected Symptoms to AddSymptomViewController
        let vitalData = vitalsArray[index]
        addVitalsVC?.vitalModel = vitalData
        //setUpCloseButton(frame:btnFrame , btnImage:btnImage , btnTintColor:btnTintColor! )
        //Hide main view of Detail Pullup class
        
        vitalView.isHidden = true
        
        
        if let handler = handler{
            handler(true)
        }
        
    }
    //MARK:- Open BMI Calculator.....
    func openBMICalculatorViewController(index:Int){
        
        bmiCalculatorVC = UIStoryboard(name: Storyboard.add.rawValue, bundle: nil).instantiateViewController(withIdentifier: "BMICalculatorViewController") as? BMICalculatorViewController
        self.addChild(bmiCalculatorVC!)
        bmiCalculatorVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        //Show animation when view added.....
        animationForDetailViewWhenAdded(subviewToAdd: (bmiCalculatorVC?.view)!, in: self.view)
        
        bmiCalculatorVC?.view.setNeedsDisplay()
        bmiCalculatorVC?.didMove(toParent: self)
        bmiCalculatorVC?.view.tag = 111
        
        //Pass selected Symptoms to AddSymptomViewController
        //let vitalData = vitalsArray[index]
        //addVitalsVC?.vitalModel = vitalData
        //setUpCloseButton(frame:btnFrame , btnImage:btnImage , btnTintColor:btnTintColor! )
        //Hide main view of Detail Pullup class
        
        vitalView.isHidden = true
        
        
        if let handler = handler{
            handler(true)
        }
    }
    //MARK:-
    func removeAddVitalsViewController(){
        //Show animation when view removed from superview.......
        animationForDetailViewWhenRemoved(from: self.view)
        
        if addVitalsVC != nil{
            vitalView.isHidden = false
            addVitalsVC?.view.removeFromSuperview()
            addVitalsVC?.removeFromParent()
        }
        if bmiCalculatorVC != nil{
            vitalView.isHidden = false
            bmiCalculatorVC?.view.removeFromSuperview()
            bmiCalculatorVC?.removeFromParent()
        }
        if let parentVC = self.parent {
            if let parentVC = parentVC as? AddOptionSelectionViewController {
                // parentVC is someViewController
                parentVC.removeBackButton()
            }
        }
    }
}




