//
//  AddOptionViewController.swift
//  AcuityEngine
//
//  Created by Bhoomi Jagani on 04/03/21.
//

import Foundation
import UIKit
import SOPullUpView

class AddOptionSelectionViewController:UIViewController{
    
    // MARK: - Outlet
    @IBOutlet weak var addOptionTableView: UITableView!
    @IBOutlet weak var handleArea: HandleView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var visualEffectView: UIView!
    
    
    //Object of Profilevalue viewcontroller...
    var symptomsVC : SymptomsListViewController?
    var conditionsVC : ConditionsListViewController?
    var vitalsVC : VitalsListViewController?
    
    var addOptionArray: Array<String> = [AddOption.Symptom.rawValue,AddOption.Conditions.rawValue,AddOption.vitals.rawValue]
    //var labelsAsStringForMonth: Array<String> = ["Week1","Week2","Week3","Week4"]
    // MARK: - Properties
    
    var pullUpControl: SOPullUpControl? {
        didSet {
            pullUpControl?.delegate = self
        }
    }
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addOptionTableView.reloadData()
        
    }
    
    
    
}
// MARK: - SOPullUpViewDelegate

extension AddOptionSelectionViewController: SOPullUpViewDelegate {
    func pullUpViewStatus(_ sender: UIViewController, didChangeTo status: PullUpStatus) {
        switch status {
        case .collapsed:
            NotificationCenter.default.post(name: Notification.Name("pullUpClose"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("showAcuityDetailPopup"), object: nil)
        case .expanded: break
            
        }
        
    }
    
    func pullUpHandleArea(_ sender: UIViewController) -> UIView {
        return handleArea
    }
}

// MARK: - UITableViewDelegate , UITableViewDataSource

extension AddOptionSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AddOptionCell = tableView.dequeueReusableCell(withIdentifier: "AddOptionCell", for: indexPath as IndexPath) as? AddOptionCell else {
            fatalError("AcuityDetailDisplayCell cell is not found")
        }
        cell.displayData(title: addOptionArray[indexPath.row])
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 200
    //    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch AddOption(rawValue: addOptionArray[indexPath.row]){
        case .Symptom:
            do{
                openSymptomsViewController(title:AddOption.Symptom.rawValue)
            }
        case .Conditions:
            do{
                openConditionsViewController(title:AddOption.Conditions.rawValue)
            }
        case .vitals:
            do{
                openVitalViewController(title:AddOption.vitals.rawValue)
            }
            
            
        case .none:
            print("")
        }
    }
    
    //MARK: open value detail screen
    func openSymptomsViewController(title:String){
        
        //Add detail value view as child view
        symptomsVC = UIStoryboard(name: Storyboard.add.rawValue, bundle: nil).instantiateViewController(withIdentifier: "SymptomsListViewController") as? SymptomsListViewController
        self.addChild(symptomsVC!)
        let originY:CGFloat = 15
        symptomsVC?.view.frame = CGRect(x: 0, y: originY, width: visualEffectView.frame.size.width, height: visualEffectView.frame.size.height-originY)
        visualEffectView.addSubview((symptomsVC?.view)!)
        symptomsVC?.didMove(toParent: self)
        
        //Add close button target
        setUpCloseButton()
        symptomsVC?.lblTitle.text = title
        
        //Hide main view of Detail Pullup class
        mainView.isHidden = true
        symptomsVC?.setHandler(handler: { [weak self] (open) in
            if open ?? false{
                self?.setupBackButton()
                self?.visualEffectView.bringSubviewToFront((self?.handleArea)!)
            }else{
                self?.symptomsVC?.view.removeFromSuperview()
                self?.symptomsVC?.removeFromParent()
            }
        })
        visualEffectView.bringSubviewToFront(handleArea)
        
    }
    
    //MARK: open settings screen
    func openVitalViewController(title:String){
        
        //Add detail value view as child view
        vitalsVC = UIStoryboard(name: Storyboard.add.rawValue, bundle: nil).instantiateViewController(withIdentifier: "VitalsListViewController") as? VitalsListViewController
        self.addChild(vitalsVC!)
        let originY:CGFloat = 15
        vitalsVC?.view.frame = CGRect(x: 0, y: originY, width: visualEffectView.frame.size.width, height: visualEffectView.frame.size.height-originY)
        visualEffectView.addSubview((vitalsVC?.view)!)
        vitalsVC?.didMove(toParent: self)
        
        //Add close button target
        setUpCloseButton()
       
        //Hide main view of Detail Pullup class
        mainView.isHidden = true
        vitalsVC?.setHandler(handler: { [weak self] (open) in
            if open ?? false{
                self?.setupBackButton()
                self?.visualEffectView.bringSubviewToFront((self?.handleArea)!)
            }else{
                self?.vitalsVC?.view.removeFromSuperview()
                self?.vitalsVC?.removeFromParent()
            }
        })
        visualEffectView.bringSubviewToFront(handleArea)
    }
    
    //MARK: open Terms screen
    func openConditionsViewController(title:String){
        
        //Add detail value view as child view
        conditionsVC = UIStoryboard(name: Storyboard.add.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ConditionsListViewController") as? ConditionsListViewController
        self.addChild(conditionsVC!)
        let originY:CGFloat = 15
        conditionsVC?.view.frame = CGRect(x: 0, y:originY, width: visualEffectView.frame.size.width, height: visualEffectView.frame.size.height-originY)
        visualEffectView.addSubview((conditionsVC?.view)!)
        conditionsVC?.didMove(toParent: self)
        
        //Add close button target
        setUpCloseButton()
        
        //Hide main view of Detail Pullup class
        mainView.isHidden = true
        
        visualEffectView.bringSubviewToFront(handleArea)
    }
    func setupBackButton(){
        handleArea.btnBack!.isHidden = false
        handleArea.btnBack!.addTarget(self, action: #selector(btnBackClickedInAddOptionVC), for: UIControl.Event.touchUpInside)
    }
    
    func setUpCloseButton(){
        handleArea.btnClose!.isHidden = false
        handleArea.btnClose!.addTarget(self, action: #selector(btnCloseClickedInAddOptionVC), for: UIControl.Event.touchUpInside)
        
    }
    
    //MARK: Btn close click
    @objc func btnCloseClickedInAddOptionVC(){
        
        if symptomsVC != nil{
            removeSymptomsView()
        }
        if vitalsVC != nil{
            removeVitalView()
        }
        if conditionsVC != nil{
            removeConditionView()
        }
        
    }
    //MARK: Btn Back click
    @objc func btnBackClickedInAddOptionVC(){
        
        if symptomsVC != nil{
            if let _:UIView = symptomsVC?.view.viewWithTag(111) {
                self.symptomsVC?.removeAddSymptomsViewController()
            }else{
                removeSymptomsView()
                
            }
        }
        if vitalsVC != nil{
            if let _:UIView = vitalsVC?.view.viewWithTag(111) {
                self.vitalsVC?.removeAddVitalsViewController()
            }else{
                removeVitalView()
            }
        }
        if conditionsVC != nil{
        }
        removeBackButton()
    }
    
    func removeVitalView(){
        
        self.vitalsVC?.tblVitals?.removeFromSuperview()
        self.vitalsVC?.view.removeFromSuperview()
        self.vitalsVC?.removeFromParent()
        self.vitalsVC = nil
        removeCloseButton()
        removeBackButton()
        
    }
    func removeSymptomsView(){
        
        self.symptomsVC?.symptomView?.removeFromSuperview()
        self.symptomsVC?.view.removeFromSuperview()
        self.symptomsVC?.removeFromParent()
        self.symptomsVC = nil
        removeCloseButton()
        removeBackButton()
    }
    
    func removeConditionView(){
        
        conditionsVC?.view.removeFromSuperview()
        conditionsVC?.removeFromParent()
        self.conditionsVC = nil
        removeCloseButton()
        removeBackButton()
    }
    func removeCloseButton(){
        mainView.isHidden = false
        handleArea.btnClose!.isHidden = true
        
    }
    func removeBackButton(){
        handleArea.btnBack!.isHidden = true
    }
}
