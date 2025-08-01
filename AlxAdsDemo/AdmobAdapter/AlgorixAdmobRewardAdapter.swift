//
//  AlgorixAdmobRewardAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/7/14.
//

import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlgorixAdmobRewardAdapter)
public class AlgorixAdmobRewardAdapter:AlgorixAdmobBaseAdapter,MediationRewardedAd {
    
    private static let TAG = "AlgorixAdmobRewardAdapter"
    
    private var rewardedAd: AlxRewardVideoAd? = nil
    private var delegate: MediationRewardedAdEventDelegate? = nil
    private var completionHandler: GADMediationRewardedLoadCompletionHandler? = nil
   
    public func loadRewardedAd(for adConfiguration: MediationRewardedAdConfiguration, completionHandler: @escaping GADMediationRewardedLoadCompletionHandler) {
        NSLog("%@: loadRewardedAd",AlgorixAdmobRewardAdapter.TAG)
        guard let params = AlgorixAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlgorixAdmobRewardAdapter.TAG)
            self.delegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        if !AlgorixAdmobBaseAdapter.isInitialized {
            AlgorixAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlgorixAdmobRewardAdapter.TAG,errorStr)
            self.delegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        NSLog("%@: loadRewardedAd unitid=%@",AlgorixAdmobRewardAdapter.TAG,adId)
        self.completionHandler = completionHandler
        
        // load ad
        self.rewardedAd = AlxRewardVideoAd()
        self.rewardedAd?.delegate = self
        self.rewardedAd?.loadAd(adUnitId: adId)
    }
    
    public func present(from viewController: UIViewController) {
        NSLog("%@: present",AlgorixAdmobRewardAdapter.TAG)
        if let rewardedAd = self.rewardedAd,rewardedAd.isReady(){
            rewardedAd.showAd(present: viewController)
        }
    }
    
}

extension AlgorixAdmobRewardAdapter:AlxRewardVideoAdDelegate{
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad",AlgorixAdmobRewardAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(self,nil)
        }
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdLoad",AlgorixAdmobRewardAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(nil,error)
        }
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression",AlgorixAdmobRewardAdapter.TAG)
        self.delegate?.willPresentFullScreenView()
        self.delegate?.reportImpression()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick",AlgorixAdmobRewardAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose",AlgorixAdmobRewardAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
    
    public func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart",AlgorixAdmobRewardAdapter.TAG)
        self.delegate?.didStartVideo()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd",AlgorixAdmobRewardAdapter.TAG)
        self.delegate?.didEndVideo()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward",AlgorixAdmobRewardAdapter.TAG)
        self.delegate?.didRewardUser()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail",AlgorixAdmobRewardAdapter.TAG)
    }
    
}
