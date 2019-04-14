//
//  Details.swift
//  Work Wheel
//
//  Created by Ishan Jain on 4/14/19.
//  Copyright © 2019 Food Zone. All rights reserved.
//

import UIKit
import Firebase

class Details: UITableViewController {
    
    @IBOutlet weak var priceLbl: UILabel!
    
    var price: String?
    
    let viewController = PostWork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLbl.text = price
    }

}
