//
//  MenuViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 20/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var altitudeTextField: UITextField!
    @IBOutlet weak var frontOverlaptextField: UITextField!
    @IBOutlet weak var sidelaptextField: UITextField!
    @IBOutlet weak var waypointTextField: UITextField!
    @IBOutlet weak var gimbletextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 5.0
        self.view.layer.masksToBounds = true
        altitudeTextField.delegate = self
        frontOverlaptextField.delegate = self
        sidelaptextField.delegate = self
        waypointTextField.delegate = self
        gimbletextField.delegate = self
        doneButton.layer.cornerRadius = 3.0
        doneButton.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doneTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("Presented get  dismiss")
        }
        
        
    }
    
}
