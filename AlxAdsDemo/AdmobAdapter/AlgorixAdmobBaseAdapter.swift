//
//  AlgorixAdmobBaseAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/7/16.
//

import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlgorixAdmobBaseAdapter)
public class AlgorixAdmobBaseAdapter: NSObject,MediationAdapter {
    
    private static let TAG = "AlgorixAdmobBaseAdapter"
    private static let ADAPTER_VERSION = "1.1.0"
    private static let PARAMETER = "parameter"
    
    public static var isInitialized:Bool = false
    
    static public func adapterVersion() -> VersionNumber {
        let versionComponents = String(AlgorixAdmobBaseAdapter.ADAPTER_VERSION).components(
            separatedBy: ".")
        var version = VersionNumber()
        if versionComponents.count >= 3 {
            version.majorVersion = Int(versionComponents[0]) ?? 0
            version.minorVersion = Int(versionComponents[1]) ?? 0
            version.patchVersion = Int(versionComponents[2]) ?? 0
        }
        return version
    }
    
    static public func adSDKVersion() -> VersionNumber {
        let versionComponents = String(AlxSdk.getSDKVersion()).components(separatedBy: ".")
        var version = VersionNumber()
        if versionComponents.count >= 3 {
            version.majorVersion = Int(versionComponents[0]) ?? 0
            version.minorVersion = Int(versionComponents[1]) ?? 0
            version.patchVersion = Int(versionComponents[2]) ?? 0
        }
        return version
    }
    
    static public func networkExtrasClass() -> (any AdNetworkExtras.Type)? {
        return GoogleMobileAds.CustomEventExtras.self
    }
    
    private static func setUpWith(_ configuration: MediationServerConfiguration,
                                  completionHandler: GADMediationAdapterSetUpCompletionBlock) {
        NSLog("%@: setUpWith",TAG)
        // This is where you you will initialize the SDK that this custom event is built for.
        // Upon finishing the SDK initialization, call the completion handler with success.
        
        if AlgorixAdmobBaseAdapter.isInitialized {
            let errorStr="The algorix sdk has been initialized"
            NSLog("%@: %@",AlgorixAdmobBaseAdapter.TAG,errorStr)
            completionHandler(NSError(domain: errorStr, code: -100))
            return
        }
        
        for items in configuration.credentials {
            let result = AlgorixAdmobBaseAdapter.initSdk(for: items.settings)
            if result.success {
                completionHandler(nil)
                return
            }
        }
        completionHandler(nil)
    }
    
    
    required public override init() {
        super.init()
        NSLog("%@: init",AlgorixAdmobBaseAdapter.TAG)
    }
    
    // MARK: - parase parameter
    public static func parseAdparameter(for parameters: MediationCredentials)-> [String:Any]?{
        guard let params:String = parameters.settings[AlgorixAdmobBaseAdapter.PARAMETER] as? String else{
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: %@",AlgorixAdmobBaseAdapter.TAG,errorStr)
            return nil
        }
        
        guard let data = params.data(using: .utf8) else{
            NSLog("%@: parameter: Data obj is nil", AlgorixAdmobBaseAdapter.TAG)
            return nil
        }
        do{
            let json = try JSONSerialization.jsonObject(with: data,options: []) as! [String:Any]
            return json
        }catch{
            NSLog("%@: parameter parse error: %@", AlgorixAdmobBaseAdapter.TAG,error.localizedDescription)
        }
        return nil
    }
    
    
    // MARK: - SDK init
    @discardableResult
    public static func initSdk(for parameters: [String:Any]?)->(success:Bool,error:String){
        guard let parameters = parameters else{
            let errorStr="initialize alx params is empty"
            NSLog("%@: error: %@",AlgorixAdmobBaseAdapter.TAG,errorStr)
            return (success:false,error:errorStr)
        }
        
        let appid = parameters["appid"] as? String
        let sid = parameters["sid"] as? String
        let token = parameters["token"] as? String
        let debug:String? = parameters["isdebug"] as? String
        
        guard let appid=appid,let sid=sid,let token=token else{
            let errorStr="initialize alx params: appid or sid or token is empty"
            NSLog("%@: error: %@",AlgorixAdmobBaseAdapter.TAG,errorStr)
            return (success:false,error:errorStr)
        }
        
        NSLog("%@: token=%@; appid=%@; sid=%@",AlgorixAdmobBaseAdapter.TAG,token,appid,sid)
        AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
        AlgorixAdmobBaseAdapter.isInitialized = true
        sdkInfo()
        
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
        // tcf v2 consent
        if gdprFlag == 1{
            AlxSdk.setGDPRConsent(true)
        }else  {
            AlxSdk.setGDPRConsent(false)
        }
        AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
        
        return (success:true,error:"ok")
    }
    
    
    
    private static func sdkInfo(){
        var data:[String:String] = [:]
        data["sdk_name"] = "Admob"
        data["sdk_version"] = string(for: MobileAds.shared.versionNumber)
        data["adapter_version"] = AlgorixAdmobMetaInf.ADAPTER_VERSION
        AlxSdk.addExtraParameters(key:"alx_adapter",value:data)
    }
    
    public func error(code:Int,msg:String) -> NSError{
        return NSError(domain: "AlgorixAdmobAdapter", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
    }
    
    

}
