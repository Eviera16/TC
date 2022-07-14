//
//  VideoView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct VideoView: View {
    @AppStorage("session") var logged_in_user: String?
    let video:String?
//    @AppStorage("in_game") var in_game: Bool?
//    @StateObject private var viewModel = LoadingGameViewModel()
    
    var body: some View {
        ZStack{
            Color(.yellow)
                .ignoresSafeArea()
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Text(video ?? "No video")
                    Spacer()
                }
                .frame(height: UIScreen.main.bounds.height)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        
    }
}
