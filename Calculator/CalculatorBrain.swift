//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Luis E. Arevalo on 8/28/17.
//  Copyright © 2017 Luis E. Arevalo. All rights reserved.
//

import Foundation
class Memory{
    
    private var memory = 0.0
    
    
    public var value: Double {
        set{
            memory = newValue
        }
        
        get{
            return memory
        }
        
        
    }
    
}


class CalculatorBrain{
    
    private var accumulator = 0.0
    func setOperand (Operand: Double ) {
        accumulator = Operand
    }
    
    
    
    private enum Operation {
        case Constant (Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double ,Double) -> Double)
        case Equals
    }
    
    
    
    private var variableValues = [String: Double]()
    
    
    func returnKey() -> Double{
        variableValues.v
    }
    
    var operationStack : [(value:Double, operation:String)] = []
    func undo() -> (Double, Bool)? {
        
        if !operationStack.isEmpty{
            //print("before popping")
            //print( operationStack)
            let newDisplayValue =  operationStack.popLast()!.value
            //print("after popping " )
            //print(operationStack)
            var SetUserIsInTheMiddleOfTyping = true
            
            if let lastOperation = operationStack.last{
                
                let x = operations[lastOperation.operation]!
                switch x {
                case .BinaryOperation (let function):
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: lastOperation.value)
                    
                case .UnaryOperation(let function):
                    SetUserIsInTheMiddleOfTyping = false
                    
                default:
                    break
                }
                
            }
            return (newDisplayValue, SetUserIsInTheMiddleOfTyping)
        }
        return nil
    }
    
    
    func setOperand(variableName: String){
        
        variableValues[variableName] = 0.0
        
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant (M_PI),
        "e": Operation.Constant (M_E),
        "√": Operation.UnaryOperation(sqrt),
        "+/-": Operation.UnaryOperation({-$0}),
        "x²": Operation.UnaryOperation({$0 * $0}),
        "cos": Operation.UnaryOperation (cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "×": Operation.BinaryOperation({ $0 * $1}),
        "+": Operation.BinaryOperation({ $0 + $1}),
        "−": Operation.BinaryOperation({$0 - $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "=": Operation.Equals,
        "1/x": Operation.UnaryOperation({1 / $0})
    ]
    
    
    private func executePendingBinaryOperation (){
        if pending != nil{
            
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            
            
            pending = nil
        }
        
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo{
        var binaryFunction: (Double, Double ) -> Double
        var firstOperand: Double
        
    }
    
    func performOperation(symbol: String ){
        
        if let operation = operations[symbol]{
            switch operation{
            case .Constant (let value): accumulator = value
            case .BinaryOperation (let function):
                operationStack.append((value: accumulator, operation: symbol))
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
                
            case .Equals:
                operationStack.append((value: accumulator, operation: symbol))
                
                executePendingBinaryOperation()
                
            case .UnaryOperation(let fucntion):
                if pending != nil {
                    operationStack.append((value: accumulator, operation: symbol))
                }
                
                executePendingBinaryOperation()
                operationStack.append((value: accumulator, operation: symbol))
                
                accumulator = fucntion(accumulator)
                
                
                
            }
        }
        
        print(operationStack)
    }
    
    func clear () {
        accumulator = 0.0
        pending =  nil
    }
    
    var result: Double {
        return accumulator
    }
    
}
