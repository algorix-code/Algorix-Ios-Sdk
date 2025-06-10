//
//  AlxSdk.swift
//  AlxAds
//
//  Created by liu weile on 2025/3/31.
//

import Foundation

@objc public class AlxSdk:NSObject {
    
//    @objc public static let shared = AlxSdk()
    
    private static var isInit = false
    
    private override init(){
        super.init()
    }
    
    @objc public static func initializeSDK(token:String,sid:String,appId:String) {
        AlxSdkManager.initializeSDK(token: token, sid: sid, appId: appId)
        isInit = true
    }
    
    @objc public static func isSDKInit() -> Bool {
       return isInit
    }
    
    @objc public static func setDebug(_ debug:Bool) {
        AlxSdkManager.setDebug(debug)
    }
    
    @objc public static func getSDKName()->String{
        return AlxSdkManager.getSDKName()
    }
    
    @objc public static func getSDKVersion()->String{
        return AlxSdkManager.getSDKVersion()
    }
    
    @objc public static func addExtraParameters(key:String,value:Any){
        AlxSdkManager.addExtraParameters(key:key,value:value)
    }
    
    @objc public static func getExtraParameters()->[String:Any]{
        return AlxSdkManager.getExtraParameters()
    }
    
    /*
        GDPR GDPR_Consent COPPA CCPA 设置
     */
    @objc public static func setSubjectToGDPR(_ value:Bool){
        AlxSdkManager.setSubjectToGDPR(value)
    }
    
    // GDPR_Consent
    @objc public static func setUserConsent(_ value:String){
        AlxSdkManager.setUserConsent(value)
    }
    
    // COPPA
    @objc public static func setBelowConsentAge(_ value:Bool){
        AlxSdkManager.setBelowConsentAge(value)
    }
    
    // CCPA
    @objc public static func subjectToUSPrivacy(_ value:String){
        AlxSdkManager.subjectToUSPrivacy(value)
    }
    
}
