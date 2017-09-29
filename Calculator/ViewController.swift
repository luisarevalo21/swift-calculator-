//
//  ViewController.swift
//  Calculator
//
//  Created by Luis E. Arevalo on 8/23/17.
//  Copyright © 2017 Luis E. Arevalo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var history: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var memory: Memory = Memory()
    
    @IBOutlet private weak var display: UILabel!
    
    
    @IBAction func memoryClear(_ sender: UIButton) {
        
        memory.value = 0
    }
    
    @IBAction func memoryRecall(_ sender: UIButton) {
        display.text! = String( memory.value)
    }
    
    @IBAction func memoryStore(_ sender: UIButton) {
        memory.value = Double(display.text!)!
        
        
    }
    
    @IBAction func memoryAdd(_ sender: UIButton) {
        
        
        memory.value +=  Double(display.text!)!
        display.text = String(memory.value)
    }
    
    
    @IBOutlet weak var variableText: UITextField!
    
    @IBAction func variableStore(_ sender: UIButton) {
        if variableText.text != nil {
            brain.setOperand(variableName: variableText!)
            brain.setOperand(Operand: display.text)
        }
    }
    
    
    
    
    @IBAction func undo(_ sender: UIButton) {
        print(userIsInTheMiddleOfTyping)
        if userIsInTheMiddleOfTyping{
            if display.text != nil{
                
                display.text!.remove(at: display.text!.index(before: display.text!.endIndex))
                if display.text == ""{
                    display.text! = "0"
                    userIsInTheMiddleOfTyping = false
                }
                
            }
        }
            
            
        else if let (newDisplayValue, setUserIsInTheMiddleOfTyping) = brain.undo() {
            
            display.text =  String(newDisplayValue)
            print(display.text!)
            
            userIsInTheMiddleOfTyping = setUserIsInTheMiddleOfTyping
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let currentlyInLabel = display.text!
            display.text = currentlyInLabel + digit
            
        }
            
        else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    @IBAction func touchDecimal(_ sender: UIButton) {
        
        var currentDisplay = display.text!
        
        if  currentDisplay.range(of: ".") == nil {
            
            currentDisplay += "."
            display.text = currentDisplay
        }
        
        
    }
    
    
    @IBAction func clear() {
        if display.text == "0.0"{
            brain.clear()
            history.text! = " "
        }
        
        display.text = "0.0"
        userIsInTheMiddleOfTyping = false
        
    }
    
    
    
    private var displayValue: Double {
        set{
            display.text = String(newValue)
        }
        
        get{
            return Double(display.text!)!
        }
        
    }
    
    var brain = CalculatorBrain()
    
    
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(Operand: displayValue)
            userIsInTheMiddleOfTyping = false
            
        }
        
        if let mathematicalSymbol = sender.currentTitle{
            if mathematicalSymbol != "e" && mathematicalSymbol != "π" {
                
                history.text = "\(history.text!)\(display.text!) \(mathematicalSymbol) "
                
            }
            
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        
        
    }
}
