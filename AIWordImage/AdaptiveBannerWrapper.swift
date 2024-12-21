//
//  AdaptiveBannerWrapper.swift
//  AIWordImage
//
//  Created by えみり on 2024/12/16.
//

import SwiftUI

struct AdaptiveBannerWrapper : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> AdaptiveBannerViewController {
        let viewController = AdaptiveBannerViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AdaptiveBannerViewController, context: Context) {
        uiViewController.view.backgroundColor = .clear
    }
}
