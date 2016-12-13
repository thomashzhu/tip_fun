//
//  ViewController.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/7/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import UIKit

class TipCalculatorVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var tipPercentageSlider: UISlider!
    
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billAmount.delegate = self
    }

    // MARK: - Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        billAmount.resignFirstResponder()
        return true
    }

    // MARK: - IBActions
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func poorServicePressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func fineServicePressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func greatServicePressed(_ sender: AnyObject) {
        
    }
}

