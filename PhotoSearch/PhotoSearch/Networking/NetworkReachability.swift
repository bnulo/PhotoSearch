//
//  NetworkReachability.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import UIKit
import Alamofire

class NetworkReachability: ObservableObject {
    
    static let shared = NetworkReachability()
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    let offlineAlertController: UIAlertController = {
        UIAlertController(title: "No Network",
                          message: "Please connect to network and try again",
                          preferredStyle: .alert)
    }()
    
    init() {
        startNetworkMonitoring()
    }
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.showOfflineAlert()
            case .reachable(.cellular):
                self.dismissOfflineAlert()
            case .reachable(.ethernetOrWiFi):
                self.dismissOfflineAlert()
            case .unknown:
                print("Unknown network state")
            }
        }
    }
    
    func showOfflineAlert() {
        
        getApplicationRootViewController()?
            .present(offlineAlertController, animated: true, completion: nil)
    }
    
    func dismissOfflineAlert() {
        
        getApplicationRootViewController()?
            .dismiss(animated: true, completion: nil)
    }
}

