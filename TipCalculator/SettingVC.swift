//
//  SettingVC.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/7/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var greatServicePctTextField: UITextField!
    @IBOutlet weak var fineServicePctTextField: UITextField!
    @IBOutlet weak var poorServicePctTextField: UITextField!
    
    @IBOutlet weak var defaultTipPctTextField: UITextField!
    
    // MARK: - Lifecycle Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(textField: greatServicePctTextField, key: C.SettingKeys.GreatServicePercentage.rawValue)
        configure(textField: fineServicePctTextField, key: C.SettingKeys.FineServicePercentage.rawValue)
        configure(textField: poorServicePctTextField, key: C.SettingKeys.PoorServicePercentage.rawValue)
        configure(textField: defaultTipPctTextField, key: C.SettingKeys.DefaultTipPercentage.rawValue)
    }
    
    // MARK: - IBActions
    
    @IBAction func closePressed(_ sender: AnyObject) {
        dismiss(animated: true) {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: C.viewAppeared)))
        }
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func savePressed(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        
        if greatServicePctTextField.text == "" {
            defaults.set(0, forKey: C.SettingKeys.GreatServicePercentage.rawValue)
        } else if let greatServicePct = F.NumberFormat.percentile.number(from: greatServicePctTextField.text!) as? Double {
            defaults.set(greatServicePct / 100, forKey: C.SettingKeys.GreatServicePercentage.rawValue)
        }
        
        if fineServicePctTextField.text == "" {
            defaults.set(0, forKey: C.SettingKeys.FineServicePercentage.rawValue)
        } else if let fineServicePct = F.NumberFormat.percentile.number(from: fineServicePctTextField.text!) as? Double {
            defaults.set(fineServicePct / 100, forKey: C.SettingKeys.FineServicePercentage.rawValue)
        }
        
        if poorServicePctTextField.text == "" {
            defaults.set(0, forKey: C.SettingKeys.PoorServicePercentage.rawValue)
        } else if let poorServicePct = F.NumberFormat.percentile.number(from: poorServicePctTextField.text!) as? Double {
            defaults.set(poorServicePct / 100, forKey: C.SettingKeys.PoorServicePercentage.rawValue)
        }
        
        if defaultTipPctTextField.text == "" {
            defaults.set(0, forKey: C.SettingKeys.DefaultTipPercentage.rawValue)
        } else if let defaultTipPct = F.NumberFormat.percentile.number(from: defaultTipPctTextField.text!) as? Double {
            defaults.set(defaultTipPct / 100, forKey: C.SettingKeys.DefaultTipPercentage.rawValue)
        }
        
        defaults.synchronize()
        dismiss(animated: true) { 
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: C.viewAppeared)))
        }
    }
    
    // Helper Methods
    
    private func configure(textField: UITextField, key: String) {
        let defaults = UserDefaults.standard
        let number = defaults.double(forKey: key)
        
        if number == 0 {
            textField.placeholder = F.NumberFormat.percentile.string(from: 0)
        } else {
            textField.text = F.NumberFormat.percentile.string(from: NSNumber(value: number * 100))
        }
        
        textField.clearButtonMode = .whileEditing
    }
}
