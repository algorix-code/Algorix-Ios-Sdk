//
//  AlgorixTopOnRewardVideoEvent.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/20.
//

import Foundation
import AnyThinkSDK
import AnyThinkRewardedVideo
import AlxAds

@objc(AlgorixTopOnRewardVideoEvent)
public class AlgorixTopOnRewardVideoEvent: ATRewardedVideoCustomEvent,AlxRewardVideoAdDelegate {
    
    private static let TAG = "AlgorixTopOnRewardVideoEvent"
    
    private var isRewarded:Bool = false
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad",AlgorixTopOnRewardVideoEvent.TAG)
        if self.isC2SBiding {
            AlgorixTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String)
            self.isC2SBiding = false
        }else{
            self.trackRewardedVideoAdLoaded(ad, adExtra: nil)
        }
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdFailToLoad",AlgorixTopOnRewardVideoEvent.TAG)
        if self.isC2SBiding {
            AlgorixTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String)
        }else{
            self.trackRewardedVideoAdLoadFailed(error)
        }
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression",AlgorixTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdShow()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick",AlgorixTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose",AlgorixTopOnRewardVideoEvent.TAG)
        let closeType:ATAdCloseType = .unknow
        self.trackRewardedVideoAdCloseRewarded(isRewarded, extra: [kATADDelegateExtraDismissTypeKey:closeType])
    }
    
    public func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart",AlgorixTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdVideoStart()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd",AlgorixTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdVideoEnd()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward",AlgorixTopOnRewardVideoEvent.TAG)
        self.isRewarded = true
        self.trackRewardedVideoAdRewarded()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail",AlgorixTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdPlayWithError(error)
    }
    
    public override var networkUnitId: String {
        get {
            return self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String ?? ""
        }
        set {
        }
    }
    
    deinit {
        NSLog("%@: deinit",AlgorixTopOnRewardVideoEvent.TAG)
    }
    
}
