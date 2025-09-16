//
//  AlgorixTopOnBiddingRequestManager.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/27.
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlgorixTopOnBiddingRequestManager)
public class AlgorixTopOnBiddingRequestManager:NSObject {
    
    private static let TAG = "AlgorixTopOnBiddingRequestManager"
    
    // MARK: - 单例
    static let shared = AlgorixTopOnBiddingRequestManager()
   
    private override init() {
       super.init()
    }
   
    // MARK: - 启动竞价请求
    func start(with request: AlgorixTopOnBiddingRequest) {
       DispatchQueue.main.async {
           switch request.adType {
               case .interstitial:
                   self.startLoadInterstitialAd(with: request)
               case .rewardedVideo:
                   self.startLoadRewardedVideoAd(with: request)
               case .native:
                   self.startLoadNativeAd(with: request)
               case .banner:
                   self.startLoadBannerAd(with: request)
               default:
                   break
           }
       }
    }
    
    private func startLoadInterstitialAd(with request:AlgorixTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadInterstitialAd: error= %@",AlgorixTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadInterstitialAd: unitid=%@",AlgorixTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlgorixTopOnInterstitialEvent else{
            NSLog("%@: startLoadInterstitialAd: customEvent is empty",AlgorixTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // load ad
        let interstitialAd = AlxInterstitialAd()
        interstitialAd.delegate = customEvent
        
        // 缓存
        request.customObject = interstitialAd
        AlgorixTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        interstitialAd.loadAd(adUnitId: unitID)
    }
    
    private func startLoadRewardedVideoAd(with request:AlgorixTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadRewardedVideoAd: error= %@",AlgorixTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadRewardedVideoAd: unitid=%@",AlgorixTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlgorixTopOnRewardVideoEvent else{
            NSLog("%@: startLoadRewardedVideoAd: customEvent is empty",AlgorixTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // load ad
        let rewardedAd = AlxRewardVideoAd()
        rewardedAd.delegate = customEvent
        
        // 缓存
        request.customObject = rewardedAd
        AlgorixTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        rewardedAd.loadAd(adUnitId: unitID)
    }
    
    private func startLoadNativeAd(with request:AlgorixTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadNativeAd: error= %@",AlgorixTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadNativeAd: unitid=%@",AlgorixTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlgorixTopOnNativeEvent else{
            NSLog("%@: startLoadNativeAd: customEvent is empty",AlgorixTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // load ad
        let nativeAd = AlxNativeAdLoader(adUnitID: unitID)
        nativeAd.delegate = customEvent
        
        // 缓存
        request.customObject = nativeAd
        AlgorixTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        nativeAd.loadAd()
    }
    
    private func startLoadBannerAd(with request:AlgorixTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadBannerAd: error= %@",AlgorixTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadBannerAd: unitid=%@",AlgorixTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlgorixTopOnBannerEvent else{
            NSLog("%@: startLoadBannerAd: customEvent is empty",AlgorixTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // 提取广告尺寸信息
        var adSize = CGSize(width: 320, height: 50)
        let unitGroupModel:ATUnitGroupModel? = request.extraInfo[kATAdapterCustomInfoUnitGroupModelKey] as? ATUnitGroupModel
        if let unitGroupModel = unitGroupModel {
            adSize = unitGroupModel.adSize
            NSLog("%@: loadAD: width=%.2f , height=%.2f",AlgorixTopOnBiddingRequestManager.TAG,adSize.width,adSize.height)
        }
        
        // load ad
        let bannerAd = AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
        bannerAd.delegate = customEvent
        bannerAd.refreshInterval = 0
        bannerAd.translatesAutoresizingMaskIntoConstraints = false
        
        // 缓存
        request.customObject = bannerAd
        AlgorixTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        bannerAd.loadAd(adUnitId: unitID)
    }
    
    /// 竞价成功回调
    public static func disposeLoadSuccess(price: Double, unitID: String?) {
        NSLog("%@: disposeLoadSuccess",AlgorixTopOnBiddingRequestManager.TAG)
        let priceStr = String(price)
        
        guard let unitID = unitID else {
            NSLog("%@: disposeLoadSuccess: unitID is empty",AlgorixTopOnBiddingRequestManager.TAG)
            return
        }

        guard let bidRequest=AlgorixTopOnTool.shared.getRequestItem(withUnitID: unitID) as? AlgorixTopOnBiddingRequest else {
            NSLog("%@: disposeLoadSuccess: bidRequest cache no found",AlgorixTopOnBiddingRequestManager.TAG)
           return
        }
        
        guard let placementID = bidRequest.placementID else {
            bidRequest.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "placementID is empty"))
            AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitID)
            return
        }
        
        guard let unitGroupUnitID = bidRequest.unitGroup.unitID else {
            bidRequest.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "ATUnitGroupModel object: unitID is empty"))
            AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitID)
            return
        }
        
        guard let adapterClassString = bidRequest.unitGroup.adapterClassString else {
            bidRequest.bidCompletion?(nil,AlgorixTopOnBaseManager.error(code: -100, msg: "ATUnitGroupModel object: adapterClassString is empty"))
            AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitID)
            return
        }
        
        let bidInfo:ATBidInfo = ATBidInfo(c2SWithPlacementID: placementID, unitGroupUnitID: unitGroupUnitID, adapterClassString: adapterClassString, price: priceStr, currencyType: ATBiddingCurrencyType.US, expirationInterval: bidRequest.unitGroup.bidTokenTime, customObject: bidRequest.customObject)
        bidInfo.networkFirmID = bidRequest.unitGroup.networkFirmID
      
        print("AlgorixTopOnBiddingRequestManager: disposeLoadSuccess: price=\(bidInfo.price)")
        print("AlgorixTopOnBiddingRequestManager: disposeLoadSuccess: adapterClassString=\(bidInfo.adapterClassString)")
        print("AlgorixTopOnBiddingRequestManager: disposeLoadSuccess: bidTokenTime=\(bidInfo.expireDate)")
        
        if bidRequest.bidCompletion != nil {
            bidRequest.bidCompletion?(bidInfo, nil)
            NSLog("%@: disposeLoadSuccess: bidCompletion is called successfully",AlgorixTopOnBiddingRequestManager.TAG)
        }else{
            NSLog("%@: disposeLoadSuccess: bidCompletion is empty",AlgorixTopOnBiddingRequestManager.TAG)
        }
//        bidRequest.bidCompletion?(bidInfo, nil)
    }

    /// 竞价失败回调
    public static func disposeLoadFail(error: Error, unitID: String?) {
        NSLog("%@: disposeLoadFail",AlgorixTopOnBiddingRequestManager.TAG)
        guard let unitID = unitID else {
            NSLog("%@: disposeLoadFail: unitID is empty",AlgorixTopOnBiddingRequestManager.TAG)
            return
        }

        guard let bidRequest=AlgorixTopOnTool.shared.getRequestItem(withUnitID: unitID) as? AlgorixTopOnBiddingRequest else {
            NSLog("%@: disposeLoadFail: bidRequest cache no found",AlgorixTopOnBiddingRequestManager.TAG)
           return
        }
        bidRequest.bidCompletion?(nil,error)
        AlgorixTopOnTool.shared.removeRequestItem(withUnitID: unitID)
    }
}
