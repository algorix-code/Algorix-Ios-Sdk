//
//  AlgorixMaxMediationAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/6/18.
//

import Foundation
import AlxAds
import AppLovinSDK


@objc(AlgorixMaxMediationAdapter)
public class AlgorixMaxMediationAdapter: ALMediationAdapter,MASignalProvider,MAAdViewAdapter,MARewardedAdapter,MAInterstitialAdapter,MANativeAdAdapter {
    
    private static let TAG = "AlgorixMaxMediationAdapter"
    private static let ADAPTER_VERSION = "1.3.0"
    
    private var bannerAd:AlxBannerAdView? = nil
    private var bannerAdDelegate:MAAdViewAdapterDelegate? = nil
    
    private var interstitialAd: AlxInterstitialAd? = nil
    private var interstitialAdDelegate: MAInterstitialAdapterDelegate? = nil
    
    private var rewardedAd: AlxRewardVideoAd? = nil
    private var rewardedAdDelegate: MARewardedAdapterDelegate? = nil
    
    private var nativeAdDelegate:MANativeAdAdapterDelegate? = nil
    private var nativeAd:AlxNativeAd? = nil
    private var nativeParameters:MAAdapterResponseParameters? = nil
    
    private static var isInitialized:Bool = false
    
    public func collectSignal(with parameters: any MASignalCollectionParameters, andNotify delegate: any MASignalCollectionDelegate) {
        NSLog("%@: collectSignal",AlgorixMaxMediationAdapter.TAG)
    }
    
    
    public override func initialize(with parameters: MAAdapterInitializationParameters, completionHandler: @escaping (MAAdapterInitializationStatus, String?) -> Void) {
        NSLog("%@: initialize",AlgorixMaxMediationAdapter.TAG)
        NSLog("%@: max-sdk-version:%@",AlgorixMaxMediationAdapter.TAG,ALSdk.version())
        NSLog("%@: alx-max-adapter-version:%@",AlgorixMaxMediationAdapter.TAG,AlgorixMaxMediationAdapter.ADAPTER_VERSION)
        if initSdk(for: parameters) {
            completionHandler(.initializedSuccess,nil)
        }else{
            completionHandler(.doesNotApply,nil)
        }
    }
    
    //banner load
    public func loadAdViewAd(for parameters: any MAAdapterResponseParameters, adFormat: MAAdFormat, andNotify delegate: any MAAdViewAdapterDelegate) {
        NSLog("%@: loadAdViewAd",AlgorixMaxMediationAdapter.TAG)
        if !AlgorixMaxMediationAdapter.isInitialized {
            initSdk(for: parameters)
        }
        let adId=parameters.thirdPartyAdPlacementIdentifier
        let viewController = parameters.presentingViewController ?? ALUtils.topViewControllerFromKeyWindow()
        
        self.bannerAdDelegate = delegate
        
        let adSize = CGSize(width: adFormat.adaptiveSize.width, height: adFormat.adaptiveSize.height)
        self.bannerAd=AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
        self.bannerAd?.delegate = self
        self.bannerAd?.refreshInterval = 0
        self.bannerAd?.rootViewController=viewController
        self.bannerAd?.loadAd(adUnitId: adId)
    }
    
