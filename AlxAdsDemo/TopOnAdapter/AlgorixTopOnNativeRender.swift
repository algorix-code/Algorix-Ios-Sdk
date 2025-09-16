//
//  AlgorixTopOnNativeRender.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/22.
//

import Foundation
import AnyThinkSDK
import AnyThinkNative
import AlxAds

@objc(AlgorixTopOnNativeRender)
public class AlgorixTopOnNativeRender: ATNativeRenderer {
    
    private static let TAG = "AlgorixTopOnNativeRender"
    
    private weak var customEvent: AlgorixTopOnNativeEvent? = nil
    private var nativeAd:AlxNativeAd? = nil
    
    @objc public override init(configuraton configuration: ATNativeADConfiguration, adView: ATNativeADView) {
        super.init(configuraton: configuration, adView: adView)
    }
    
    /// 将资源渲染到相关的广告视图上。
    /// 您可以根据广告平台的要求，做渲染之后再做一些注册点击事件的功能
    @objc public override func renderOffer(_ offer: ATNativeADCache) {
        super.renderOffer(offer)
        NSLog("%@: renderOffer",AlgorixTopOnNativeRender.TAG)
        
        self.customEvent = offer.assets[kATAdAssetsCustomEventKey] as? AlgorixTopOnNativeEvent
        self.customEvent?.adView = self.adView
        if let customEvent = self.customEvent {
            NSLog("%@: renderOffer: customEvent",AlgorixTopOnNativeRender.TAG)
            self.adView?.customEvent = customEvent
        }
        
        self.nativeAd = offer.assets[kATAdAssetsCustomObjectKey] as? AlxNativeAd
        if let nativeAd = self.nativeAd,let adView = self.adView {
            NSLog("%@: renderOffer: nativeAd",AlgorixTopOnNativeRender.TAG)
            nativeAd.rootViewController = self.configuration.rootViewController
            nativeAd.delegate = self.customEvent
            nativeAd.registerView(container: adView, clickableViews: adView.clickableViews())
        }
    }
    
    @objc public override func getNetWorkMediaView() -> UIView {
        NSLog("%@: getNetWorkMediaView",AlgorixTopOnNativeRender.TAG)
        let offer:ATNativeADCache? = self.adView?.nativeAd as? ATNativeADCache
        if let nativeAd = offer?.assets[kATAdAssetsCustomObjectKey] as? AlxNativeAd, let mediaContent = nativeAd.mediaContent{
            NSLog("%@: getNetWorkMediaView: add mediaview",AlgorixTopOnNativeRender.TAG)
            let mediaView = AlxMediaView(frame: self.configuration.mediaViewFrame)
            mediaView.setMediaContent(mediaContent)
            return mediaView
        }
        return UIView()
    }
    
    @objc public override func getCurrentNativeAdRenderType() -> ATNativeAdRenderType{
        NSLog("%@: getCurrentNativeAdRenderType",AlgorixTopOnNativeRender.TAG)
        return .selfRender
    }
    
    
    deinit {
        NSLog("%@: deinit",AlgorixTopOnNativeRender.TAG)
        self.nativeAd?.unregisterView()
    }
    
}
