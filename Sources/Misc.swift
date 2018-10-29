//
//  Misc.swift
//  KJHUtility
//
//  Created by Kieran Harper on 23/1/17.
//
//

import Foundation

public class Misc: NSObject {
    
    public class func documentsDirectory() -> String {
        
        // This is the approach provided by Apple in a technical note about iOS 8, except converted to string
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        return url.path
    }
    
    public class func deleteFile(atFilespec filespec: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filespec)
        } catch {
            return false
        }
        return true
    }
    
    public class func addSkipBackupAttribute(toFilespec filespec: String) -> Bool {
        guard FileManager.default.fileExists(atPath: filespec) else { return false }
        do {
            var url = URL(fileURLWithPath: filespec)
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
        } catch {
            return false
        }
        return true
    }
    
    public enum AppStoreAction {
        case writeReview
        
        var queryString: String {
            switch self {
            case .writeReview:
                return "write-review"
            }
        }
    }
    
    /// URL String for opening the App Store page for the given `appID`. Optionally pass an `action`, such as `.writeReview` to open the Write Review screen.
    public func appStoreLink(forAppID appID: String, action: AppStoreAction?) -> String {
        var urlString = "itms-apps://itunes.apple.com/app/id\(appID)"
        if let action = action {
            urlString.append("?action=\(action.queryString)")
        }
        return urlString
    }
    
    public class func getCurrentLanguage() -> String {
        return Bundle.main.preferredLocalizations.first!
    }
}