    public func loadRewardedAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MARewardedAdapterDelegate) {
        NSLog("%@: loadRewardedAd",AlgorixMaxMediationAdapter.TAG)
        if !AlgorixMaxMediationAdapter.isInitialized {
            initSdk(for: parameters)
        }
        let adId=parameters.thirdPartyAdPlacementIdentifier
        
        self.rewardedAdDelegate=delegate
        
        self.rewardedAd=AlxRewardVideoAd()
        self.rewardedAd?.delegate = self
        self.rewardedAd?.loadAd(adUnitId: adId)
    }
    
    public func showRewardedAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MARewardedAdapterDelegate) {
        NSLog("%@: showRewardedAd",AlgorixMaxMediationAdapter.TAG)
        let viewController:UIViewController=parameters.presentingViewController ?? ALUtils.topViewControllerFromKeyWindow()
        if let rewardedAd = rewardedAd,rewardedAd.isReady() {
            rewardedAd.showAd(present: viewController)
        }else{
            NSLog("%@: show reward is empty",AlgorixMaxMediationAdapter.TAG)
        }
    }
    
    public func loadInterstitialAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MAInterstitialAdapterDelegate) {
        NSLog("%@: loadInterstitialAd",AlgorixMaxMediationAdapter.TAG)
        if !AlgorixMaxMediationAdapter.isInitialized {
            initSdk(for: parameters)
        }
        let adId=parameters.thirdPartyAdPlacementIdentifier
        
        self.interstitialAdDelegate=delegate
        
        self.interstitialAd=AlxInterstitialAd()
        self.interstitialAd?.delegate = self
        self.interstitialAd?.loadAd(adUnitId: adId)
    }
    
    public func showInterstitialAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MAInterstitialAdapterDelegate) {
        NSLog("%@: showInterstitialAd",AlgorixMaxMediationAdapter.TAG)
        let viewController:UIViewController=parameters.presentingViewController ?? ALUtils.topViewControllerFromKeyWindow()
        if let interstitial = interstitialAd, interstitial.isReady() {
            interstitial.showAd(present: viewController)
        }else{
            NSLog("%@: show interstitial is empty",AlgorixMaxMediationAdapter.TAG)
        }
    }
    
    public func loadNativeAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MANativeAdAdapterDelegate) {
        NSLog("%@: loadNativeAd",AlgorixMaxMediationAdapter.TAG)
        if !AlgorixMaxMediationAdapter.isInitialized {
            initSdk(for: parameters)
        }
        let adId=parameters.thirdPartyAdPlacementIdentifier
        self.nativeParameters = parameters
        //        let templateName = parameters.serverParameters["template"] as? String ?? ""
        
        self.nativeAdDelegate=delegate
        let loader=AlxNativeAdLoader(adUnitID: adId)
        loader.delegate = self
        loader.loadAd()
    }
    
    public override func destroy() {
        NSLog("%@: destroy",AlgorixMaxMediationAdapter.TAG)
        bannerAd = nil
        bannerAdDelegate = nil
        
        interstitialAd = nil
        interstitialAdDelegate = nil
        
        rewardedAd = nil
        rewardedAdDelegate = nil
        
        nativeAdDelegate = nil
        nativeAd = nil
        nativeParameters = nil
        super.destroy()
    }
    
    public override var sdkVersion:String{
        NSLog("%@: sdkVersion",AlgorixMaxMediationAdapter.TAG)
        return AlxSdk.getSDKVersion()
    }
    
    public override var adapterVersion:String{
        NSLog("%@: adapterVersion",AlgorixMaxMediationAdapter.TAG)
        return AlgorixMaxMediationAdapter.ADAPTER_VERSION
    }
    
    private func sdkInfo(){
        var data:[String:String] = [:]
        data["sdk_name"] = "Max"
        data["sdk_version"] = ALSdk.version()
        data["adapter_version"] = AlgorixMaxMediationAdapter.ADAPTER_VERSION
        AlxSdk.addExtraParameters(key:"alx_adapter",value:data)
    }
    
    
    @discardableResult
    private func initSdk(for parameters: any MAAdapterParameters)->Bool{
        let params=parameters.customParameters
        let appid:String?=params["appid"] as? String
        let sid:String?=params["sid"] as? String
        let token:String?=params["token"] as? String
        let debug:String?=params["isdebug"] as? String
        
        guard let appid=appid,let sid=sid,let token=token else{
            let errorStr="initialize alx params: appid or sid or token is empty"
            NSLog("%@: error: %@",AlgorixMaxMediationAdapter.TAG,errorStr)
            return false
        }
        
        NSLog("%@: token=%@; appid=%@; sid=%@",AlgorixMaxMediationAdapter.TAG,token,appid,sid)
        AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
        AlgorixMaxMediationAdapter.isInitialized = true
        self.sdkInfo()
        
        if let debug,!debug.isEmpty {
            if debug.lowercased() == "true" {
                AlxSdk.setDebug(true)
            }else if debug.lowercased() == "false" {
                AlxSdk.setDebug(false)
            }
        }
        
        
        //set extra params
        let settings = ALSdk.shared().settings.extraParameters
        for (key, value) in settings {
            NSLog("%@: max extra parameters: key= %@,value=%@",AlgorixMaxMediationAdapter.TAG,key,value)
            AlxSdk.addExtraParameters(key: key, value: value)
        }
        
        // User Privacy
        // MARK: - GDPR Consent Handling
        let gdprFlag = UserDefaults.standard.integer(forKey: "IABTCF_gdprApplies")
        let gdprConsent = UserDefaults.standard.string(forKey: "IABTCF_TCString")
        // tcf v2 consent
        if gdprFlag == 1{
            AlxSdk.setGDPRConsent(true)
            AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
        }else  {
            // max setting
            if ALPrivacySettings.hasUserConsent() {
                AlxSdk.setGDPRConsent(true)
                if let consentString = parameters.consentString {
                    AlxSdk.setGDPRConsentMessage(consentString)
                } else if let gdprConsent {
                    // Directly use String-type consent (e.g., IAB TCF consent string)
                    AlxSdk.setGDPRConsentMessage(gdprConsent)
                }
            }else{
                AlxSdk.setGDPRConsent(false)
                AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
            }
        }
        
        // MARK: - CCPA Handling (US Privacy)
        AlxSdk.setCCPA(ALPrivacySettings.isDoNotSell() ? "1" : "0")
        
        return true
    }
    
    
    class MaxAlxNativeAd:MANativeAd{
        var nativeAd:AlxNativeAd?=nil
        
        public init(nativeAd: AlxNativeAd) {
            self.nativeAd = nativeAd
            super.init(format: .native){ builder in
                builder.title = nativeAd.title
                builder.body = nativeAd.desc
                builder.callToAction = nativeAd.callToAction
                builder.advertiser = nativeAd.adSource
                
                if let iconUrlString = nativeAd.icon?.url {
                    if let iconUrl = URL(string: iconUrlString) {
                        builder.icon = MANativeAdImage(url: iconUrl)
                    }
                }
                
                
                if let mediaContent = nativeAd.mediaContent {
                    let mediaView = AlxMediaView()
                    mediaView.setMediaContent(mediaContent)
                    builder.mediaView = mediaView
                }
                
                
                let mainImage:AlxNativeAdImage? = nativeAd.images?.first
                if let imageUrlString = mainImage?.url {
                    if let imageUrl = URL(string: imageUrlString) {
                        builder.mainImage = MANativeAdImage(url: imageUrl)
                    }
                }
                
            }
        }
        
        override func prepare(forInteractionClickableViews clickableViews: [UIView], withContainer container: UIView) -> Bool {
            self.nativeAd?.registerView(container: container, clickableViews: clickableViews)
            return super.prepare(forInteractionClickableViews: clickableViews, withContainer: container)
        }
    }
    
}

