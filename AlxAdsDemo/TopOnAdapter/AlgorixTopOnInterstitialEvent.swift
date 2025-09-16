//
//  AlgorixTopOnInterstitialEvent.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/21.
//

import Foundation
import AnyThinkSDK
import AnyThinkInterstitial
import AlxAds

@objc(AlgorixTopOnInterstitialEvent)
public class AlgorixTopOnInterstitialEvent: ATInterstitialCustomEvent,AlxInterstitialAdDelegate {
    
    private static let TAG = "AlgorixTopOnInterstitialEvent"
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad",AlgorixTopOnInterstitialEvent.TAG)
        if self.isC2SBiding {
            AlgorixTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String)
            self.isC2SBiding = false
        }else{
            self.trackInterstitialAdLoaded(ad, adExtra: nil)
        }
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad : %@",AlgorixTopOnInterstitialEvent.TAG,error.localizedDescription)
        if self.isC2SBiding {
            AlgorixTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String)
        }else{
            self.trackInterstitialAdLoadFailed(error)
        }
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression",AlgorixTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdShow()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick",AlgorixTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose",AlgorixTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdClose(nil)
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdRenderFail",AlgorixTopOnInterstitialEvent.TAG)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoStart",AlgorixTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdVideoStart()
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoEnd",AlgorixTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdVideoEnd()
    }
    
    public override var networkUnitId: String {
        get {
            return self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String ?? ""
        }
        set {
        }
    }
    
    deinit {
        NSLog("%@: deinit",AlgorixTopOnInterstitialEvent.TAG)
    }
    
}
