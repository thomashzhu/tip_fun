//
//  ViewController.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/7/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import UIKit

class TipCalculatorVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var billAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billAmount.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        billAmount.resignFirstResponder()
        return true
    }

    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }

}