extension AlgorixMaxMediationAdapter:AlxBannerViewAdDelegate {
    
    
    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad",AlgorixMaxMediationAdapter.TAG)
        self.bannerAdDelegate?.didLoadAd(forAdView: bannerView)
    }
    
    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        NSLog("%@: bannerViewAdFailToLoad: %@",AlgorixMaxMediationAdapter.TAG,error.localizedDescription)
        let error1=MAAdapterError(code: error.code, errorString: error.localizedDescription)
        self.bannerAdDelegate?.didFailToLoadAdViewAdWithError(error1)
    }
    
    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression",AlgorixMaxMediationAdapter.TAG)
        self.bannerAdDelegate?.didDisplayAdViewAd()
    }
    
    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick",AlgorixMaxMediationAdapter.TAG)
        self.bannerAdDelegate?.didClickAdViewAd()
    }
    
    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose",AlgorixMaxMediationAdapter.TAG)
        self.bannerAdDelegate?.didHideAdViewAd()
    }
    
    
}

extension AlgorixMaxMediationAdapter:AlxInterstitialAdDelegate {
    
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad",AlgorixMaxMediationAdapter.TAG)
        self.interstitialAdDelegate?.didLoadInterstitialAd()
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad : %@",AlgorixMaxMediationAdapter.TAG,error.localizedDescription)
        let error1=MAAdapterError(code: error.code, errorString: error.localizedDescription)
        self.interstitialAdDelegate?.didFailToLoadInterstitialAdWithError(error1)
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression",AlgorixMaxMediationAdapter.TAG)
        self.interstitialAdDelegate?.didDisplayInterstitialAd()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick",AlgorixMaxMediationAdapter.TAG)
        self.interstitialAdDelegate?.didClickInterstitialAd()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose",AlgorixMaxMediationAdapter.TAG)
        self.interstitialAdDelegate?.didHideInterstitialAd()
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdRenderFail",AlgorixMaxMediationAdapter.TAG)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoStart",AlgorixMaxMediationAdapter.TAG)
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoEnd",AlgorixMaxMediationAdapter.TAG)
    }
    
}


