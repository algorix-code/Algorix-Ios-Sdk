//
//  AlgorixAdmobMediationAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/7/14.
//

import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlgorixAdmobMediationAdapter)
public class AlgorixAdmobMediationAdapter: NSObject, MediationAdapter,MediationRewardedAd,MediationBannerAd,MediationInterstitialAd,MediationNativeAd {
        
    private static let TAG = "AlgorixAdmobMediationAdapter"
    private static let ADAPTER_VERSION = "1.1.0"
    private static let PARAMETER = "parameter"
    
    private static var isInitialized:Bool = false
    
    // Mark - Banner Ad
    private var bannerAd:AlxBannerAdView? = nil
    // The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    private var bannerAdDelegate:MediationBannerAdEventDelegate? = nil
    // Completion handler called after ad load
    private var bannerAdCompletionHandler: GADMediationBannerLoadCompletionHandler? = nil
    
    
    // Mark - Rewarded Video Ad
    private var rewardedAd: AlxRewardVideoAd? = nil
    private var rewardedAdDelegate: MediationRewardedAdEventDelegate? = nil
    private var rewardedAdCompletionHandler: GADMediationRewardedLoadCompletionHandler? = nil
    
    // Mark - Interstitial Ad
    private var interstitialAd: AlxInterstitialAd? = nil
    private var interstitialAdDelegate: MediationInterstitialAdEventDelegate? = nil
    private var interstitialAdCompletionHandler: GADMediationInterstitialLoadCompletionHandler? = nil
    
    
    // Mark - Native Ad
    private var nativeAdDelegate:MediationNativeAdEventDelegate? = nil
    private var nativeAd:AlxNativeAd? = nil
    private var nativeAdCompletionHandler: GADMediationNativeLoadCompletionHandler? = nil
    
    
    static public func adapterVersion() -> VersionNumber {
        let versionComponents = String(AlgorixAdmobMediationAdapter.ADAPTER_VERSION).components(
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
        
        if AlgorixAdmobMediationAdapter.isInitialized {
            let errorStr="The algorix sdk has been initialized"
            NSLog("%@: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            completionHandler(NSError(domain: errorStr, code: -100))
            return
        }
        
        for items in configuration.credentials {
            let result = AlgorixAdmobMediationAdapter.initSdk(for: items.settings)
            if result.success {
                completionHandler(nil)
                return
            }
        }
        completionHandler(nil)
    }
    
    
    required public override init() {
        super.init()
        NSLog("%@: init",AlgorixAdmobMediationAdapter.TAG)
    }
    
    
    // MARK: - Rewarded Ad load
    public func loadRewardedAd(for adConfiguration: MediationRewardedAdConfiguration, completionHandler: @escaping GADMediationRewardedLoadCompletionHandler) {
        NSLog("%@: loadRewardedAd",AlgorixAdmobMediationAdapter.TAG)
        guard let params = AlgorixAdmobMediationAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlgorixAdmobMediationAdapter.TAG)
            self.rewardedAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        if !AlgorixAdmobMediationAdapter.isInitialized {
            AlgorixAdmobMediationAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            self.rewardedAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        self.rewardedAdCompletionHandler = completionHandler
        
        // load ad
        rewardedAd = AlxRewardVideoAd()
        rewardedAd?.delegate = self
        rewardedAd?.loadAd(adUnitId: adId)
    }
    
    
    // MARK: - Rewarded Ad show  or  Invalid Ad show
    public func present(from viewController: UIViewController) {
        NSLog("%@: present",AlgorixAdmobMediationAdapter.TAG)
        
        //
        if let rewardedAd = self.rewardedAd,rewardedAd.isReady(){
            rewardedAd.showAd(present: viewController)
        }
        
        if let interstitialAd = self.interstitialAd,interstitialAd.isReady(){
            interstitialAd.showAd(present: viewController)
        }
    }
    
    // MARK: - Banner Ad
    public func loadBanner(for adConfiguration: MediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        NSLog("%@: loadBannerAd",AlgorixAdmobMediationAdapter.TAG)
        guard let params = AlgorixAdmobMediationAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlgorixAdmobMediationAdapter.TAG)
            self.bannerAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        if !AlgorixAdmobMediationAdapter.isInitialized {
            AlgorixAdmobMediationAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            self.bannerAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        self.bannerAdCompletionHandler = completionHandler
        
        // load ad
        let adSize = CGSize(width: adConfiguration.adSize.size.width, height: adConfiguration.adSize.size.height)
        self.bannerAd=AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
        self.bannerAd?.delegate = self
        self.bannerAd?.rootViewController=adConfiguration.topViewController
        self.bannerAd?.loadAd(adUnitId: adId)
    }
    
    
    public var view: UIView {
        return bannerAd ?? UIView()
    }
    
    
    // MARk - Interstitial Ad
    public func loadInterstitial(for adConfiguration: MediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        NSLog("%@: loadInterstitial",AlgorixAdmobMediationAdapter.TAG)
        guard let params = AlgorixAdmobMediationAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlgorixAdmobMediationAdapter.TAG)
            self.interstitialAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        if !AlgorixAdmobMediationAdapter.isInitialized {
            AlgorixAdmobMediationAdapter.initSdk(for: params)
        } 
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            self.interstitialAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        self.interstitialAdCompletionHandler = completionHandler
        
        // load ad
        self.interstitialAd=AlxInterstitialAd()
        self.interstitialAd?.delegate = self
        self.interstitialAd?.loadAd(adUnitId: adId)
    }
    
    // MARK: - Native Ad
    public func loadNativeAd(for adConfiguration: MediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        NSLog("%@: loadNativeAd",AlgorixAdmobMediationAdapter.TAG)
        guard let params = AlgorixAdmobMediationAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlgorixAdmobMediationAdapter.TAG)
            self.nativeAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        if !AlgorixAdmobMediationAdapter.isInitialized {
            AlgorixAdmobMediationAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            self.nativeAdDelegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        self.nativeAdCompletionHandler = completionHandler
        
        // load ad
        
    }
    
    public var headline: String?
    
    public var images: [NativeAdImage]?
    
    public var body: String?
    
    public var icon: NativeAdImage?
    
    public var callToAction: String?
    
    public var starRating: NSDecimalNumber?
    
    public var store: String?
    
    public var price: String?
    
    public var advertiser: String?
    
    public var extraAssets: [String : Any]?
    
    
    
    // MARK: - parase parameter
    private static func parseAdparameter(for parameters: MediationCredentials)-> [String:Any]?{
        guard let params:String = parameters.settings[AlgorixAdmobMediationAdapter.PARAMETER] as? String else{
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            return nil
        }
        
        guard let data = params.data(using: .utf8) else{
            NSLog("%@: parameter: Data obj is nil", AlgorixAdmobMediationAdapter.TAG)
            return nil
        }
        do{
            let json = try JSONSerialization.jsonObject(with: data,options: []) as! [String:Any]
            return json
        }catch{
            NSLog("%@: parameter parse error: %@", AlgorixAdmobMediationAdapter.TAG,error.localizedDescription)
        }
        return nil
    }
    
    
    // MARK: - SDK init
    @discardableResult
    private static func initSdk(for parameters: [String:Any]?)->(success:Bool,error:String){
        guard let parameters = parameters else{
            let errorStr="initialize alx params is empty"
            NSLog("%@: error: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            return (success:false,error:errorStr)
        }
        
        let appid = parameters["appid"] as? String
        let sid = parameters["sid"] as? String
        let token = parameters["token"] as? String
        let debug:String? = parameters["isdebug"] as? String
        
        guard let appid=appid,let sid=sid,let token=token else{
            let errorStr="initialize alx params: appid or sid or token is empty"
            NSLog("%@: error: %@",AlgorixAdmobMediationAdapter.TAG,errorStr)
            return (success:false,error:errorStr)
        }
        
        NSLog("%@: token=%@; appid=%@; sid=%@",AlgorixAdmobMediationAdapter.TAG,token,appid,sid)
        AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
        AlgorixAdmobMediationAdapter.isInitialized = true
        sdkInfo()
        
        if let debug,!debug.isEmpty {
            if debug.lowercased() == "true" {
                AlxSdk.setDebug(true)
            }else if debug.lowercased() == "false" {
                AlxSdk.setDebug(false)
            }
        }
        
        
        //set extra params
        //        let settings = ALSdk.shared().settings.extraParameters
        //        for (key, value) in settings {
        //            NSLog("%@: max extra parameters: key= %@,value=%@",AlgorixAdmobMediationAdapter.TAG,key,value)
        //            AlxSdk.addExtraParameters(key: key, value: value)
        //        }
        
        // User Privacy
        // MARK: - GDPR Consent Handling
        let gdprFlag = UserDefaults.standard.integer(forKey: "IABTCF_gdprApplies")
        let gdprConsent = UserDefaults.standard.string(forKey: "IABTCF_TCString")
        // tcf v2 consent
        if gdprFlag == 1{
            AlxSdk.setGDPRConsent(true)
            AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
        }else  {
            AlxSdk.setGDPRConsent(false)
            AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
        }
        
        // MARK: - CCPA Handling (US Privacy)
        //        AlxSdk.setCCPA(ALPrivacySettings.isDoNotSell() ? "1" : "0")
        
        return (success:true,error:"ok")
    }
    
    
    
    private static func sdkInfo(){
        var data:[String:String] = [:]
        data["sdk_name"] = "Admob"
        data["sdk_version"] = string(for: MobileAds.shared.versionNumber)
        data["adapter_version"] = AlgorixAdmobMetaInf.ADAPTER_VERSION
        AlxSdk.addExtraParameters(key:"alx_adapter",value:data)
    }
    
}


extension AlgorixAdmobMediationAdapter:AlxRewardVideoAdDelegate{
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad",AlgorixAdmobMediationAdapter.TAG)
        if let handler=self.rewardedAdCompletionHandler{
            self.rewardedAdDelegate=handler(self,nil)
        }
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdLoad",AlgorixAdmobMediationAdapter.TAG)
        if let handler=self.rewardedAdCompletionHandler{
            self.rewardedAdDelegate=handler(nil,error)
        }
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression",AlgorixAdmobMediationAdapter.TAG)
        self.rewardedAdDelegate?.reportImpression()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick",AlgorixAdmobMediationAdapter.TAG)
        self.rewardedAdDelegate?.reportClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose",AlgorixAdmobMediationAdapter.TAG)
        self.rewardedAdDelegate?.didDismissFullScreenView()
    }
    
    public func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart",AlgorixAdmobMediationAdapter.TAG)
        self.rewardedAdDelegate?.didStartVideo()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd",AlgorixAdmobMediationAdapter.TAG)
        self.rewardedAdDelegate?.didEndVideo()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward",AlgorixAdmobMediationAdapter.TAG)
        self.rewardedAdDelegate?.didRewardUser()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail",AlgorixAdmobMediationAdapter.TAG)
    }
    
}

