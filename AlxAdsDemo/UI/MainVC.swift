//
//  MainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class MainVC: BaseUIViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("ad_list", comment: "")
        
        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        
        let contentView=UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 10
        contentView.alignment = .top
        
        let bnAlgorix=createButton(title: NSLocalizedString("algorix_ad", comment: ""), action: #selector(bnAlgorix))
        contentView.addArrangedSubview(bnAlgorix)
        
        let bnMax=createButton(title: NSLocalizedString("max_ad", comment: ""), action: #selector(bnMax))
        contentView.addArrangedSubview(bnMax)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            bnAlgorix.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnAlgorix.heightAnchor.constraint(equalToConstant: 50),
            
            bnMax.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnMax.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
            self.requestATTPermission()
        }
        
    }
    
    func requestATTPermission() {
        if #available(iOS 14, *) {
            print("requestATTPermission")
            ATTrackingManager.requestTrackingAuthorization{ status in
                // 处理授权结果
                UserDefaults.standard.set(true, forKey: "hasRequestedTrackingAuthorization")
                
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                print("idfa:", idfa)
            }
        } else {
            //you got permission to track, iOS 14 is not yet installed
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("idfa:", idfa)
        }
    }
    
    @objc func bnAlgorix(){
        self.navigationController?.pushViewController(AlgorixMainVC(), animated: false)
    }
    
    @objc func bnMax(){
        self.navigationController?.pushViewController(MaxMainVC(), animated: false)
    }
    
    

}
