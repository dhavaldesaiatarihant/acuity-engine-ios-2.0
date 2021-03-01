//
//  ViewController.swift
//  HealthKitDemo
//
//  Created by Paresh Patel on 07/01/21.
//

import UIKit
import HealthKit
import HealthKitReporter

//pod 'HealthKitReporter'

class HealthDataViewController: UIViewController {
    
    
    //ViewModel Cardio
    private let viewModelCardio = CardioViewModel()
    //ViewModel Respiratory
    private let viewModelRespiratory = RespiratoryViewModel()
    
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        //fetch data from healthkit and load in tableview
        self.loadHealthData()
    }
    
    @IBAction func btnRefresh(){
        self.loadHealthData()
    }
    
    func loadHealthData(){
        
        //Load cardio data....
        viewModelCardio.fetchAndLoadCardioData()
        viewModelCardio.cardioDataLoaded = {(success,error) in
            if success && error == nil{
                self.reloadTable()
            }
            else if (error != nil){
                switch error {
                case .notAvailableOnDevice:
                    do {
                        print("Healthkit not available")
                    }
                case .dataTypeNotAvailable:
                    do {
                        print("Data type is not available")
                    }
                default:
                    print(error.debugDescription)
                }
            }
           
        }
        //Load Respiratory data....
        viewModelRespiratory.fetchAndLoadRespiratoryData()
        viewModelRespiratory.respiratoryDataLoaded = {(success,error) in
            if success && error == nil{
                self.reloadTable()
            }
           
           
        }
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            
            self.tblView.reloadData()
        }
    }
    
    
    private func readBasicDetails() {
        do {
            let reporter = try HealthKitReporter()
            let characteristic = reporter.reader.characteristics()
            print(characteristic.birthday ?? "")
            print(characteristic.biologicalSex ?? "")
            print(characteristic.bloodType ?? "")
            print(characteristic.skinType ?? "")
        } catch {
            print(error)
        }
    }
    
    func openUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    private func displayAlert(for error: Error) {
        
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "O.K.",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableView Delegate And Datasource Methods

extension HealthDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: DataDisplayCell = tableView.dequeueReusableCell(withIdentifier: "DataDisplayCell", for: indexPath as IndexPath) as? DataDisplayCell else {
            fatalError("AddressCell cell is not found")
        }
        switch indexPath.row {
        case 0:
            cell.displayData(cardioData: CardioManager.sharedManager.cardioData)
        case 1:
            cell.displayData(cardioData: RespiratoryManager.sharedManager.respiratoryData)
        default:
            cell.displayData(cardioData: CardioManager.sharedManager.cardioData)
        }
        // if let _ = CardioManager.sharedManager.cardioData{
        
        // }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        guard let vc = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil).instantiateViewController(identifier: "AcuityMainViewController") as? AcuityMainViewController else {return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
}
