//
//  AlertHelper.swift
//  To - Do Manager
//
//  Created by Gastronom on 22.04.24.
//

import Foundation
import UIKit


class AlertHelper {
    static func showAlert(in viewController: UIViewController?, title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        
        guard let viewController = viewController else { return }
        viewController.present(alertController, animated: true)
    }
}
