//
//  AlgorixBannerVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AlxAds

class AlgorixBannerVC: BaseUIViewController{

    private var label:UILabel!
    
    private var isLoading:Bool=false
    
    private var bannerView:AlxBannerAdView!
    
    private var adContainer:UIView!
    private var bannerView2:AlxBannerAdView?=nil
    private var isBanner2=false


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("algorix_banner", comment: "")

        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2100) //必须设置，否则不能滚动
//        scrollView.contentSize = view.frame.size
        
        
        let vStack=UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(vStack)
        vStack.axis = .vertical
        vStack.spacing = 20
        
        
        let tip1=createLabel()
        vStack.addArrangedSubview(tip1)
        tip1.text = NSLocalizedString("banner_ad_preload", comment: "")
        tip1.contentMode = .center
        
        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(preloadAd))
        vStack.addArrangedSubview(bnLoad)
        
        let bnShow=createButton(title: NSLocalizedString("show_ad", comment: ""),  action: #selector(showAd))
        vStack.addArrangedSubview(bnShow)
        
        label=createLabel()
        vStack.addArrangedSubview(label)
        
        adContainer=UIView()
        adContainer.translatesAutoresizingMaskIntoConstraints=false
        vStack.addArrangedSubview(adContainer)
        
        let tip2=createLabel()
        vStack.addArrangedSubview(tip2)
        tip2.text = NSLocalizedString("banner_ad", comment: "")
        tip2.contentMode = .center
        
        let bnLoadAndShow=createButton(title: NSLocalizedString("load_and_show_ad", comment: ""),  action: #selector(loadAndShowAd))
        vStack.addArrangedSubview(bnLoadAndShow)
        
        bannerView=AlxBannerAdView()
        bannerView.translatesAutoresizingMaskIntoConstraints=false
        vStack.addArrangedSubview(bannerView)
        
        for index in 1...30 {
            let test=createLabel()
            vStack.addArrangedSubview(test)
            test.text = "\(index) Banner test title ad. use swift development"
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 20),
            vStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
                        
            bnLoad.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),
            
            bnShow.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            bnShow.heightAnchor.constraint(equalToConstant: 50),
            
            label.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            bnLoadAndShow.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            bnLoadAndShow.heightAnchor.constraint(equalToConstant: 50),
            
            adContainer.widthAnchor.constraint(equalTo: vStack.widthAnchor),
//            adContainer.heightAnchor.constraint(equalToConstant: 50),
            
            bannerView.widthAnchor.constraint(equalTo: vStack.widthAnchor),
//            bannerView.heightAnchor.constraint(equalToConstant: 100),        
        ])
        
    }
    
    @objc func preloadAd(){
        isBanner2=true
        if isLoading {
            return
        }
        isLoading=true
        label.text=NSLocalizedString("loading", comment: "")
        
        bannerView2=AlxBannerAdView()
        bannerView2?.translatesAutoresizingMaskIntoConstraints = false
        bannerView2?.refreshInterval = 0
        bannerView2?.delegate=self
        bannerView2?.rootViewController=self
        bannerView2?.loadAd(adUnitId: AdConfig.Alx_Banner_Ad_Id)
    }
    
    @objc func showAd(){
        if isLoading == true{
            print(NSLocalizedString("show_ad_no_load", comment: ""))
            return
        }
        
        guard let bannerView = bannerView2,bannerView.isReady() else{
            return
        }
        clearSubView(adContainer)
        adContainer.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: adContainer.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
            bannerView.widthAnchor.constraint(equalTo: adContainer.widthAnchor),
        ])
    }
    
    @objc func loadAndShowAd(){
        isBanner2=false
        
        bannerView.delegate=self
        bannerView.rootViewController=self
        bannerView.isHideClose = false
        bannerView.loadAd(adUnitId: AdConfig.Alx_Banner_Ad_Id)
    }

}

extension AlgorixBannerVC:AlxBannerViewAdDelegate {
    
    
    func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdLoad。 price: \(bannerView.getPrice())")
        bannerView.reportBiddingUrl()
        bannerView.reportChargingUrl()
        if isBanner2{
            self.isLoading=false
            self.label.text=NSLocalizedString("load_success", comment: "")
        }
    }
    
    func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        let error1=error as NSError
        let msg="\(error1.code): \(error1.localizedDescription)"
        print("bannerViewAdFailToLoad: \(msg)")
        if isBanner2 {
            self.isLoading=false
            self.label.text=String(format: NSLocalizedString("load_failed", comment: ""), msg)
        }
    }
    
    func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdImpression")
    }
    
    func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdClick")
    }
    
    func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdClose")
        if isBanner2{
            clearSubView(adContainer)
        }
    }
    
    
}
