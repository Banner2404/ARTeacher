//
//  SettingsViewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/24/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var debugModeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        debugModeSwitch.isOn = Settings.shared.isDebugModeEnabled
    }
    
    @IBAction func debugModeSwitchChanged(_ sender: UISwitch) {
        Settings.shared.isDebugModeEnabled = sender.isOn
    }
}
