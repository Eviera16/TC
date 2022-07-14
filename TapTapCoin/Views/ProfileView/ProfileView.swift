//
//  ProfileView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("session") var logged_in_user: String?
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack{
            Color(.yellow)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Profile")
                    .font(.system(size: UIScreen.main.bounds.width * 0.15))
                    .foregroundColor(Color(.red))
                    .fontWeight(.bold)
                VStack{
                    Text("Welcome " + viewModel.first_name + " " + viewModel.last_name)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                        .background(Color(.red))
                        .foregroundColor(Color(.yellow))
                        .font(.system(size:25))
                    Text(viewModel.username)
                        .foregroundColor(Color(.red))
                        .font(.system(size:20))
                    HStack{
                        Spacer()
                        VStack{
                            Text("Wins:")
                            Text(String(viewModel.wins))
                        }
                        Spacer()
                        VStack{
                            Text("Losses:")
                            Text(String(viewModel.losses))
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                    .background(Color(.red))
                    .foregroundColor(Color(.yellow))
                    .font(.system(size:25))
                    HStack{
                        Spacer()
                        VStack{
                            Text("Current Streak:")
                            Text(String(viewModel.win_streak))
                        }
                        Spacer()
                        VStack{
                            Text("Best Streak:")
                            Text(String(viewModel.best_streak))
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                    .foregroundColor(Color(.red))
                    .font(.system(size:25))
                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                        
                        Button(action: {viewModel.showRequest = true}, label: {
                            Text("+")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.height * 0.05, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                .background(Color(.yellow))
                                .foregroundColor(Color(.red))
                                .cornerRadius(10)
                        })
                        Text("Friends: " + String(viewModel.numFriends))
                            .font(.system(size: UIScreen.main.bounds.width * 0.08))
                            .fontWeight(.bold)
                            .foregroundColor(Color(.yellow))
                        NavigationLink(destination: {
                            FriendsView()
                                .navigationBarBackButtonHidden(true)
//                                .navigationBarItems(leading: BackButtonView{
//                                    ProfileView()
//                                        .navigationBarBackButtonHidden(true)
//                                        .navigationBarItems(leading: BackButtonView{
//                                            HomeView()
//                                        })
//                                })
                        }, label: {
                            HStack{
                                Text("view")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                    .fontWeight(.bold)
                                if viewModel.hasRQ{
                                    Text("!")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                        .fontWeight(.bold)
                                        .frame(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                        .background(Color(.red))
                                        .foregroundColor(Color(.yellow))
                                        .cornerRadius(30)
                                }
                                else if viewModel.hasGI{
                                    Text("!")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                        .fontWeight(.bold)
                                        .frame(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                        .background(Color(.red))
                                        .foregroundColor(Color(.yellow))
                                        .cornerRadius(30)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.height * 0.065, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                            .background(Color(.yellow))
                            .foregroundColor(Color(.red))
                            .cornerRadius(10)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                    .background(Color(.red))
                    Spacer()
                    HStack{
                        Button(action: {viewModel.logout()}, label: {
                            Text("Logout")
                                .fontWeight(.bold)
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(Color(.yellow))
                                .foregroundColor(Color(.red))
                                .cornerRadius(10)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                    .background(Color(.red))
                }
                Spacer()
            }
            if viewModel.showRequest{
                HStack{
                    Spacer()
                    VStack{
                        Text("Search for username")
                            .foregroundColor(Color(.yellow))
                        TextField("Search", text: $viewModel.sUsername)
                            .foregroundColor(Color.yellow)
                        Rectangle()
                            .fill(Color(.yellow))
                            .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                            .offset(x: UIScreen.main.bounds.width * -0.125)
                        if viewModel.usernameRes{
                            Text(viewModel.result)
                                .foregroundColor(Color(.yellow))
                                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                        }
                        HStack{
                            Button(action: {viewModel.showRequest = false}, label: {
                                Text("Cancel")
                                    .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(Color(.yellow))
                                    .foregroundColor(Color(.red))
                                    .cornerRadius(8)
                            }).padding()
                            Button(action: {viewModel.sendRequest()}, label: {
                                Text("Send")
                                    .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(Color(.yellow))
                                    .foregroundColor(Color(.red))
                                    .cornerRadius(8)
                            }).padding()
                        }
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.26, alignment: .center)
                .background(Color(.red))
                .border(Color(.yellow), width: UIScreen.main.bounds.width * 0.005)
                .offset(x: 0, y: -110)
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
        } //ZStack
        .onAppear { viewModel.getUser() }
    } //Some View
} //View
