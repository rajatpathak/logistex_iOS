/**
 *
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author     : Shiv Charan Panjeta < shiv@toxsl.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of ToXSL Technologies Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */


import UIKit

class Language: NSObject {
    
    class func DoTheSwizzling() {
        
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(key:value:table:)))
        
    }
}
extension Bundle {
    @objc func specialLocalizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        let currentLanguage = Locale.preferredLanguage
        var bundle = Bundle();
        if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle(path: _path)!
        } else {
            let _path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            bundle = Bundle(path: _path)!
        }
        return (bundle.specialLocalizedStringForKey(key: key, value: value, table: tableName))
    }
}

/// Exchange the implementation of two methods for the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}


extension Locale {
    static var preferredLanguage: String {
        get {
            
            if let language = UserDefaults.standard.object(forKey: "Language") as? String {
                return language
            }else {
                return "en"
            }
        }
        set {
            UserDefaults.standard.set([newValue], forKey: "Language")
            UserDefaults.standard.synchronize()
        }
    }
}

extension String {
    var localized: String {
        
        var result: String
        
        let languageCode = Locale.preferredLanguage //en-US
        
        var path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        
        if path == nil, let hyphenRange = languageCode.range(of: "-") {
            let languageCodeShort = languageCode.substring(to: hyphenRange.lowerBound) // en
            path = Bundle.main.path(forResource: languageCodeShort, ofType: "lproj")
        }
        
        if let path = path, let locBundle = Bundle(path: path) {
            result = locBundle.localizedString(forKey: self, value: nil, table: nil)
        } else {
            result = NSLocalizedString(self, comment: "")
        }
        return result
    }
}
