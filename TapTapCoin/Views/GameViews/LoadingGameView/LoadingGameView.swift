//
//  LoadingGameView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct LoadingGameView: View {
    @StateObject private var viewModel = LoadingGameViewModel()
    
    var body: some View {
        ZStack{
            Color(.red)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                Spacer()
                Text(viewModel.loading_status)
                    .fontWeight(.bold)
                    .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.2)
                    .font(.system(size: UIScreen.main.bounds.width * 0.11))
                    .foregroundColor(Color(.yellow))
                Text(viewModel.queue_pop)
                    .fontWeight(.bold)
                    .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.15)
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .foregroundColor(Color(.yellow))
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(.yellow)))
                    .scaleEffect(4)
                BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
                Button(action: {
                    viewModel.return_home()
                }, label: {
                    Text("Home")
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                        .background(Color(.yellow))
                        .foregroundColor(Color(.red))
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                })
            }
            
        }
    }
    
}
