import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import IQKeyboardManagerSwift
import SVProgressHUD

class CreateAccount: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        email.delegate = self
        phoneNumber.delegate = self
        password.delegate = self
    }
    
    @IBAction func createAccount(_ sender: Any) {
        SVProgressHUD.show()
        if (name.text == "" || email.text == "" || phoneNumber.text == "" || password.text == "") {
            
            showAlert(title: "Oops!", message: "Please enter in all of the required information!")
            SVProgressHUD.dismiss()
        }else if (name.text != nil || email.text != nil || phoneNumber.text != nil || password.text != nil) {
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                //account created
                if (error != nil) {
                    self.showAlert(title: "Oops!", message: "There was an error while creating your account. Please ensure that your password is at least 6 characters and your email is valid")
                    SVProgressHUD.dismiss()
                }else {
                    SVProgressHUD.show()
                    
                    self.saveAuthData()
                    
                    self.performSegueFunction(storyboardName: "Main")
                    SVProgressHUD.dismiss()
                    
                }
            }
        }
    }
    
    func saveAuthData() {
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        db.collection("users").document(userID!).setData([
            "name": name.text!,
            "email": email.text!,
            "phone": phoneNumber.text!,
            "password": password.text!
            ])
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func performSegueFunction(storyboardName: String) {
        let viewController:UIViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "authenticated") as! UINavigationController
        self.present(viewController, animated: false, completion: nil)
    }
    
}

