//
//  AlgorixTopOnBaseAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/19.
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlgorixTopOnBaseManager)
public class AlgorixTopOnBaseManager:NSObject {
    
    private static let TAG = "AlgorixTopOnBaseManager"
    
    public static var isInitialized:Bool = false
    
    public static let unitID = "slot_id"
    
    @discardableResult
    public static func initSDK(serverInfo: [AnyHashable: Any]) -> String?{
        NSLog("%@: alx-sdk-version:%@",AlgorixTopOnBaseManager.TAG,AlxSdk.getSDKVersion())
        NSLog("%@: topon-sdk-version:%@",AlgorixTopOnBaseManager.TAG,ATAPI.sharedInstance().version())
        NSLog("%@: topon-adapter-version:%@",AlgorixTopOnBaseManager.TAG,AlgorixTopOnMetaInf.ADAPTER_VERSION)
        
        let appid:String? = serverInfo["appid"] as? String
        let sid:String? = serverInfo["sid"] as? String
        let token:String? = serverInfo["token"] as? String
        let debug:String? = serverInfo["isdebug"] as? String
        
        NSLog("%@: token=%@; appid=%@; sid=%@",AlgorixTopOnBaseManager.TAG,token ?? "",appid ?? "",sid ?? "")
        guard let appid=appid,let sid=sid,let token=token else{
            let errorStr="initialize alx params: appid or sid or token is empty"
            NSLog("%@: error: %@",AlgorixTopOnBaseManager.TAG,errorStr)
            return errorStr
        }
        
        AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
        AlgorixTopOnBaseManager.isInitialized = true
        self.sdkInfo()
        
        if let debug,!debug.isEmpty {
            if debug.lowercased() == "true" {
                AlxSdk.setDebug(true)
            }else if debug.lowercased() == "false" {
                AlxSdk.setDebug(false)
            }
        }
        
        
        // User Privacy
        // MARK: - GDPR Consent Handling
        let gdprFlag = UserDefaults.standard.integer(forKey: "IABTCF_gdprApplies")
        let gdprConsent = UserDefaults.standard.string(forKey: "IABTCF_TCString")
        if gdprFlag == 1{
            AlxSdk.setGDPRConsent(true)
        }else  {
            AlxSdk.setGDPRConsent(false)
        }
        AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
        
        return nil
    }
    
    public static func sdkInfo(){
        var data:[String:String] = [:]
        data["sdk_name"] = "TopOn"
        data["sdk_version"] = ATAPI.sharedInstance().version()
        data["adapter_version"] = AlgorixTopOnMetaInf.ADAPTER_VERSION
        AlxSdk.addExtraParameters(key:"alx_adapter",value:data)
    }
    
    public static func error(code:Int,msg:String) -> NSError{
        return NSError(domain: "AlgorixTopOnAdapter", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
    }
    
}
