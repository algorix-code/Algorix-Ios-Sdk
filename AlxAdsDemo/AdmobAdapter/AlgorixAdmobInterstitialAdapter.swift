//
//  AlgorixAdmobInterstitialAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/7/16.
//
import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlgorixAdmobInterstitialAdapter)
public class AlgorixAdmobInterstitialAdapter: AlgorixAdmobBaseAdapter,MediationInterstitialAd {
    
    private static let TAG = "AlgorixAdmobInterstitialAdapter"
    
    private var interstitialAd: AlxInterstitialAd? = nil
    private var delegate: MediationInterstitialAdEventDelegate? = nil
    private var completionHandler: GADMediationInterstitialLoadCompletionHandler? = nil
    
    public func loadInterstitial(for adConfiguration: MediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        NSLog("%@: loadRewardedAd",AlgorixAdmobInterstitialAdapter.TAG)
        guard let params = AlgorixAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlgorixAdmobInterstitialAdapter.TAG)
            self.delegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        if !AlgorixAdmobBaseAdapter.isInitialized {
            AlgorixAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlgorixAdmobInterstitialAdapter.TAG,errorStr)
            self.delegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        self.completionHandler = completionHandler
        
        // load ad
        self.interstitialAd=AlxInterstitialAd()
        self.interstitialAd?.delegate = self
        self.interstitialAd?.loadAd(adUnitId: adId)
    }
    
    public func present(from viewController: UIViewController) {
        NSLog("%@: present",AlgorixAdmobInterstitialAdapter.TAG)
        
        if let interstitialAd = self.interstitialAd,interstitialAd.isReady(){
            interstitialAd.showAd(present: viewController)
        }
    }
    
}

extension AlgorixAdmobInterstitialAdapter:AlxInterstitialAdDelegate {
    
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad",AlgorixAdmobInterstitialAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(self,nil)
        }
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad : %@",AlgorixAdmobInterstitialAdapter.TAG,error.localizedDescription)
        if let handler=self.completionHandler{
            self.delegate=handler(nil,error)
        }
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression",AlgorixAdmobInterstitialAdapter.TAG)
        self.delegate?.reportImpression()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick",AlgorixAdmobInterstitialAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose",AlgorixAdmobInterstitialAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdRenderFail",AlgorixAdmobInterstitialAdapter.TAG)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoStart",AlgorixAdmobInterstitialAdapter.TAG)
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoEnd",AlgorixAdmobInterstitialAdapter.TAG)
    }
    
}
