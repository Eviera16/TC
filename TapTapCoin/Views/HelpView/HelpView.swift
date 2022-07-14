//
//  HelpView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct HelpView: View {
    @AppStorage("session") var logged_in_user: String?
//    @AppStorage("in_game") var in_game: Bool?
//    @StateObject private var viewModel = LoadingGameViewModel()
    
    var body: some View {
            ScrollView{
                Text("Help")
                    .font(.system(size: UIScreen.main.bounds.width * 0.15))
                    .foregroundColor(Color(.red))
                    .fontWeight(.bold)
                VideoView(video: "Video 1")
                VideoView(video: "Video 2")
                ComingSoonView()
            }
            .background(Color(.yellow))
    }
    
}
