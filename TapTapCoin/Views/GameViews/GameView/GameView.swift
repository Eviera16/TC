//
//  GameView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
import zlib

struct GameView: View {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @StateObject private var viewModel = GameViewModel()
    @State var int_ex = 0
//    @State var count:Int = 10
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    
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
                            Text(viewModel.first)
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.blue))
                            Text(String(viewModel.fPoints))
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.blue))
                        }
                        Spacer()
                        VStack{
                            Text(viewModel.second)
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.red))
                            Text(String(viewModel.sPoints))
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(Color(.red))
                        }
                    }
                    .padding()
                }
                .frame(height:UIScreen.main.bounds.height * 0.14)
                .border(Color(.yellow))
                .background(Color(.yellow))
                
            }
            .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.48)
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.height * 1.4, alignment: .center)
                .foregroundColor(Color(.black))
                .offset(x: 0.0, y: UIScreen.main.bounds.height * 0.03)
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.02){
                ForEach(viewModel.coins.indices) { index in
                    if viewModel.coins[index]{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            Button(action: {
                                if (viewModel.gameStart == "START"){
                                    if ( viewModel.coin_values["0" + String(index)]! == "yTapCoin"){
                                        viewModel.sendTap(x:0, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["0" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStart == "START"){
                                    if ( viewModel.coin_values["1" + String(index)]! == "yTapCoin"){
                                        viewModel.sendTap(x:1, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["1" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStart == "START"){
                                    if ( viewModel.coin_values["2" + String(index)]! == "yTapCoin"){
                                        viewModel.sendTap(x:2, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["2" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStart == "START"){
                                    if ( viewModel.coin_values["3" + String(index)]! == "yTapCoin"){
                                        viewModel.sendTap(x:3, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["3" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                        }
                    }
                    else{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            Button(action: {
                                if (viewModel.gameStart == "START"){
                                    if ( viewModel.coin_values["0" + String(index)]! == "yTapCoin"){
                                        viewModel.sendTap(x:0, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["0" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStart == "START"){
                                    if ( viewModel.coin_values["1" + String(index)]! == "yTapCoin"){
                                        viewModel.sendTap(x:1, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["1" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                            Button(action: {
                                if (viewModel.gameStart == "START"){
                                    if ( viewModel.coin_values["2" + String(index)]! == "yTapCoin"){
                                        viewModel.sendTap(x:2, y:index)
                                    }
                                }
                            }, label: {
                                Image(viewModel.coin_values["2" + String(index)]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                    .cornerRadius(100)
                            })
                        }
                    }
                }
            }
            .padding()
            
            if (viewModel.startGame == false){
                if viewModel.ready_uped == false{
                    VStack{
                        Text(viewModel.waitingStatus)
                            .foregroundColor(Color(.red))
                        HStack{
                            Spacer()
                            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.04){
                                Text(viewModel.first)
                                Button(action: {
                                    if viewModel.is_first ?? false{
                                        if !viewModel.ready{
                                            if viewModel.waitingStatus == "Opponent connected"{
                                                viewModel.ready_up(username: viewModel.first)
                                            }
                                        }
                                    }
                                }, label: {
                                    Text("Ready up")
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                        .background(viewModel.fColor)
                                        .foregroundColor(Color(.red))
                                        .cornerRadius(10)
                                })
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.15, alignment: .center)
                            .background(Color(.red))
                            .foregroundColor(Color(.yellow))
                            .cornerRadius(10)
                            Spacer()
                            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.04){
                                Text(viewModel.second)
                                Button(action: {
                                    if viewModel.is_first ?? false{
                                        //pass
                                    }
                                    else{
                                        if !viewModel.ready{
                                            if viewModel.waitingStatus == "Opponent connected"{
                                                viewModel.ready_up(username: viewModel.second)
                                            }
                                        }
                                    }
                                }, label: {
                                    Text("Ready up")
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                        .background(viewModel.sColor)
                                        .foregroundColor(Color(.red))
                                        .cornerRadius(10)
                                })
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.15, alignment: .center)
                            .background(Color(.red))
                            .foregroundColor(Color(.yellow))
                            .cornerRadius(10)
                            Spacer()
                        }
                        Button(action: {viewModel.cancel_game(cancelled: viewModel.cancelled)}, label: {
                            Text("Cancel")
                                .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                .background(Color(.red))
                                .foregroundColor(Color(.yellow))
                                .cornerRadius(10)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                    .background(Color(.yellow))
                    .cornerRadius(10)
                }
                else{
                    Text(viewModel.gameStart)
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                        .background(Color(.yellow))
                        .foregroundColor(Color(.red))
                        .cornerRadius(10)
                }
            }
            if (viewModel.endGame == true){
                VStack{
                    if viewModel.is_a_tie{
                        Text("It is a tie.")
                            .foregroundColor(Color(.red))
                    }
                    else{
                        Text(viewModel.winner + " is the winner!")
                            .foregroundColor(Color(.red))
                    }
                    if viewModel.from_queue ?? false{
                        Button(action: {
                            viewModel.next_game()
                        }, label: {
                            Text("Next Game")
                        })
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color(.red))
                        .foregroundColor(Color(.yellow))
                        .cornerRadius(5)
                        Button(action: {
                            viewModel.return_home(isCGame: false, exit:false)
                        }, label: {
                            Text("Return Home")
                        })
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color(.red))
                        .foregroundColor(Color(.yellow))
                        .cornerRadius(5)
                    }
                    else{
                        if viewModel.paPressed{
                            Text(viewModel.waitingStatus)
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                .background(Color(.red))
                                .foregroundColor(Color(.yellow))
                        }
                        Button(action: {
                            if !viewModel.currPaPressed{
                                viewModel.play_again()
                            }
                        }, label: {
                            Text("Play again votes: " + String(viewModel.paVotes))
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.045, alignment: .center)
                        .background(Color(.red))
                        .foregroundColor(Color(.yellow))
                        .cornerRadius(5)
                        Button(action: {
                            viewModel.return_home(isCGame: true, exit: false)
                        }, label: {
                            Text("Return Home")
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.045, alignment: .center)
                        .background(Color(.red))
                        .foregroundColor(Color(.yellow))
                        .cornerRadius(5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                .background(Color(.yellow))
                .cornerRadius(10)
            }
            VStack{
                Button(action: {
                    viewModel.return_home(isCGame: false, exit: true)
                }, label: {
                    Text("Exit")
                        .foregroundColor(Color(.red))
                })
            }
            .background(Color(.black))
            .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.4)
            .padding()
            
            Text(String(viewModel.count))
                .foregroundColor(Color(.red))
                .background(Color(.black))
                .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.45)
                .padding()
            
            
            
            if viewModel.opp_disconnected{
                Text(viewModel.disconnectMessage)
                    .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                    .background(Color(.yellow))
                    .foregroundColor(Color(.red))
                    .cornerRadius(10)
            }
            
        }
        .onReceive(timer, perform: { _ in
            if viewModel.startGame{
                if viewModel.count > 0 {
                    viewModel.count -= 1
                }
                else if viewModel.count == 0{
                    viewModel.times_up()
                }
            }
        })
        .onDisappear { in_game = false }
    }
}
