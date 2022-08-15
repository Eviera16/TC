//
//  HomeView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_queue") var in_queue: Bool?
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack{
            Color(.red)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                Text("TapTapCoin")
                    .font(.system(size: UIScreen.main.bounds.width * 0.15))
                    .foregroundColor(Color(.yellow))
                    .fontWeight(.bold)
                VStack(alignment: .leading, spacing: 0.0){
                    Button(action: { in_queue = true }, label: {
                        if viewModel.hasRQ{
                            Text("Find Game")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                .foregroundColor(Color(.yellow))
                        }
                        else if viewModel.hasGI{
                            Text("Find Game")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                .foregroundColor(Color(.yellow))
                        }
                        else{
                            Text("Find Game")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                .foregroundColor(Color(.yellow))
                                .offset(x: UIScreen.main.bounds.width * -0.125)
                        }
                    })
                    Rectangle()
                        .fill(Color(.yellow))
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                        .offset(x: UIScreen.main.bounds.width * -0.125)
                    NavigationLink(destination: {
                        PMenuView()
                            .navigationBarBackButtonHidden(true)
//                            .navigationBarItems(leading: BackButtonView{
//                                HomeView()
//                            })
                    }, label: {
                        if viewModel.hasRQ{
                            Text("Practice")
                               .font(.system(size: UIScreen.main.bounds.width * 0.1))
                               .fontWeight(.bold)
                               .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                               .foregroundColor(Color(.yellow))
                        }
                        else if viewModel.hasGI{
                            Text("Practice")
                               .font(.system(size: UIScreen.main.bounds.width * 0.1))
                               .fontWeight(.bold)
                               .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                               .foregroundColor(Color(.yellow))
                        }
                        else{
                            Text("Practice")
                               .font(.system(size: UIScreen.main.bounds.width * 0.1))
                               .fontWeight(.bold)
                               .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                               .foregroundColor(Color(.yellow))
                               .offset(x: UIScreen.main.bounds.width * -0.125)
                        }
                    })
                    Rectangle()
                        .fill(Color(.yellow))
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                        .offset(x: UIScreen.main.bounds.width * -0.125)
                    NavigationLink(destination: {
                        ProfileView()
                            .navigationBarBackButtonHidden(true)
//                            .navigationBarItems(leading: BackButtonView{
//                                HomeView()
//                            })
                    }, label: {
                        HStack{
                            if viewModel.hasRQ{
                                Text("Profile")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                    .foregroundColor(Color(.yellow))
                                Text("!")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.height * 0.04, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .background(Color(.yellow))
                                    .foregroundColor(Color(.red))
                                    .cornerRadius(30)
                            }
                            else if viewModel.hasGI{
                                Text("Profile")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                    .foregroundColor(Color(.yellow))
                                Text("!")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.height * 0.04, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .background(Color(.yellow))
                                    .foregroundColor(Color(.red))
                                    .cornerRadius(30)
                            }
                            else{
                                Text("Profile")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                    .foregroundColor(Color(.yellow))
                                    .offset(x: UIScreen.main.bounds.width * -0.125)
                            }
                        }
                    })
                    if viewModel.hasRQ{
                        Rectangle()
                            .fill(Color(.yellow))
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                    else if viewModel.hasGI{
                        Rectangle()
                            .fill(Color(.yellow))
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                    else{
                        Rectangle()
                            .fill(Color(.yellow))
                            .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                            .offset(x: UIScreen.main.bounds.width * -0.125)
                    }
                    NavigationLink(destination: {
                        TempHelpView()
                            .navigationBarBackButtonHidden(true)
//                            .navigationBarItems(leading: BackButtonView{
//                                HomeView()
//                            })
                    }, label: {
                        if viewModel.hasRQ{
                            Text("Help")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                .foregroundColor(Color(.yellow))
                        }
                        else if viewModel.hasGI{
                            Text("Help")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                .foregroundColor(Color(.yellow))
                        }
                        else{
                            Text("Help")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                                .foregroundColor(Color(.yellow))
                                .offset(x: UIScreen.main.bounds.width * -0.125)
                        }
                    })
                    Rectangle()
                        .fill(Color(.yellow))
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                        .offset(x: UIScreen.main.bounds.width * -0.125)
                    NavigationLink(destination: {
                        SettingsView()
                            .navigationBarBackButtonHidden(true)
//                            .navigationBarItems(leading: BackButtonView{
//                                HomeView()
//                            })
                    }, label: {
                        if viewModel.hasRQ{
                            Image(systemName: "gearshape.fill")
                                   .background(Color(.red))
                                   .foregroundColor(Color(.yellow))
                                   .font(.system(size: UIScreen.main.bounds.width * 0.18))
                        }
                        else if viewModel.hasGI{
                            Image(systemName: "gearshape.fill")
                                   .background(Color(.red))
                                   .foregroundColor(Color(.yellow))
                                   .font(.system(size: UIScreen.main.bounds.width * 0.18))
                        }
                        else{
                            Image(systemName: "gearshape.fill")
                                   .background(Color(.red))
                                   .foregroundColor(Color(.yellow))
                                   .font(.system(size: UIScreen.main.bounds.width * 0.15))
                                   .offset(x: UIScreen.main.bounds.width * -0.125)
                        }
                    })
                }
                Spacer()
            }
        }
            
    }
}


//NavigationLink(destination: {
//    SettingsView()
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButtonView{
//            HomeView()
//        })
//}, label: {
//    Image(systemName: "gearshape.fill")
//        .background(Color(.red))
//        .foregroundColor(Color(.yellow))
//        .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
//})
