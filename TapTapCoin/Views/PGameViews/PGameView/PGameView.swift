//
//  PGameView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
import zlib

struct PGameView: View {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("pGame") var pGame: String?
    @StateObject private var viewModel = PGameViewModel()
    @State var int_ex = 0
    
    var body: some View {
        ZStack{
            HStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height, alignment: .center)
                    .foregroundColor(Color(.blue))
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height, alignment: .center)
                    .foregroundColor(Color(.red))
            }
            VStack{
                VStack{
                    HStack{
                        VStack{
                            Text(viewModel.username)
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.blue))
                            Text(String(viewModel.fPoints))
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.blue))
                        }
                        Spacer()
                        VStack{
                            Text("Computer")
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.red))
                            Text(String(viewModel.sPoints))
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.red))
                        }
                    }
                    .padding()
                }
                .frame(height:UIScreen.main.bounds.height * 0.15)
                .border(Color(.yellow))
                .background(Color(.yellow))
            }
            .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.48)
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.height * 1.2, alignment: .center)
                .foregroundColor(Color(.black))
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                ForEach(viewModel.coins.indices, id:\.self){ index in
                    if viewModel.coins[index]{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            Button(action: {
                                if (viewModel.gameStarted){
                                    if (viewModel.coin_values["0" + String(index)]! == "yTapCoin"){
                                        viewModel.user_tap(x:0, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["0" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStarted){
                                    if (viewModel.coin_values["1" + String(index)]! == "yTapCoin"){
                                        viewModel.user_tap(x:1, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["1" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStarted){
                                    if (viewModel.coin_values["2" + String(index)]! == "yTapCoin"){
                                        viewModel.user_tap(x:2, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["2" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStarted){
                                    if (viewModel.coin_values["3" + String(index)]! == "yTapCoin"){
                                        viewModel.user_tap(x:3, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["3" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                        }
                        
                    }
                    else{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            Button(action: {
                                if (viewModel.gameStarted){
                                    if (viewModel.coin_values["0" + String(index)]! == "yTapCoin"){
                                        viewModel.user_tap(x:0, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["0" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStarted){
                                    if (viewModel.coin_values["1" + String(index)]! == "yTapCoin"){
                                        viewModel.user_tap(x:1, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["1" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStarted){
                                    if (viewModel.coin_values["2" + String(index)]! == "yTapCoin"){
                                        viewModel.user_tap(x:2, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["2" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                        }//HStack
                    } //Else
                }//ForEach
            }//VStack
            if (viewModel.gameStarted == false){
                Text(viewModel.gameStart)
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                    .background(Color(.yellow))
                    .foregroundColor(Color(.red))
                    .cornerRadius(10)
            }
            
            if (viewModel.endGame){
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                    if (viewModel.changing_diff){
                        Text("Choose Difficulty")
                        Button(action: {
                            viewModel.change_difficulty(change: viewModel.change1)
                        }, label: {
                            Text(viewModel.change1)
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .background(Color(.red))
                            .foregroundColor(Color(.yellow))
                            .cornerRadius(5)
                        Button(action: {
                            viewModel.change_difficulty(change: viewModel.change2)
                        }, label: {
                            Text(viewModel.change2)
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .background(Color(.red))
                            .foregroundColor(Color(.yellow))
                            .cornerRadius(5)
                    }
                    else{
                        Text(viewModel.winner + " is the winner!")
                            .foregroundColor(Color(.red))
                        Button(action: {
                            viewModel.play_again()
                        }, label: {
                            Text("Play again")
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                            .background(Color(.red))
                            .foregroundColor(Color(.yellow))
                            .cornerRadius(5)
                        Button(action: {
                            viewModel.change_difficulty(change: "Change")
                        }, label: {
                            Text("Change difficulty")
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                            .background(Color(.red))
                            .foregroundColor(Color(.yellow))
                            .cornerRadius(5)
                        Button(action: {
                            viewModel.return_home()
                        }, label: {
                            Text("Return Home")
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                            .background(Color(.red))
                            .foregroundColor(Color(.yellow))
                            .cornerRadius(5)
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.33, alignment: .center)
                .background(Color(.yellow))
                .cornerRadius(10)
            }
        }//ZStack view
    } //body view
} //PGameView
