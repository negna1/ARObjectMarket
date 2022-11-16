//
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 21.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import ARKit
//import FirebaseAnalytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
//    private func openVC() {
//        let window = UIWindow()
//
//        let vc = StarterViewController()
//        let navController = UINavigationController(rootViewController: vc)
//        window.rootViewController = navController
//        self.window = window
//        window.makeKeyAndVisible()
//nefe
//    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("shemevida")
//        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventPurchase, parameters: [
//          AnalyticsParameterPaymentType: "test",
//          AnalyticsParameterPrice: "totalPrice",
//          AnalyticsParameterSuccess: "1",
//          AnalyticsParameterCurrency: "USD"
//        ])
//        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventAppOpen,
//                                             parameters: ["open": "yes"])
//        Analytics.logEvent("open app", parameters: ["loge": "dds"])
        guard ARWorldTrackingConfiguration.isSupported else {
            return false
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ViewController {
            viewController.blurView.isHidden = false
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ViewController {
            viewController.blurView.isHidden = true
        }
    }
}
