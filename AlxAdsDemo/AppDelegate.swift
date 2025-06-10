//
//  AppDelegate.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/28.
//

import UIKit
import AlxAds


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initAds()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func initAds(){
        AlxSdk.initializeSDK(token: AdConfig.Alx_Token, sid: AdConfig.Alx_Sid, appId: AdConfig.Alx_App_Id)
        AlxSdk.setDebug(true)
        //用户扩展参数
        AlxSdk.addExtraParameters(key:"uid2_token",value:"NewAdvertisingTokenIjb6u6KcMAt=")
    }


}
