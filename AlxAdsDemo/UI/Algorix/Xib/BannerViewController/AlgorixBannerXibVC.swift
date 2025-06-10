//
//  AlgorixBannerXibVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/5/29.
//
import UIKit
import AlxAds

class AlgorixBannerXibVC: BaseUIViewController{
    @IBOutlet weak var bnLoadAndShow: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var bannerView: AlxBannerAdView!
    
    private var isLoading:Bool=false
    
    init() {
        super.init(nibName: "AlgorixBannerXibVC", bundle: nil)
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: "AlgorixBannerXibVC", bundle: nibBundleOrNil)
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("algorix_banner", comment: "")
        
        setupLayout()
    }
    
    private func setupLayout() {
        bnLoadAndShow.setTitle(NSLocalizedString("load_and_show_ad", comment: ""), for: .normal)
        bnLoadAndShow.setTitleColor(.white, for: .normal)
        bnLoadAndShow.backgroundColor = .darkGray
        bnLoadAndShow.accessibilityNavigationStyle = .automatic
        
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = .zero
        label.text = ""
    }
    
    
    @IBAction func bnLoadAndShow(_ sender: Any) {
        if isLoading {
            return
        }
        isLoading=true
        label.text=NSLocalizedString("loading", comment: "")
        
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.isHideClose = false
        bannerView.loadAd(adUnitId: AdConfig.Alx_Banner_Ad_Id)
    }
    
}

extension AlgorixBannerXibVC:AlxBannerViewAdDelegate {    
    
    func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdLoad。 price: \(bannerView.getPrice())")
        bannerView.reportBiddingUrl()
        bannerView.reportChargingUrl()        
        
        self.isLoading=false
        self.label.text=NSLocalizedString("load_success", comment: "")
    }
    
    func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        let error1=error as NSError
        let msg="\(error1.code): \(error1.localizedDescription)"
        print("bannerViewAdFailToLoad: \(msg)")
        
        self.isLoading=false
        self.label.text=String(format: NSLocalizedString("load_failed", comment: ""), msg)
    }
    
    func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdImpression")
    }
    
    func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdClick")
    }
    
    func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        print("bannerViewAdClose")
    }
    
    
}
