//
//  ViewDelegate.swift
//  ios-cmp-test-app
//
//

import UIKit
import ConversantCMPWidget

class ViewController: UIViewController {
    @IBOutlet weak var configLabel: UILabel!
    
    // Presents CMP Widget initially
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cmpWidget = appDelegate.cmpwidget
        cmpWidget?.presentCMPWidget(from: self, onComplete: {
            print("Showed CMP Widget")
        })
    }
    
    // Must reset the UserDefault stored settings to present CMP on-load
    @IBAction func reset(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "IABTCF_TCString")
        UserDefaults.standard.set("", forKey: "CNVR_PersistentData")
        print("Reset CMP Widget")
    }

    // Can freely modify CMP, which pops up widget to make adjustments
    @IBAction func modify(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cmpWidget = appDelegate.cmpwidget
        cmpWidget?.modifyConsent(from: self, onComplete: {
            print("Modified CMP Widget")
        })
    }
    
    @IBAction func showPopup(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cmpWidget = appDelegate.cmpwidget
        cmpWidget?.presentCMPWidget(from: self, onComplete: {
            print("Showed CMP Widget")
        })
    }
}
