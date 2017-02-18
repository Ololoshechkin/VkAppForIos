//
//  ViewController.swift
//  AppUsingSwiftyVk
//
//  Created by Vadim on 12.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit
import SwiftyVK

class ViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var onlineSettingsState: UISegmentedControl!
    
    @IBAction func onlineSettingsSwitched(_ sender: Any) {
        if (onlineSettingsState.selectedSegmentIndex == 0) {
            Vkontakte.setOnline()
        } else {
            Vkontakte.setOffline()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Vkontakte.logIn()
        usernameLabel.text = Vkontakte.getAccountName()
        image.image = Vkontakte.getMainPhoto()
        image.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

