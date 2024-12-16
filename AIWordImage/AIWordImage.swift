//
//  ImageEnglishApp.swift
//  ImageEnglish
//
//  Created by えみり on 2024/12/14.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }
}

@main
struct ImageEnglishApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            VStack {
                ContentView()
               
                AdaptiveBannerWrapper()
                    .frame(maxWidth: .infinity, maxHeight: 70)
            }
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
        }
        .modelContainer(for: Item.self)
    }
}
