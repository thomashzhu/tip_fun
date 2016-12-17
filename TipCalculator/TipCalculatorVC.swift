//
//  ViewController.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/7/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import UIKit
import Foundation

class TipCalculatorVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tipsIncludedButton: UIButton!
    @IBOutlet weak var billAmountTextField: UITextField!
    
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    
    @IBOutlet weak var tipPercentageSlider: UISlider!
    
    @IBOutlet weak var tipCommentLabel: UILabel!
    
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var perPersonCostLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    // MARK: - Properties
    
    enum TipsIncludedPhase: String {
        case Included = "[X] tips included"
        case NotIncluded = "[ ] tips included"
    }
    
    private var autoRecalculate = false
    
    private(set) var previousSavedTipPercentage: Double = 0
    private(set) var tipsIncluded: Bool {
        get {
            return (tipsIncludedButton.title(for: .normal) == TipsIncludedPhase.Included.rawValue)
        }
        set {
            if newValue {
                tipsIncludedButton.setTitle(TipsIncludedPhase.Included.rawValue, for: .normal)
                previousSavedTipPercentage = tipPercentage
                tipPercentage = 0
            } else {
                tipsIncludedButton.setTitle(TipsIncludedPhase.NotIncluded.rawValue, for: .normal)
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
            recalculate()
        }
    }
    
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
            print(F.NumberFormat.currency.number(from: tipAmountLabel.text!)! as Double)
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
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        billAmountTextField.delegate = self
        
        setDefaultValues()
        recalculate()
        
        billAmountTextField.becomeFirstResponder()
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
    
    @IBAction func tipsIncludedTapped(_ sender: AnyObject) {
        tipsIncluded = !tipsIncluded
    }
    
    @IBAction func poorServicePressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func fineServicePressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func greatServicePressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func lowerTipPercentagePressed(_ sender: AnyObject) {
        if !tipsIncluded {
            if tipPercentage.roundedTo(toNearest: C.tipPercentageIncrement) ~= tipPercentage {
                tipPercentage = max(0, tipPercentage - C.tipPercentageIncrement)
            } else {
                tipPercentage = max(0, tipPercentage.roundDown(toNearest: C.tipPercentageIncrement))
            }
        }
    }
    
    @IBAction func higherTipPercentagePressed(_ sender: AnyObject) {
        if !tipsIncluded {
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
        tipsIncluded = false
        
        billAmount = 0
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
}
