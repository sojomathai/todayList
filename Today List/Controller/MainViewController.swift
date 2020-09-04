//
//  MainViewController.swift
//  Today List
//
//  Created by sojo mathai on 2020-08-01.
//  Copyright © 2020 sojo mathai. All rights reserved.
//

import UIKit
import CLTypingLabel

class MainViewController: UIViewController {

    @IBOutlet weak var labelOutlet1: CLTypingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        labelOutlet1.text = "TO DO LIST AND FINDER"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
