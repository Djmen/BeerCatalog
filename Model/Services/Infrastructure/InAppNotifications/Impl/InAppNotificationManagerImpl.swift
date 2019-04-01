//
//  InAppNotificationManagerImpl.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit

struct InAppNotificationManagerImpl: InAppNotificationManager {
    private var viewController: UIViewController? { return UIApplication.shared.keyWindow?.rootViewController }
    func showMessage(_ message: String) {
        showAlert(title: nil, message: message)
    }
    
    func showError(_ message: String) {
        showAlert(title: Strings.Alert.errorTitle, message: message)
    }
    
    func showError(_ error: Error) {
        if let reason = (error as NSError).localizedFailureReason {
            showAlert(title: error.localizedDescription, message: reason)
        } else {
            showAlert(title: Strings.Alert.errorTitle, message: error.localizedDescription)
        }
    }

    private func showAlert(title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.Alert.okButton, style: .cancel, handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
