//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Ксения on 21.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle 
        else
        {
            print("ERROR: sender.currentTitle = nil")
            return
        }
        
        print(buttonText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Ксюха, ты красава!")
    }


}

