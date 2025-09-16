//
//  AlgorixTopOnBannerAdapter.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/19.
//

import Foundation
import AnyThinkSDK
import AnyThinkBanner
import AlxAds

@objc(AlgorixTopOnBannerAdapter)
public class AlgorixTopOnBannerAdapter: ATAdAdapter {
    
    private static let TAG = "AlgorixTopOnBannerAdapter"
    
    private var bannerAd:AlxBannerAdView? = nil
    private var customEvent:AlgorixTopOnBannerEvent? = nil
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                        localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlgorixTopOnBannerAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlgorixTopOnBannerAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
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
        NSLog("%@: loadAD",AlgorixTopOnBannerAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlgorixTopOnBannerAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        
        let bidId:String? = serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
        NSLog("%@: loadAD: bidId=%@",AlgorixTopOnBannerAdapter.TAG,bidId ?? "空")
        
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlgorixTopOnBannerAdapter.TAG,bidId ?? "")
            
            guard let unitId = serverInfo[AlgorixTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlgorixTopOnBannerAdapter.TAG,errorStr)
                completion(nil,AlgorixTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            
            NSLog("%@: loadAD: unitid=%@",AlgorixTopOnBannerAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlgorixTopOnBiddingRequest? = AlgorixTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlgorixTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlgorixTopOnBannerEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.bannerAd = request.customObject as? AlxBannerAdView
                    //判断广告源是否已经loaded过
                    if let bannerAd = self.bannerAd {
                        self.customEvent?.trackBannerAdLoaded(bannerAd, adExtra: nil)
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlgorixTopOnBannerAdapter.TAG)
                    }
                }
                AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                
                self.customEvent = AlgorixTopOnBannerEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // 提取广告尺寸信息
                var adSize = CGSize(width: 320, height: 50)
                let unitGroupModel:ATUnitGroupModel? = serverInfo[kATAdapterCustomInfoUnitGroupModelKey] as? ATUnitGroupModel
                if let unitGroupModel = unitGroupModel {
                    adSize = unitGroupModel.adSize
                    NSLog("%@: loadAD: width=%.2f , height=%.2f",AlgorixTopOnBannerAdapter.TAG,adSize.width,adSize.height)
                }
                
                // load ad
                self.bannerAd=AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
                self.bannerAd?.delegate = self.customEvent
                self.bannerAd?.refreshInterval = 0
                self.bannerAd?.translatesAutoresizingMaskIntoConstraints = false
                self.bannerAd?.loadAd(adUnitId: unitId)
            }
        }
        
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlgorixTopOnBannerAdapter.TAG)
        
        DispatchQueue.main.async {
            if !AlgorixTopOnBaseManager.isInitialized {
                AlgorixTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlgorixTopOnBannerEvent = AlgorixTopOnBannerEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlgorixTopOnBiddingRequest = AlgorixTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlgorixTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.banner,
            bidCompletion: completion
        )
        AlgorixTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    
    // MARK: - 广告就绪检查
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        // 检查广告是否就绪
        // 实际实现中应根据广告网络的具体方法进行检查
        NSLog("%@: adReady",AlgorixTopOnBannerAdapter.TAG)
        if customObject as? AlxBannerAdView != nil {
            NSLog("%@: adReady true",AlgorixTopOnBannerAdapter.TAG)
            return true
        }else{
            NSLog("%@: adReady false",AlgorixTopOnBannerAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示
    @objc(showBanner:inView:presentingViewController:)
    public static func showBanner(_ banner: ATBanner, in view: UIView, presenting viewController: UIViewController) {
        // 清空容器视图
        NSLog("%@: showBanner",AlgorixTopOnBannerAdapter.TAG)
        guard let bannerView = (banner.customObject as? AlxBannerAdView) else {
            NSLog("%@: showBanner banner is nil",AlgorixTopOnBannerAdapter.TAG)
            return
        }
        bannerView.rootViewController = viewController
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(bannerView)
    }
    
}
