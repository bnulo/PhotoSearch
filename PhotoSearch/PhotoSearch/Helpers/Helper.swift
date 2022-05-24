//
//  Helper.swift
//  PhotoSearch
//
//  Created by bnulo on 5/22/22.
//

import UIKit

func getApplicationRootViewController() -> UIViewController? {
//    let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .compactMap({$0 as? UIWindowScene})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first

    UIApplication.shared.windows.first?.rootViewController

    // MARK: - This solution throws
//    let allScenes = UIApplication.shared.connectedScenes
//    let scene = allScenes.first { $0.activationState == .foregroundActive }
//    if let windowScene = scene as? UIWindowScene {
//        return windowScene.keyWindow?.rootViewController
//    }
//    return nil
}

func showAlert(title: String,
                message: String,
                style: UIAlertController.Style = .alert,
               completion: ((UIAlertAction) -> Void)? = nil) {

    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: style)
    alertController.addAction(UIAlertAction(title: "OK",
                                            style: .default,
                                            handler: completion))
    getApplicationRootViewController()?
        .present(alertController, animated: true, completion: nil)
  
}