extension AlgorixAdmobMediationAdapter:AlxBannerViewAdDelegate {
    
    
    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad",AlgorixAdmobMediationAdapter.TAG)
        if let handler=self.bannerAdCompletionHandler{
            self.bannerAdDelegate=handler(self,nil)
        }
    }
    
    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        NSLog("%@: bannerViewAdFailToLoad: %@",AlgorixAdmobMediationAdapter.TAG,error.localizedDescription)
        if let handler=self.bannerAdCompletionHandler{
            self.bannerAdDelegate=handler(self,error)
        }
    }
    
    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression",AlgorixAdmobMediationAdapter.TAG)
        self.bannerAdDelegate?.reportImpression()
    }
    
    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick",AlgorixAdmobMediationAdapter.TAG)
        self.bannerAdDelegate?.reportClick()
    }
    
    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose",AlgorixAdmobMediationAdapter.TAG)
        self.bannerAdDelegate?.didDismissFullScreenView()
    }
    
    
}

extension AlgorixAdmobMediationAdapter:AlxInterstitialAdDelegate {
    
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad",AlgorixAdmobMediationAdapter.TAG)
        if let handler=self.interstitialAdCompletionHandler{
            self.interstitialAdDelegate=handler(self,nil)
        }
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad : %@",AlgorixAdmobMediationAdapter.TAG,error.localizedDescription)
        if let handler=self.interstitialAdCompletionHandler{
            self.interstitialAdDelegate=handler(nil,error)
        }
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression",AlgorixAdmobMediationAdapter.TAG)
        self.interstitialAdDelegate?.reportImpression()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick",AlgorixAdmobMediationAdapter.TAG)
        self.interstitialAdDelegate?.reportClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose",AlgorixAdmobMediationAdapter.TAG)
        self.interstitialAdDelegate?.didDismissFullScreenView()
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdRenderFail",AlgorixAdmobMediationAdapter.TAG)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoStart",AlgorixAdmobMediationAdapter.TAG)
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoEnd",AlgorixAdmobMediationAdapter.TAG)
    }
    
}
