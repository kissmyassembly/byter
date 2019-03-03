//
//  connectViewController.swift
//  byter
//
//  Created by Gouri Jamakhandi on 3/3/19.
//  Copyright © 2019 Gouri Jamakhandi. All rights reserved.
//

import UIKit

class connectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButton(_ sender: Any) {
        self.performSegue(withIdentifier: "connectToExplore", sender: self)
    }
    
}
