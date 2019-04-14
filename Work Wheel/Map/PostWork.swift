//
//  PostWork.swift
//  Work Wheel
//
//  Created by Ishan Jain on 4/13/19.
//  Copyright © 2019 Food Zone. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import SVProgressHUD

class PostWork: UITableViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var workButton: UIButton!
    
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var moneySlider: UISlider!
    
    var userDictionary = Dictionary<String, Any>()
    
    var options: [String] = [String]()
    
    var currentSelectedJob = ""
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionView.delegate = self
        
        self.options = ["Cook", "Gardener", "Housekeeping", "Nanny", "Carpenter"]
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.currentSelectedJob = options[row]
        
        return self.currentSelectedJob
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSelectedJob = options[row]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        descriptionView.text = "Enter Description Here..."
        descriptionView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionView.textColor == UIColor.lightGray {
            descriptionView.text = nil
            descriptionView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionView.text.isEmpty {
            descriptionView.text = "Enter Description Here..."
            descriptionView.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func startWorking(_ sender: Any) {
        SVProgressHUD.show()
        
        guard let currentLocation = locManager.location else {
            return
        }
        
        if self.descriptionView.text == "" || self.money.text == "$--" || self.descriptionView.text == "Enter Description Here..." {
            //show error alert
            SVProgressHUD.dismiss()
            self.showAlert(title: "Oops!", message: "Please enter in a description of your work and how much money would like for your work")
        }else {
            let userID = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            db.collection("users").document(userID!).getDocument { (document, error) in
            if let document = document, document.exists {
                self.userDictionary = document.data()!
                let name = self.userDictionary["name"]
                //confirm work
                let userID = Auth.auth().currentUser?.uid
                let db = Firestore.firestore()
                db.collection("Work").document(userID!).setData([
                    "name": name!,
                    "work": self.currentSelectedJob,
                    "description": self.descriptionView.text!,
                    "latitude": Double(currentLocation.coordinate.latitude),
                    "longitude": Double(currentLocation.coordinate.longitude),
                    "fee": self.money.text!
                    ])
                }
            }
            dismiss(animated: false, completion: nil)
            SVProgressHUD.dismiss()
        }
        
    }
    
    @IBAction func sliderDidChange(_ sender: Any) {
        let moneySliderValue = Int(moneySlider.value)
        money.text = "$\(moneySliderValue) / hr"
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
}
