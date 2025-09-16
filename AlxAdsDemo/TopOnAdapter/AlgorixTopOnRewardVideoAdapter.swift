//
//  AlgorixTopOnRewardVideoAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/18.
//

import Foundation
import AnyThinkSDK
import AnyThinkRewardedVideo
import AlxAds

@objc(AlgorixTopOnRewardVideoAdapter)
public class AlgorixTopOnRewardVideoAdapter:ATAdAdapter {
    
    private static let TAG = "AlgorixTopOnRewardVideoAdapter"
    
    private var rewardedAd: AlxRewardVideoAd? = nil
    private var customEvent:AlgorixTopOnRewardVideoEvent? = nil
    
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                        localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlgorixTopOnRewardVideoAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlgorixTopOnRewardVideoAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
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
        NSLog("%@: loadAD",AlgorixTopOnRewardVideoAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlgorixTopOnRewardVideoAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
       
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlgorixTopOnRewardVideoAdapter.TAG,bidId ?? "")
            
            guard let unitId = serverInfo[AlgorixTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlgorixTopOnRewardVideoAdapter.TAG,errorStr)
                completion(nil,AlgorixTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            
            NSLog("%@: loadAD: unitid=%@",AlgorixTopOnRewardVideoAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlgorixTopOnBiddingRequest? = AlgorixTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlgorixTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlgorixTopOnRewardVideoEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.rewardedAd = request.customObject as? AlxRewardVideoAd
                    //判断广告源是否已经loaded过
                    if let rewardedAd = self.rewardedAd {
                        self.customEvent?.trackRewardedVideoAdLoaded(rewardedAd, adExtra: nil)
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlgorixTopOnRewardVideoAdapter.TAG)
                    }
                }
                AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                self.customEvent = AlgorixTopOnRewardVideoEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // load ad
                self.rewardedAd = AlxRewardVideoAd()
                self.rewardedAd?.delegate = self.customEvent
                self.rewardedAd?.loadAd(adUnitId: unitId)
            }
        }
       
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlgorixTopOnRewardVideoAdapter.TAG)
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlgorixTopOnRewardVideoEvent = AlgorixTopOnRewardVideoEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlgorixTopOnBiddingRequest = AlgorixTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlgorixTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.rewardedVideo,
            bidCompletion: completion
        )
        AlgorixTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    // MARK: - 广告就绪检查
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        // 检查广告是否就绪
        // 实际实现中应根据广告网络的具体方法进行检查
        NSLog("%@: adReady",AlgorixTopOnRewardVideoAdapter.TAG)
        if customObject as? AlxRewardVideoAd != nil {
            NSLog("%@: adReady true",AlgorixTopOnRewardVideoAdapter.TAG)
            return true
        }else{
            NSLog("%@: adReady false",AlgorixTopOnRewardVideoAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示
    @objc(showRewardedVideo:inViewController:delegate:)
    public static func showRewardedVideo(_ rewardedVideo: ATRewardedVideo,
                                       in viewController: UIViewController,
                                       delegate: ATRewardedVideoDelegate) {
        NSLog("%@: showRewardedVideo",AlgorixTopOnRewardVideoAdapter.TAG)
        guard let rewardAd = (rewardedVideo.customObject as? AlxRewardVideoAd) else {
            NSLog("%@: showRewardedVideo: rewardAd object is nil",AlgorixTopOnRewardVideoAdapter.TAG)
            return
        }
        rewardedVideo.customEvent.delegate = delegate
        if rewardAd.isReady() {
            rewardAd.showAd(present: viewController)
        }
    }
    
}
