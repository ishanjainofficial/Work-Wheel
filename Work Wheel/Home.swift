//
//  Home.swift
//  Work Wheel
//
//  Created by Ishan Jain on 4/13/19.
//  Copyright © 2019 Food Zone. All rights reserved.
//

import UIKit
import Firebase

class Home: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authenticated") as! UINavigationController
            self.present(viewController, animated: false, completion: nil)
        }
    }

}
