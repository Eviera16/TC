//
//  RegistrationView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    
    init(){
            UITableView.appearance().backgroundColor = .clear
        }
    
    var body: some View {
        ZStack{
            Color(.red)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.001){
                ScrollView{
                    Text("Register")
                        .font(.system(size: UIScreen.main.bounds.width * 0.16))
                        .foregroundColor(Color(.yellow))
                    Form{
                        Section(header: Text("")){
                            TextField("First Name", text: $viewModel.first_name)
                            if viewModel.is_fName_error{
                                Label(viewModel.first_name_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(Color(.red))
                            }
                            TextField("Last Name", text: $viewModel.last_name)
                            if viewModel.is_lName_error{
                                Label(viewModel.last_name_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(Color(.red))
                            }
                            TextField("Username", text: $viewModel.username)
                            if viewModel.is_uName_error{
                                Label(viewModel.username_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(Color(.red))
                            }
                        }
                        Section{
                            SecureField("Password", text: $viewModel.password)
                            if viewModel.is_password_error{
                                Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(Color(.red))
                            }
                            SecureField("Confirm password", text: $viewModel.confirm_password)
                            if viewModel.is_password_error{
                                Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(Color(.red))
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.6, alignment: .bottom)
                    .background(Color(.red))
                    Button(action: {viewModel.reg_pressed ? nil : viewModel.register()}, label: {
                        Text("Register")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(Color(.yellow))
                            .foregroundColor(Color(.red))
                            .cornerRadius(8)
                    })
                    HStack{
                        Text("By registering you agree to our ")
                            .foregroundColor(Color(.yellow))
                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                        Link("Privacy Policy", destination: URL(string: "https://www.termsfeed.com/live/905833ca-f47b-4b29-b334-dc1dec48d0b0") ?? URL(string: "")!)
                    }
                    .padding()
                    HStack{
                        Text("Already have an account? ")
                        NavigationLink(destination: {
                            LoginView()
                                .navigationBarBackButtonHidden(true)
                        }, label: {
                            Text("Login!")
                                .foregroundColor(Color(.yellow))
                        })
                    }
                    Spacer()
                }
            }
            if (viewModel.reg_pressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:Color(.yellow)))
                    .scaleEffect(4)
                    .offset(x: 0.0, y: UIScreen.main.bounds.height * 0.2)
            }
        }
    }
}
