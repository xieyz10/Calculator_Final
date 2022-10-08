//
//  ViewController.swift
//  Calculator
//
//  Created by Mingyuan Xie on 9/20/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outputResult_Label: UILabel!
    var digitStack = [Double]()
    var operatorStack = [String]()
    var removedDigitStack = [Double]()
    var removedOperatorStack = [String]()
    var tempResult:Double = 0
    var lastOperator:String = ""
    var previousOperatorButton = ""
    var currentResult:Double = 0
    var hasClickedOperatorButton = false
    var hasFinishedInput = false
    var hasClickedEqualButton = false
    
    @IBAction func digitButton_Pressed(_ sender: UIButton) {
        if hasClickedOperatorButton && hasFinishedInput {
            outputResult_Label.text = ""
        }
        let digit:Int! = Int(sender.titleLabel!.text!)
        if sender.titleLabel!.text! == "." {
            if !outputResult_Label.text!.contains(".") {
                outputResult_Label.text! = outputResult_Label.text! + "."
            }
        }else{
            outputResult_Label.text! = outputResult_Label.text! == "0" ? String(digit): outputResult_Label.text! + String(digit)
        }
        hasFinishedInput = false
        hasClickedOperatorButton = false
    }
    
    @IBAction func operatorButton_Pressed(_ sender: UIButton) {
        if(hasClickedEqualButton == true) {return}
        if sender.titleLabel!.text! == "=" && digitStack.count != 0 {
            equalButton_Pressed()
            return
        }
        currentResult = Double(outputResult_Label.text!) ?? 0.0
        if hasClickedOperatorButton == true && !handleChangeOperator(sender: sender){
            operatorStack.removeLast()
            operatorStack.append(sender.titleLabel!.text!)
            hasFinishedInput = true
            return
        }
        hasClickedOperatorButton = true
        previousOperatorButton = sender.titleLabel!.text!
        let currentOperator:String = sender.titleLabel!.text!
        if digitStack.count == 0 {
            digitStack.append(currentResult)
            operatorStack.append(currentOperator)
        }else{
            digitStack.append(currentResult)
            //check if previous operator is * or /
            let lastOperator:String = operatorStack[operatorStack.count-1]
            if lastOperator == "×" || lastOperator == "÷" {
                hendleWhenLastOperatorIsMultiplicationOrDivide(lastOperator: lastOperator)
            }
            if currentOperator == "×" || currentOperator == "÷" {
                operatorStack.append(currentOperator)
            }else{
                handleWhenCurrentOperatorIsPlusOrMinus(currentOperator:currentOperator)
            }
        }
        hasFinishedInput = true
    }
    
    @IBAction func positiveOrNagativeOrPercentageButton_Pressed(_ sender: UIButton) {
        if hasClickedOperatorButton == true { return }
        let outputeText:String = outputResult_Label.text!
        let value:Double = Double(outputeText) ?? 0
        if sender.titleLabel!.text! == "+/-"{
            if value > 0{
                outputResult_Label.text = "-"+outputeText
            }else if value < 0 {
                outputResult_Label.text = handleOutputResult(output:String(value * (-1)))
            }else{
                outputResult_Label.text = "0"
            }
        }else if sender.titleLabel!.text! == "%" {
            outputResult_Label.text = String(value/100)
        }
    }
    
    func equalButton_Pressed(){
        if  digitStack.count == operatorStack.count {
            if hasFinishedInput == false{
                currentResult = Double(outputResult_Label.text!) ?? 0.0
                digitStack.append(currentResult)
            }else{
                digitStack.append(digitStack[digitStack.count-1])
            }
        }
        let lastOperator = operatorStack[operatorStack.count-1]
        while operatorStack.count != 0 {
            let value1:Double = digitStack.removeLast()
            let value2:Double = digitStack.removeLast()
            let currentOperator = operatorStack.removeLast()
            if currentOperator == "×"{
                digitStack.append(value1 * value2)
            }else if currentOperator == "÷"{
                digitStack.append(value2 / value1)
            }else if currentOperator == "+"{
                digitStack.append(value1 + value2)
            }else if currentOperator == "-"{
                digitStack.append(value2 - value1)
            }
        }
        outputResult_Label.text = handleOutputResult(output:String(digitStack[digitStack.count-1]))
        operatorStack.append(lastOperator)
        if hasFinishedInput == false {
            hasFinishedInput = true
        }
        hasClickedEqualButton = true
    }
    
    @IBAction func deleteButton_Pressed(_ sender: UIButton) {
        if hasClickedOperatorButton == true { return }
        let text = outputResult_Label.text!
        if text.count == 1 {
            outputResult_Label.text = "0"
            return
        }
        let beginIndex = text.index(text.startIndex, offsetBy: 0)
        let endIndex = text.index(text.startIndex, offsetBy: text.count-2)
        let subString = String(text[beginIndex...endIndex])
        outputResult_Label.text = subString
    }
    
    @IBAction func clearButton_Pressed(_ sender: UIButton) {
        outputResult_Label.text = "0"
        digitStack.removeAll()
        operatorStack.removeAll()
        removedDigitStack.removeAll()
        removedOperatorStack.removeAll()
        tempResult = 0
        lastOperator = ""
        previousOperatorButton = ""
        currentResult = 0
        hasClickedOperatorButton = false
        hasFinishedInput = false
        hasClickedEqualButton = false
    }
    
    func handleChangeOperator(sender:UIButton)->Bool{
        if (previousOperatorButton == "+" || previousOperatorButton == "−")
            && (sender.titleLabel!.text! == "×" || sender.titleLabel!.text! == "÷"){
            if removedDigitStack.count >= 2 {
                let origialFirstValue = removedDigitStack.removeLast()
                let origialSecondValue = removedDigitStack.removeLast()
                digitStack.removeLast()
                digitStack.append(origialFirstValue)
                operatorStack.removeLast()
                operatorStack.append(removedOperatorStack.removeLast())
                currentResult = origialSecondValue
                outputResult_Label.text = handleOutputResult(output:String(currentResult))
                return true
            }
        }else if (previousOperatorButton == "×" || previousOperatorButton == "÷")
                    && (sender.titleLabel!.text! == "+" || sender.titleLabel!.text! == "-"){
            currentResult = digitStack.removeLast()
            operatorStack.removeLast()
            return true
        }
        return false
    }
    
    func hendleWhenLastOperatorIsMultiplicationOrDivide(lastOperator:String){
        let value1:Double = digitStack.removeLast()
        let value2:Double = digitStack.removeLast()
        operatorStack.removeLast()
        if lastOperator == "×" {
            tempResult = value1 * value2
        }else{
            tempResult = value2 / value1
        }
        digitStack.append(tempResult)
        outputResult_Label.text = handleOutputResult(output:String(tempResult))
    }
    
    func handleWhenCurrentOperatorIsPlusOrMinus(currentOperator:String){
        if digitStack.count < 2 {
            operatorStack.append(currentOperator)
        }else {
            lastOperator = operatorStack[operatorStack.count-1]
            let value1:Double = digitStack.removeLast()
            removedDigitStack.append(value1)
            let value2:Double = digitStack.removeLast()
            removedDigitStack.append(value2)
            
            if(lastOperator == "+"){
                tempResult = value1 + value2
            }else{
                tempResult = value2 - value1
            }
            let removedOperator = operatorStack.removeLast()
            removedOperatorStack.append(removedOperator)
            
            digitStack.append(tempResult)
            operatorStack.append(currentOperator)
            outputResult_Label.text = handleOutputResult(output:String(tempResult))
        }
    }

    func handleOutputResult(output:String)->String{
        var result:String = output
        if output.contains(".") {
            let arraySubstrings: [Substring] = output.split(separator: ".")
            if arraySubstrings[1] == "0"{
                result = String(arraySubstrings[0])
            }
        }
        return result;
    }    
}

