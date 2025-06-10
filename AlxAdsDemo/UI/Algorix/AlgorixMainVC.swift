//
//  AlgorixMainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

class AlgorixMainVC: BaseUIViewController {

    var bnBanner:UIButton!
    var bnBannerXib:UIButton!
    var bnReward:UIButton!
    var bnInterstitial:UIButton!
    var bnInterstitialBanner:UIButton!
    var bnNative:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("algorix_ad", comment: "")


        bnBanner=createButton(title: NSLocalizedString("banner_ad", comment: ""), action: #selector(buttonBanner))
        view.addSubview(bnBanner)
        
        bnBannerXib=createButton(title: NSLocalizedString("banner_ad_xib", comment: ""), action: #selector(buttonBannerXib))
        view.addSubview(bnBannerXib)

        bnReward=createButton(title: NSLocalizedString("rewardVideo_ad", comment: ""), action: #selector(buttonReward))
        view.addSubview(bnReward)

        bnInterstitial=createButton(title: NSLocalizedString("interstitial_ad", comment: ""), action: #selector(buttonInterstitial))
        view.addSubview(bnInterstitial)
        
        bnInterstitialBanner=createButton(title: NSLocalizedString("interstitial_banner_ad", comment: ""), action: #selector(buttonInterstitialBanner))
        view.addSubview(bnInterstitialBanner)

        bnNative=createButton(title: NSLocalizedString("native_ad", comment: ""), action: #selector(buttonNative))
        view.addSubview(bnNative)


        NSLayoutConstraint.activate([
            bnBanner.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnBanner.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnBanner.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnBanner.heightAnchor.constraint(equalToConstant: 50),
            bnBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            bnBannerXib.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnBannerXib.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnBannerXib.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnBannerXib.heightAnchor.constraint(equalToConstant: 50),
            bnBannerXib.topAnchor.constraint(equalTo: bnBanner.bottomAnchor, constant: 20),

            bnReward.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnReward.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnReward.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnReward.heightAnchor.constraint(equalToConstant: 50),
            bnReward.topAnchor.constraint(equalTo: bnBannerXib.bottomAnchor, constant: 20),

            bnInterstitial.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnInterstitial.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnInterstitial.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnInterstitial.heightAnchor.constraint(equalToConstant: 50),
            bnInterstitial.topAnchor.constraint(equalTo: bnReward.bottomAnchor, constant: 20),
            
            bnInterstitialBanner.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnInterstitialBanner.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnInterstitialBanner.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnInterstitialBanner.heightAnchor.constraint(equalToConstant: 50),
            bnInterstitialBanner.topAnchor.constraint(equalTo: bnInterstitial.bottomAnchor, constant: 20),

            bnNative.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnNative.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnNative.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnNative.heightAnchor.constraint(equalToConstant: 50),
            bnNative.topAnchor.constraint(equalTo: bnInterstitialBanner.bottomAnchor, constant: 20),
        ])
        
    }

    @objc func buttonBanner(){
        navigationController?.pushViewController(AlgorixBannerVC(), animated: false)
    }
    
    @objc func buttonBannerXib(){
        navigationController?.pushViewController(AlgorixBannerXibVC(), animated: false)
//        navigationController?.pushViewController(AlgorixBannerXibVC(nibName: "AlgorixBannerXibVC", bundle: nil), animated: false)
    }

    @objc func buttonReward(){
        navigationController?.pushViewController(AlgorixRewardVideoVC(), animated: false)
    }

    @objc func buttonInterstitial(){
        navigationController?.pushViewController(AlgorixInterstitialVC(), animated: false)
    }
    
    @objc func buttonInterstitialBanner(){
        navigationController?.pushViewController(AlgorixInterstitialBannerVC(), animated: false)
    }

    @objc func buttonNative(){
        navigationController?.pushViewController(AlgorixNativeVC(), animated: false)
    }





}
