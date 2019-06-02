//
//  UIViewController+Util.swift
//  Currencies
//
//  Created by macbook air on 02/06/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(_ title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
