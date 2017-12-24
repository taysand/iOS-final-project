//
//  SettingsViewController.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/23/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var optimismSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optimismSwitch.setOn(UserDefaults.standard.bool(forKey: "optimistic"), animated: false)
    }
    
    @IBAction func optimismSwitchSwitched(_ sender: Any) {
        UserDefaults.standard.set(optimismSwitch.isOn, forKey: "optimistic")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
