//
//  SettingsViewController.swift
//  Bearcat Ninja
//
//  Created by Berk Çohadar on 11/18/21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var BrightnessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BrightnessSlider(_ sender: UISlider) {
        BrightnessLabel.text = String(sender.value)
        UIScreen.main.brightness = CGFloat(sender.value)
    }
}
