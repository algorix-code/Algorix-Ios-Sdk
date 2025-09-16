//
//  AlgorixTopOnBannerEvent.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/20.
//

import Foundation
import AnyThinkSDK
import AnyThinkBanner
import AlxAds

@objc(AlgorixTopOnBannerEvent)
public class AlgorixTopOnBannerEvent: ATBannerCustomEvent,AlxBannerViewAdDelegate {
    
    private static let TAG = "AlgorixTopOnBannerEvent"
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad",AlgorixTopOnBannerEvent.TAG)
        if self.isC2SBiding {
            AlgorixTopOnBiddingRequestManager.disposeLoadSuccess(price: bannerView.getPrice(), unitID: self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String)
            self.isC2SBiding = false
        }else{
            self.trackBannerAdLoaded(bannerView, adExtra: nil)
        }
    }
    
    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        NSLog("%@: bannerViewAdFailToLoad: %@",AlgorixTopOnBannerEvent.TAG,error.localizedDescription)
        if self.isC2SBiding {
            AlgorixTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String)
        }else{
            self.trackBannerAdLoadFailed(error)
        }
    }
    
    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression",AlgorixTopOnBannerEvent.TAG)
        self.trackBannerAdImpression()
    }
    
    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick",AlgorixTopOnBannerEvent.TAG)
        self.trackBannerAdClick()
    }
    
    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose",AlgorixTopOnBannerEvent.TAG)
        self.trackBannerAdClosed()
    }
    
    public override var networkUnitId: String {
        get {
            return self.serverInfo[AlgorixTopOnBaseManager.unitID] as? String ?? ""
        }
        set {
        }
    }
}
