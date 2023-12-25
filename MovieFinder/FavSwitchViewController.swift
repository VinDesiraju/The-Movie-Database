//
//  FavSwitchViewController.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 4/14/23.
//

import Foundation
import UIKit



class FavSwitchViewController: UIViewController {
    
    private let switchControl = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the switch
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        // Add the switch to the view
        view.addSubview(switchControl)
        
        // Add constraints to position the switch
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchControl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // Handle the switch value changed event
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let isOn = sender.isOn
        print("Switch value changed: \(isOn)")
    }
}
