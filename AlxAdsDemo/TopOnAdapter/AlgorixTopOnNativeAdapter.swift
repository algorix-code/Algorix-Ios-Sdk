//
//  AlgorixTopOnNativeAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/21.
//

import Foundation
import AnyThinkSDK
import AnyThinkNative
import AlxAds

@objc(AlgorixTopOnNativeAdapter)
public class AlgorixTopOnNativeAdapter:ATAdAdapter {
    
    private static let TAG = "AlgorixTopOnNativeAdapter"
    
    private var nativeAd:AlxNativeAdLoader? = nil
    private var customEvent:AlgorixTopOnNativeEvent? = nil
    
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                               localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlgorixTopOnNativeAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlgorixTopOnNativeAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
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
        NSLog("%@: loadAD",AlgorixTopOnNativeAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlgorixTopOnNativeAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlgorixTopOnNativeAdapter.TAG,bidId ?? "")     
            
            guard let unitId = serverInfo[AlgorixTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlgorixTopOnNativeAdapter.TAG,errorStr)
                completion(nil,AlgorixTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            
            NSLog("%@: loadAD: unitid=%@",AlgorixTopOnNativeAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlgorixTopOnBiddingRequest? = AlgorixTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlgorixTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlgorixTopOnNativeEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.nativeAd = request.customObject as? AlxNativeAdLoader
                    //判断广告源是否已经loaded过
                    if let assets = self.customEvent?.assetDict {
                        NSLog("%@: loadAD: bid load success callback",AlgorixTopOnNativeAdapter.TAG)
                        self.customEvent?.trackNativeAdLoaded([assets])
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlgorixTopOnNativeAdapter.TAG)
                    }
                    self.customEvent?.assets.removeAllObjects()
                    self.customEvent?.assetDict = [:]
                }
                AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                
                self.customEvent = AlgorixTopOnNativeEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // load ad
                self.nativeAd = AlxNativeAdLoader(adUnitID: unitId)
                self.nativeAd?.delegate = self.customEvent
                self.nativeAd?.loadAd()
            }
        }
        
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlgorixTopOnNativeAdapter.TAG)
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlgorixTopOnNativeEvent = AlgorixTopOnNativeEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlgorixTopOnBiddingRequest = AlgorixTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlgorixTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.native,
            bidCompletion: completion
        )
        AlgorixTopOnBiddingRequestManager.shared.start(with: request)
    }
        
    // 实现 Objective-C 协议中的类方法: + (Class)rendererClass;
    @objc public static func rendererClass() -> AnyClass {
        NSLog("%@: rendererClass",AlgorixTopOnNativeAdapter.TAG)
        return AlgorixTopOnNativeRender.self
    }
    
}
