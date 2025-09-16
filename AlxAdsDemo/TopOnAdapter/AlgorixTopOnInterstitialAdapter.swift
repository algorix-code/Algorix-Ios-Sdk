//
//  AlgorixTopOnInterstitialAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/21.
//

import Foundation
import AnyThinkSDK
import AnyThinkInterstitial
import AlxAds

@objc(AlgorixTopOnInterstitialAdapter)
public class AlgorixTopOnInterstitialAdapter: ATAdAdapter {
    
    private static let TAG = "AlgorixTopOnInterstitialAdapter"
    
    private var interstitialAd: AlxInterstitialAd? = nil
    private var customEvent:AlgorixTopOnInterstitialEvent? = nil
    
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                        localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlgorixTopOnInterstitialAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlgorixTopOnInterstitialAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
        }
    }
    
    /// 加载广告
    @objc public func loadAD(withInfo serverInfo: [AnyHashable: Any],
                             localInfo: [AnyHashable: Any],
                             completion: @escaping ([[AnyHashable: Any]]?, (any Error)?) -> Void) {
        NSLog("%@: loadAD",AlgorixTopOnInterstitialAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlgorixTopOnInterstitialAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
       
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlgorixTopOnInterstitialAdapter.TAG,bidId ?? "")
            
            guard let unitId = serverInfo[AlgorixTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlgorixTopOnInterstitialAdapter.TAG,errorStr)
                completion(nil,AlgorixTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            NSLog("%@: loadAD: unitid=%@",AlgorixTopOnInterstitialAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlgorixTopOnBiddingRequest? = AlgorixTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlgorixTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlgorixTopOnInterstitialEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.interstitialAd = request.customObject as? AlxInterstitialAd
                    //判断广告源是否已经loaded过
                    if let interstitialAd = self.interstitialAd {
                        self.customEvent?.trackInterstitialAdLoaded(interstitialAd, adExtra: nil)
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlgorixTopOnInterstitialAdapter.TAG)
                    }
                }
                AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                self.customEvent = AlgorixTopOnInterstitialEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // load ad
                self.interstitialAd = AlxInterstitialAd()
                self.interstitialAd?.delegate = self.customEvent
                self.interstitialAd?.loadAd(adUnitId: unitId)
            }
        }
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlgorixTopOnInterstitialAdapter.TAG)
        NSLog("%@: bidRequestWithPlacementModel: isMainThread=%@",AlgorixTopOnInterstitialAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlgorixTopOnInterstitialEvent = AlgorixTopOnInterstitialEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlgorixTopOnBiddingRequest = AlgorixTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlgorixTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.interstitial,
            bidCompletion: completion
        )
        AlgorixTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    @objc(loadWithServerInfo:localInfo:)
    public func loadWithServerInfo(_ serverInfo:[AnyHashable: Any],localInfo:[AnyHashable: Any]){
        NSLog("%@: loadWithServerInfo",AlgorixTopOnInterstitialAdapter.TAG)
    }
    
    
    // MARK: - 广告就绪检查
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        // 检查广告是否就绪
        // 实际实现中应根据广告网络的具体方法进行检查
        NSLog("%@: adReady",AlgorixTopOnInterstitialAdapter.TAG)
        if customObject as? AlxInterstitialAd != nil {
            NSLog("%@: adReady true",AlgorixTopOnInterstitialAdapter.TAG)
            return true
        }else{
            NSLog("%@: adReady false",AlgorixTopOnInterstitialAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示
    @objc(showInterstitial:inViewController:delegate:)
    public static func showInterstitial(_ interstitial: ATInterstitial,
                                       in viewController: UIViewController,
                                       delegate: ATInterstitialDelegate) {
        NSLog("%@: showInterstitial",AlgorixTopOnInterstitialAdapter.TAG)
        guard let interstitialAd = (interstitial.customObject as? AlxInterstitialAd) else {
            NSLog("%@: showInterstitial: interstitialAd object is nil",AlgorixTopOnInterstitialAdapter.TAG)
            return
        }
        interstitial.customEvent.delegate = delegate
        if interstitialAd.isReady() {
            interstitialAd.showAd(present: viewController)
        }
    }
}
