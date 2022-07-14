//
//  PMenuView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct PMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("session") var logged_in_user: String?
    @StateObject private var viewModel = PMenuViewModel()
    
    var body: some View {
        ZStack{
            Color(.yellow)
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        print("PRESSING BACK BUTTON")
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Back")
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .fontWeight(.bold)
                            .foregroundColor(Color(.red))
                            .underline()
                    })
                    Spacer()
                }
                Text("Choose Difficulty")
                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                    .foregroundColor(Color(.red))
                    .fontWeight(.bold)
                Spacer()
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                    Button(action: {viewModel.got_difficulty(diff:"Easy")}, label: {
                        Text("Easy")
                            .fontWeight(.bold)
                            .foregroundColor(Color(.yellow))
                            .font(.system(size: UIScreen.main.bounds.width * 0.07))
                    })
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                        .background(Color(.red))
                        .cornerRadius(8)
                    Button(action: {viewModel.got_difficulty(diff:"Medium")}, label: {
                        Text("Medium")
                            .fontWeight(.bold)
                            .foregroundColor(Color(.yellow))
                            .font(.system(size: UIScreen.main.bounds.width * 0.07))
                    })
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                        .background(Color(.red))
                        .cornerRadius(8)
                    Button(action: {viewModel.got_difficulty(diff:"Hard")}, label: {
                        Text("Hard")
                            .fontWeight(.bold)
                            .foregroundColor(Color(.yellow))
                            .font(.system(size: UIScreen.main.bounds.width * 0.07))
                    })
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                        .background(Color(.red))
                        .cornerRadius(8)
                }
                Spacer()
            }
        }
    }
    
}
