//
//  DroneHomeViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 12/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import DJIUXSDK

class DroneHomeViewController: DUXDefaultLayoutViewController {
    
    let transition = SlideInTransition()
    
    @IBOutlet weak var menuLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuLabel.layer.cornerRadius = 3.0
        menuLabel.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
       menuLabel.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tapped  button menu")
        
               let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuScreen") as! MenuViewController

              menuVC.modalPresentationStyle = .overCurrentContext
               menuVC.transitioningDelegate = self
           present(menuVC, animated: true) {
               print("Presented ViewController")
           }
    }
    
    
    
//    @IBAction func menuTapped(_ sender: UIButton) {
//        print("tapped  button menu")
//
//            let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuScreen") as! MenuViewController
//
//           menuVC.modalPresentationStyle = .overCurrentContext
//            menuVC.transitioningDelegate = self
//        present(menuVC, animated: true) {
//            print("Presented ViewController")
//        }
//
//
//
//
//    }
    
    
    
}
extension DroneHomeViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