extension AlgorixMaxMediationAdapter:AlxRewardVideoAdDelegate{
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad",AlgorixMaxMediationAdapter.TAG)
        self.rewardedAdDelegate?.didLoadRewardedAd()
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdLoad",AlgorixMaxMediationAdapter.TAG)
        let error1=MAAdapterError(code: error.code, errorString: error.localizedDescription)
        self.rewardedAdDelegate?.didFailToLoadRewardedAdWithError(error1)
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression",AlgorixMaxMediationAdapter.TAG)
        self.rewardedAdDelegate?.didDisplayRewardedAd()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick",AlgorixMaxMediationAdapter.TAG)
        self.rewardedAdDelegate?.didClickRewardedAd()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose",AlgorixMaxMediationAdapter.TAG)
        self.rewardedAdDelegate?.didHideRewardedAd()
    }
    
    public func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart",AlgorixMaxMediationAdapter.TAG)
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd",AlgorixMaxMediationAdapter.TAG)
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward",AlgorixMaxMediationAdapter.TAG)
        self.rewardedAdDelegate?.didRewardUser(with: MAReward.init())
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail",AlgorixMaxMediationAdapter.TAG)
    }
    
    
    
}


extension AlgorixMaxMediationAdapter:AlxNativeAdLoaderDelegate{
    
    public func nativeAdLoaded(didReceive ads: [AlxNativeAd]) {
        NSLog("%@: nativeAdLoaded",AlgorixMaxMediationAdapter.TAG)
        
        guard let nativeAd = ads.first else{
            self.nativeAdDelegate?.didFailToLoadNativeAdWithError(MAAdapterError.noFill)
            return
        }
        self.nativeAd = nativeAd
        
        let maxNativeAd = MaxAlxNativeAd(nativeAd: nativeAd)
        //                let templateName = self.nativeParameters?.serverParameters["template"] as? String ?? ""
        let viewController:UIViewController = self.nativeParameters?.presentingViewController ?? ALUtils.topViewControllerFromKeyWindow()
        
        nativeAd.delegate = self
        nativeAd.rootViewController = viewController
        self.nativeAdDelegate?.didLoadAd(for: maxNativeAd, withExtraInfo: nil)
    }
    
    public func nativeAdFailToLoad(didFailWithError error: Error) {
        NSLog("%@: nativeAdFailToLoad",AlgorixMaxMediationAdapter.TAG)
        let error1=MAAdapterError(code: error.code, errorString: error.localizedDescription)
        self.nativeAdDelegate?.didFailToLoadNativeAdWithError(error1)
    }
    
    
}

extension AlgorixMaxMediationAdapter:AlxNativeAdDelegate{
    public func nativeAdImpression(_ nativeAd:AlxNativeAd){
        NSLog("%@: nativeAdImpression",AlgorixMaxMediationAdapter.TAG)
        self.nativeAdDelegate?.didDisplayNativeAd(withExtraInfo: nil)
    }
    
    public func nativeAdClick(_ nativeAd:AlxNativeAd){
        NSLog("%@: nativeAdClick",AlgorixMaxMediationAdapter.TAG)
        self.nativeAdDelegate?.didClickNativeAd()
    }
    
    public func nativeAdClose(_ nativeAd:AlxNativeAd){
        NSLog("%@: nativeAdClose",AlgorixMaxMediationAdapter.TAG)
    }
}
