//
//  AnalyticsUtil.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 14/03/23.
//

import Foundation
//import Mixpanel
import FirebaseAnalytics

class AnalyticsUtil: NSObject {
    
    static let instance = AnalyticsUtil()
    
    private override init() { super.init() }
    
    func trackEvent(_ screenName: String) {
//        Mixpanel.mainInstance().track(event: screenName)
        Analytics.logEvent(screenName, parameters: nil)
        
    }

    func trackEvent(_ screenName: String, sourceName: String) {
//        Mixpanel.mainInstance().track(event: screenName, properties: [
//            "source" : sourceName
//        ])
        
        Analytics.logEvent(screenName, parameters: [
            "source" : sourceName
        ])
    }
    
    func trackEvent(_ screenName: String, action: String) {
//        Mixpanel.mainInstance().track(event: screenName, properties: [
//            "action" : action
//        ])
        
        Analytics.logEvent(screenName, parameters: [
            "action" : action
        ])
    }

}
