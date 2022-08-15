//
//  TapTapCoinApp.swift
//  TapTapCoin
//
//  Created by Eric Viera on 3/27/22.
//

import SwiftUI
import GoogleMobileAds

@main
struct TapTapCoinApp: App {
    init(){
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
