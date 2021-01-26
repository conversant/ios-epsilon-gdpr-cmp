# Conversant IOS CMP Readme

The Conversant CMP Widget allows publishers to do two essential functions:

1.  Determine whether they need to get consent from a user depending on their location
2.  Get consent once they have determined they require it.

Consent is gathered using a widget which allows a user to accept data gathering on a company and purpose basis. Users can also blanket accept or deny such consent. The CMP utilizes NSUserDefaults to store pre-parsed TC data (for the user), as well as the created TC string. This enables required features for the CMP based off the IAB specs:

- Vendors to easily access TC data
- TC data to persist across app sessions
- TC data to be portable between CMPs to provide flexibility for a publisher to exchange one CMP SDK for another
- Vendors within an app to avoid code duplication by not being required to include a TC string decoder while still enabling all typical use cases

For further information and details, please review the official [IAB Docs](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md).

## Installation

1.  Drag the ConversantCMPWidget.xcframework to your project icon in xcode. In the pop up window, ensure that "Copy Items" is ticked.
2.  In the frameworks section of your project, ensure "Embed and sign" is selected (Default is "Do Not Embed")

**NOTE**: After installing the framework within the app, it is **highly** recommended to gather consent upon launching the app. It's essential to launching the consent tool as soon as possible, such as implementing the start process within the app delegate file. Most third-party frameworks won't be able to operate until consent has been gathered, so it's needed as a first step to get consent requirements before initializing other frameworks. Read documentation for each third-party service and configure accordingly.

## Quick Start

1. Import the framework to initialize the app.

**Swift**

```swift
import ConversantCMPWidget
```

**Objective-C**

```objc
@import ConversantCMPWidget;
```

2. Create JSON configuration either manually or load from an URL and initialize the ConversantCMP widget with the same within AppDelegate. If you are unsure of initialization parameters for these objects, check the documentation for each function (option click on the function).

**Swift**

```swift
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

    func loadConfig(_ manual: Bool) {
        if manual {
            let dict: [String: Any] = ["countryCode": "US", "gdprAppliesGlobally": true, "policyUrl": "https://www.adtech123.com/privacy/", "version": "1", "id": "com.conversant.cmp-test-app-swift"]
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                cmpwidget = ConversantCMP(configuration: data)
                configuration = String(decoding: data, as: UTF8.self).replacingOccurrences(of: "\\/", with: "/")
            }
        } else {
            if let url = URL(string: "https://www.mojotest.com/~yliberman/CTM/Test/YelenaFolder/GDPR/qa/inappSampleConfig.js") {
                URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }

                    if let data = data {
                        print("Config loaded from \(url.absoluteString)")
                        self?.cmpwidget = ConversantCMP(configuration: data)
                        self?.configuration = String(decoding: data, as: UTF8.self).replacingOccurrences(of: "\\/", with: "/")
                    }
                }.resume()
            }
        }
    }
}
```

**Objective-C**

(AppDelegate.h)

```objc
#import <UIKit/UIKit.h>
@import ConversantCMPWidget;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) ConversantCMP *cmpwidget;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *configuration;

- (void)loadConfig:(BOOL)manual;

@end
```

(AppDelegate.m)

```objc
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self loadConfig: true];
    return YES;
}

- (void)loadConfig:(BOOL)manual {
    if (manual) {
        NSDictionary *dict = @{@"countryCode": @"US", @"gdprAppliesGlobally": @YES, @"policyUrl": @"https://www.adtech123.com/privacy/", @"version": @"1", @"id": @"com.conversant.cmp-test-app-ios-objective-c"};

        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

        self.cmpwidget = [[ConversantCMP alloc] initWithConfiguration: data];
        self.configuration = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"\\/" withString: @"/"];

    } else {
        NSURL *url = [NSURL URLWithString: @"https://www.mojotest.com/~yliberman/CTM/Test/YelenaFolder/GDPR/qa/inappSampleConfig.js"];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL: url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSLog(@"Config loaded from %@", url.absoluteString);
                self.cmpwidget = [[ConversantCMP alloc] initWithConfiguration: data];
                self.configuration = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"\\/" withString: @"/"];
            }
        }];

        [dataTask resume];
    }
}

@end
```

3. To present the CMP widget popup use the following:

**Swift**

```swift
@IBAction func showPopup(_ sender: Any) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cmpWidget = appDelegate.cmpwidget
    cmpWidget?.presentCMPWidget(from: self, onComplete: {[weak self] in

    })
}
```

**Objective-C**

```objc
- (IBAction)showPopup:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ConversantCMP *cmpwidget = [appDelegate cmpwidget];
    [cmpwidget presentCMPWidgetFrom:self onComplete:^{

    }];
}
```

4. To allow the user to modify consent use the following:

**Swift**

```swift
@IBAction func modify(_ sender: Any) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cmpWidget = appDelegate.cmpwidget
    cmpWidget?.modifyConsent(from: self, onComplete: {[weak self] in

    })
}
```

**Objective-C**

```objc
- (IBAction)modify:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ConversantCMP *cmpwidget = [appDelegate cmpwidget];
    [cmpwidget modifyConsentFrom:self onComplete:^{

    }];
}
```

5. To check if GDPR consent is required use the following. Result will be an optional NSNumber, 1 if required else 0, will return nil or NULL in case of timeout depending upon the language used. Please note that the GDPR check is already called internally for both present and modify consent APIs so not required to be called additionally for those two functions.

**Swift**

```swift
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let cmpWidget = appDelegate.cmpwidget
cmpWidget?.checkGDPRIsRequired(containerView: self.view, completion: { (result) in

})
```

**Objective-C**

```objc
AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
ConversantCMP *cmpwidget = [appDelegate cmpwidget];
[cmpwidget checkGDPRIsRequiredWithContainerView:self.view completion:^(NSNumber * _Nullable result) {

}];
```

6. To delete the stored consents, just delete the required keys from the user defaults as per requirement. Here we are deleting three keys as an example

**Swift**

```swift
UserDefaults.standard.set("", forKey: "IABTCF_TCString")
UserDefaults.standard.set("", forKey: "CNVR_PersistentData")
```

**Objective-C**

```objc
[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"IABTCF_TCString"];
[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CNVR_PersistentData"];
```
