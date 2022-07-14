//
//  ComingSoon.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct ComingSoonView: View {
    @AppStorage("session") var logged_in_user: String?
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
                    List{
                        Text("Update 1")
                        Text("Update 2")
                        Text("Update 3")
                        Text("Update 4")
                        Text("Update 5")
                    }
                    Spacer()
                }
                .frame(height: UIScreen.main.bounds.height)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        
    }
}
