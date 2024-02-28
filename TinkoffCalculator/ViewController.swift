//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Ксения on 21.02.2024.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case devide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
            
        case .substract:
            return number1 - number2
            
        case .multiply:
            return number1 * number2
            
        case .devide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle 
        else {
            print("ERROR: sender.currentTitle = nil")
            return
        }
        
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
        if label.text == "0" || label.text == "Ошибка" {
            label.text = buttonText
        }
        else{
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard 
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
        else {
            print("ERROR: sender.currentTitle = nil")
            return
        }
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {
            print("ERROR: label don't read")
            return
        }
        
        calculatorHistory.append(.number(labelNumber))
        calculatorHistory.append(.operation(buttonOperation))
        
        resetLabelText()
    }
    
    @IBAction func clearButtonPressed() {
        calculatorHistory.removeAll()
        
        resetLabelText()
    }
    
    @IBAction func calculateButtonPressed() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {
            print("ERROR: label don't read")
            return
        }
        
        calculatorHistory.append(.number(labelNumber))
        
        do{
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Ошибка"
        }
        
        calculatorHistory.removeAll()
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "CALCULATIONS_LIST",
                let calculationsListVC = segue.destination as? CalculationsListViewController else { return }
        calculationsListVC.result = label.text
    }
    
    
    @IBAction func showCalculationsList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationListVC = sb.instantiateViewController(identifier: "CalculationsListViewController")
        if let vc = calculationListVC as? CalculationsListViewController {
            vc.result = label.text
        }
        
        show(calculationListVC, sender: self)
    }
    
    @IBOutlet weak var label: UILabel!
    
    var calculatorHistory: [CalculationHistoryItem] = []
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormetter = NumberFormatter()
        
        numberFormetter.usesGroupingSeparator = false
        numberFormetter.locale = Locale(identifier: "ru_RU")
        numberFormetter.numberStyle = .decimal
        
        return numberFormetter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resetLabelText()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculatorHistory[0] else { return 0 }
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculatorHistory.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculatorHistory[index],
                case .number(let number) = calculatorHistory[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    func resetLabelText() {
        label.text = "0"
    }
}

