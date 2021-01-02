//
//  DJIAlertView.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 29/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import Foundation
typealias DJIAlertViewActionBlock = (Int) -> Void
typealias DJIAlertInputViewActionBlock = ([UITextField]?, Int) -> Void

func NavControllerObject(_ navController: Any) {
    let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
}
class DJIAlertView{

    private var alertController: UIAlertController?

//       class func show(withMessage message: String?, titles: [String]?, action actionBlock: DJIAlertViewActionBlock?) -> Self? {
//           let alertView = DJIAlertView()
//
//           alertView.alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
//           for index in 0..<(titles?.count ?? 0) {
//               let actionStyle: UIAlertAction.Style = (index == 0) ? .cancel : .default
//               let alertAction = UIAlertAction(title: titles?[index], style: actionStyle, handler: { action in
//                   if let actionBlock = actionBlock {
//                       actionBlock(index)
//                   }
//               })
//               alertView.alertController?.addAction(alertAction)
//           }
//
//           NavControllerObject(navController)
//           if let alertController1 = alertView.alertController {
//               navController.present(alertController1, animated: true)
//           }
//           return alertView
//       }
//
//    //  Converted to Swift 5.3 by Swiftify v5.3.29144 - https://swiftify.com/
//    class func showAlertView(withMessage message: String?, titles: [String]?, textFields: [String]?, action actionBlock: DJIAlertInputViewActionBlock?) -> Self? {
//        let alertView = DJIAlertView()
//
//        alertView.alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        for index in 0..<(textFields?.count ?? 0) {
//            alertView.alertController?.addTextField(configurationHandler: { textField in
//                textField.placeholder = textFields?[index]
//            })
//        }
//
//        let fieldViews = alertView.alertController?.textFields
//        for index in 0..<(titles?.count ?? 0) {
//            let actionStyle: UIAlertAction.Style = (index == 0) ? .cancel : .default
//            let alertAction = UIAlertAction(title: titles?[index], style: actionStyle, handler: { action in
//                if let actionBlock = actionBlock {
//                    actionBlock(fieldViews, index)
//                }
//            })
//
//            alertView.alertController?.addAction(alertAction)
//        }
//
//        NavControllerObject(navController)
//        navController.present(alertView.alertController, animated: true)
//        return alertView
//    }
}
