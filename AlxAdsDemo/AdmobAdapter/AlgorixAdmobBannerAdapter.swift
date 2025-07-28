//
//  AlgorixA.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/7/16.
//
import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlgorixAdmobBannerAdapter)
public class AlgorixAdmobBannerAdapter:AlgorixAdmobBaseAdapter,MediationBannerAd{
    
    private static let TAG = "AlgorixAdmobBannerAdapter"
    
    // Mark - Banner Ad
    private var bannerAd:AlxBannerAdView? = nil
    // The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    private var delegate:MediationBannerAdEventDelegate? = nil
    // Completion handler called after ad load
    private var completionHandler: GADMediationBannerLoadCompletionHandler? = nil
    
    public func loadBanner(for adConfiguration: MediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        NSLog("%@: loadBanner",AlgorixAdmobBannerAdapter.TAG)
        guard let params = AlgorixAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlgorixAdmobBannerAdapter.TAG)
            self.delegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        if !AlgorixAdmobBaseAdapter.isInitialized {
            AlgorixAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlgorixAdmobBannerAdapter.TAG,errorStr)
            self.delegate=completionHandler(nil,NSError(domain: errorStr, code: -100))
            return
        }
        
        self.completionHandler = completionHandler
        
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
}

extension AlgorixAdmobBannerAdapter:AlxBannerViewAdDelegate {
    
    
    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad",AlgorixAdmobBannerAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(self,nil)
        }
    }
    
    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        NSLog("%@: bannerViewAdFailToLoad: %@",AlgorixAdmobBannerAdapter.TAG,error.localizedDescription)
        if let handler=self.completionHandler{
            self.delegate=handler(self,error)
        }
    }
    
    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression",AlgorixAdmobBannerAdapter.TAG)
        self.delegate?.reportImpression()
    }
    
    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick",AlgorixAdmobBannerAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose",AlgorixAdmobBannerAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
    
    
}
