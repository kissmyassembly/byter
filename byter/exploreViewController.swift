//
//  exploreViewController.swift
//  byter
//
//  Created by Gouri Jamakhandi on 3/3/19.
//  Copyright © 2019 Gouri Jamakhandi. All rights reserved.
//

import UIKit

class exploreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        self.present(mainVC, animated: true, completion: nil)
    }
    

}
