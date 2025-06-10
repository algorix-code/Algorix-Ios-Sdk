//
//  AlxNativeAdView.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import UIKit

@IBDesignable
@objc public class AlxNativeAdView: AlxBaseNativeAdView {
    
    @objc public override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    @objc public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc @IBOutlet public var titleView:UIView? {
        get {
            return mViews["1"]
        }
        set {
            mViews["1"] = newValue
        }
    }
    
    @objc @IBOutlet public var descriptionView:UIView? {
        get {
            return mViews["2"]
        }
        set {
            mViews["2"] = newValue
        }
    }
    
    @objc @IBOutlet public var callToActionView:UIView? {
        get {
            return mViews["3"]
        }
        set {
            mViews["3"] = newValue
        }
    }
    
    @objc @IBOutlet public var iconView:UIView? {
        get {
            return mViews["4"]
        }
        set {
            mViews["4"] = newValue
        }
    }
    
    @objc @IBOutlet public var imageView:UIView? {
        get {
            return mViews["5"]
        }
        set {
            mViews["5"] = newValue
        }
    }
    
    @objc @IBOutlet public var priceView:UIView? {
        get {
            return mViews["6"]
        }
        set {
            mViews["6"] = newValue
        }
    }
    
    @objc @IBOutlet public var adSourceView:UIView? {
        get {
            return mViews["7"]
        }
        set {
            mViews["7"] = newValue
        }
    }
    
    @objc @IBOutlet public var mediaView:AlxMediaView?{
        get {
            return mMediaView
        }
        set {
            mMediaView = newValue
        }
    }
    
    @objc @IBOutlet public var closeView:UIView?{
        get {
            return mCloseView
        }
        set {
            mCloseView = newValue
        }
    }
    
    /**
     * 将View添加到点击事件中，关闭按钮就不在此添加
     *
     * @param key
     * @param value
     */
    @objc public func addAdView(key:String,view:UIView){
        mViews[key] = view
    }
    
    @objc public var nativeAd: AlxNativeAd? {
        get {
            super.getNativeAdData()
        }
        set {
            super.setNativeAdData(newValue)
        }
    }
    
    @objc public override func destroy(){
        super.destroy()
    }

}
