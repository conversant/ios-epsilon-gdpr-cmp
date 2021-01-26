//
//  AppDelegate.swift
//  ios-cmp-test-app
//
//

import UIKit
import ConversantCMPWidget

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var cmpwidget: ConversantCMP?
    var configuration: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadConfig(true)
        return true
    }

    // Loads in a custom config defined by the publisher.
    func loadConfig(_ manual: Bool) {
        let dict: [String: Any] = ["countryCode": "US", "gdprAppliesGlobally": true, "policyUrl": "https://www.adtech123.com/privacy/", "version": "1", "id": "com.conversant.cmp-test-app-swift"]
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            cmpwidget = ConversantCMP(configuration: data)
            configuration = String(decoding: data, as: UTF8.self).replacingOccurrences(of: "\\/", with: "/")
        }
    }
}

