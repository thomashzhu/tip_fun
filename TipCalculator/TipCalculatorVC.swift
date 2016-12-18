//
//  ViewController.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/7/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import UIKit
import Foundation
import pop

class TipCalculatorVC: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tipIncludedButton: UIButton!
    @IBOutlet weak var billAmountTextField: UITextField!
    
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    
    @IBOutlet weak var tipPercentageSlider: UISlider!
    
    @IBOutlet weak var tipCommentLabel: UILabel!
    
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var perPersonCostLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    // MARK: - Properties
    
    private var autoRecalculate = false
    
    private(set) var previousSavedTipPercentage: Double = 0
    private(set) var tipIncluded: Bool {
        get {
            return (tipIncludedButton.title(for: .normal) == C.TipIncludedPhase.Included.rawValue)
        }
        set {
            if newValue {
                tipIncludedButton.setTitle(C.TipIncludedPhase.Included.rawValue, for: .normal)
                previousSavedTipPercentage = tipPercentage
                tipPercentage = 0
            } else {
                tipIncludedButton.setTitle(C.TipIncludedPhase.NotIncluded.rawValue, for: .normal)
                tipPercentage = previousSavedTipPercentage
            }
            
            tipPercentageSlider.isEnabled = !newValue
            recalculate()
        }
    }
    
    private(set) var billAmount: Double {
        get {
            return F.NumberFormat.currency.number(from: billAmountTextField.text!)! as Double
        }
        set {
            billAmountTextField.text = F.NumberFormat.currency.string(from: NSNumber(value: newValue))
            
            let defaults = UserDefaults.standard
            defaults.set(Date().timeIntervalSince1970, forKey: C.PersistenceKeys.ResultTime.rawValue)
            defaults.set(newValue, forKey: C.PersistenceKeys.BillAmount.rawValue)
            defaults.synchronize()
            
            recalculate()
        }
    }
    
    private(set) var greatServicePct = 0.0, fineServicePct = 0.0, poorServicePct = 0.0
    
    private(set) var tipPercentage: Double {
        get {
            return F.NumberFormat.percentage.number(from: tipPercentageLabel.text!)! as Double
        }
        set {
            tipPercentageLabel.text = F.NumberFormat.percentage.string(from: NSNumber(value: newValue))
            tipPercentageSlider.value = Float(newValue)
            recalculate()
        }
    }
    
    private(set) var tipAmount: Double {
        get {
            return F.NumberFormat.currency.number(from: tipAmountLabel.text!)! as Double
        }
        set {
            tipAmountLabel.text = F.NumberFormat.currency.string(from: NSNumber(value: newValue))
            recalculate()
        }
    }
    
    private(set) var numberOfPeople: Int {
        get {
            return F.NumberFormat.integer.number(from: numberOfPeopleLabel.text!)! as Int
        }
        set {
            numberOfPeopleLabel.text = F.NumberFormat.integer.string(from: NSNumber(value: newValue))
            recalculate()
        }
    }
    
    // MARK: - Lifecycle Callbacks
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        billAmountTextField.delegate = self
        
        setDefaultValues()
        
        let defaults = UserDefaults.standard
        tipPercentage = defaults.double(forKey: C.SettingKeys.DefaultTipPercentage.rawValue)
        
        recalculate()
        
        billAmountTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if Date().timeIntervalSince1970 - defaults.double(forKey: C.PersistenceKeys.ResultTime.rawValue) <
            C.dataExpirationTime {
            billAmount = defaults.double(forKey: C.PersistenceKeys.BillAmount.rawValue)
        }
        
        greatServicePct = defaults.double(forKey: C.SettingKeys.GreatServicePercentage.rawValue)
        fineServicePct = defaults.double(forKey: C.SettingKeys.FineServicePercentage.rawValue)
        poorServicePct = defaults.double(forKey: C.SettingKeys.PoorServicePercentage.rawValue)
    }
    
    // MARK: - Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if newString.characters.count >= C.maxDisplayDigits {
            return false
        }
        
        if let decimalSeparator = Locale.current.decimalSeparator {
            let stringArray = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            newString = stringArray.joined(separator: "")
            newString.insert(contentsOf: decimalSeparator.characters, at: newString.index(newString.endIndex, offsetBy: -2))
            self.billAmount = Double(newString)!
        } else {
            if let billAmount = F.NumberFormat.currency.number(from: newString) as? Double {
                self.billAmount = billAmount
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        billAmountTextField.resignFirstResponder()
        return true
    }

    // MARK: - IBActions
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func tipIncludedTapped(_ sender: AnyObject) {
        tipIncluded = !tipIncluded
    }
    
    @IBAction func greatServicePressed(_ sender: AnyObject) {
        if !tipIncluded {
            tipPercentage = greatServicePct
        }
    }
    
    @IBAction func fineServicePressed(_ sender: AnyObject) {
        if !tipIncluded {
            tipPercentage = fineServicePct
        }
    }
    
    @IBAction func poorServicePressed(_ sender: AnyObject) {
        if !tipIncluded {
            tipPercentage = poorServicePct
        }
    }
    
    @IBAction func lowerTipPercentagePressed(_ sender: AnyObject) {
        if !tipIncluded {
            if tipPercentage.roundedTo(toNearest: C.tipPercentageIncrement) ~= tipPercentage {
                tipPercentage = max(0, tipPercentage - C.tipPercentageIncrement)
            } else {
                tipPercentage = max(0, tipPercentage.roundDown(toNearest: C.tipPercentageIncrement))
            }
        }
    }
    
    @IBAction func higherTipPercentagePressed(_ sender: AnyObject) {
        if !tipIncluded {
            if tipPercentage.roundedTo(toNearest: C.tipPercentageIncrement) ~= tipPercentage {
                tipPercentage = min(tipPercentage + C.tipPercentageIncrement, 1)
            } else {
                tipPercentage = max(0, tipPercentage.roundUp(toNearest: C.tipPercentageIncrement))
            }
        }
    }
    
    @IBAction func tipPercentageValueChanged(_ sender: AnyObject) {
        tipPercentage = Double(tipPercentageSlider.value)
    }
    
    @IBAction func fewerPeoplePressed(_ sender: AnyObject) {
        numberOfPeople = max(1, numberOfPeople - 1)
    }
    
    @IBAction func morePeoplePressed(_ sender: AnyObject) {
        numberOfPeople = numberOfPeople + 1
    }
    
    // MARK: - Helper Methods
    
    private func setDefaultValues() {
        tipIncluded = false
        
        billAmountTextField.text = F.NumberFormat.currency.string(from: 0)
            // to not trigger billAmount's record time stamp (C.PersistenceKeys.ResultTime)
        
        tipPercentage = 0
        numberOfPeople = 1
        
        autoRecalculate = true
    }
    
    private func recalculate() {
        if autoRecalculate {
            let tipAmount = billAmount * tipPercentage
            tipAmountLabel.text = F.NumberFormat.currency.string(from: NSNumber(value: tipAmount))
            
            let totalCost = billAmount + tipAmount
            totalAmountLabel.text = F.NumberFormat.currency.string(from: NSNumber(value: totalCost))
            
            let averageCost = totalCost / Double(numberOfPeople)
            perPersonCostLabel.text = F.NumberFormat.currency.string(from: NSNumber(value: averageCost))
        }
    }
    
    // MARK: - Facebook Pop
    
    @IBAction func showSettingsPressed(_ sender: AnyObject) {
        let settingVC = storyboard!.instantiateViewController(withIdentifier: "SettingVC")
        settingVC.transitioningDelegate = self
        settingVC.modalPresentationStyle = .custom
        present(settingVC, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimationController()
    }
}
