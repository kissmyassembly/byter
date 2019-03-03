//
//  heyViewController.swift
//  byter
//
//  Created by Gouri Jamakhandi on 3/3/19.
//  Copyright © 2019 Gouri Jamakhandi. All rights reserved.
//

import UIKit
import Hero

class heyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func nextButton(_ sender: Any) {
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! connectViewController
    
    vc.hero.isEnabled = true
    vc.hero.modalAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.left)
    }
    
    
        //self.performSegue(withIdentifier: "heyToConnect", sender: self)
    }
    
}
