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
        
        let vStack=UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(vStack)
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .top
        
        let bnAlgorix=createButton(title: NSLocalizedString("algorix_ad", comment: ""), action: #selector(bnAlgorix))
        vStack.addArrangedSubview(bnAlgorix)
        
        
        NSLayoutConstraint.activate([
            vStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            vStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            
            bnAlgorix.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            bnAlgorix.heightAnchor.constraint(equalToConstant: 50),
            
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
    
    

}
