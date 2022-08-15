//
//  LoginView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack{
            Color(.yellow)
                .ignoresSafeArea()
            VStack{
                Text("Login")
                    .font(.system(size: UIScreen.main.bounds.width * 0.16))
                    .foregroundColor(Color(.red))
                BannerAd(unitID: "ca-app-pub-3940256099942544~1458002511")
                Form{
                    Section(header: Text("")){
                        TextField("Username", text: $viewModel.username)
                        if viewModel.is_error{
                            Label(viewModel.user_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                .foregroundColor(Color(.red))
                        }
                        SecureField("Password", text: $viewModel.password)
                        if viewModel.is_error {
                            Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                .foregroundColor(Color(.red))
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                Button(action: {viewModel.log_pressed ? nil : viewModel.login()}, label: {
                    Text("Login")
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color(.red))
                        .foregroundColor(Color(.yellow))
                        .cornerRadius(8)
                }).padding()
                Spacer()
            }
            if (viewModel.log_pressed){
//                Text(viewModel.testing)
//                    .foregroundColor(Color(.red))
//                    .offset(x: 0.0, y: UIScreen.main.bounds.height * 0.25)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(.red)))
                    .scaleEffect(4)
                    .offset(x: 0.0, y: UIScreen.main.bounds.height * 0.25)
            }
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
            .offset(x: UIScreen.main.bounds.width * -0.36, y: UIScreen.main.bounds.height * -0.4)
        }
    }
}
