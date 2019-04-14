//
//  ProfileOverview.swift
//  Food Zone
//
//  Created by Ishan Jain on 4/6/19.
//  Copyright © 2019 Food Zone. All rights reserved.
//

import UIKit
import Firebase

class MyProfile: UITableViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    var userDictionary = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveInfo()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegueFunction(storyboardName: "Main")
        } catch let signOutError as NSError {
            showAlert(title: "Error!", message: signOutError.localizedDescription)
        }
        
    }
    
    func retrieveInfo() {
        let userID = Auth.auth().currentUser?.uid
        
        let db = Firestore.firestore()
        db.collection("users").document(userID!).getDocument { (document, error) in
            if let document = document, document.exists {
                self.userDictionary = document.data()!
                let email = self.userDictionary["email"]
                let name = self.userDictionary["name"]
                let phone = self.userDictionary["phone"]
                
                self.email.text = email as! String
                self.name.text = name as! String
                self.phone.text = phone as! String
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func performSegueFunction(storyboardName: String) {
        let viewController:UIViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "initialController") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
}
