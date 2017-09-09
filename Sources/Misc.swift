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
    
    public class func getAppStoreViewLink(forAppID appID: String) -> String {
        return String(format: "itms://itunes.apple.com/us/app/apple-store/id%@?mt=8",appID)
    }
    
    public class func getAppStoreRateOrReviewLink(forAppID appID: String) -> String {
        return String(format: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appID)
    }
    
    public class func getCurrentLanguage() -> String {
        return Bundle.main.preferredLocalizations.first!
    }
}
