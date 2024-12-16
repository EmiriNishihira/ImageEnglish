//
//  AdaptiveBannerViewController.swift
//  AIWordImage
//
//  Created by えみり on 2024/12/16.
//

import GoogleMobileAds
import UIKit

final class AdaptiveBannerViewController: UIViewController {
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
    }
    
    func loadAd() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        self.bannerView = GADBannerView(adSize: adaptiveSize)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "/21775744923/example/adaptive-banner"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
}

extension AdaptiveBannerViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Received ad")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Failed to receive ad with error: \(error)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("Impression recorded")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("Will present screen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("Will dismiss screen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("Did dismiss screen")
    }
    
    func bannerViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("Will leave application")
    }
}
