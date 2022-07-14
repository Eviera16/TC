//
//  FriendsView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/15/22.
//

import Foundation
import SwiftUI

struct FriendsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FriendsViewModel()
    var body: some View {
        ZStack{
            Color(.red)
                .ignoresSafeArea()
            VStack{
                Text("Friends:")
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                    .foregroundColor(Color(.red))
                    .background(Color(.yellow))
                    
                ScrollView{
                    VStack{
                        if viewModel.fArrayCount == 0{
                            HStack{
                                Text("No friends yet")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                    .foregroundColor(Color(.yellow))
                                    .fontWeight(.bold)
                            }
                            Rectangle()
                                .fill(Color(.yellow))
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                        }
                        else{
                            ForEach(viewModel.friends, id:\.self){ index in
                                VStack{
                                    if index.contains("Friend request from"){
                                        HStack{
                                            Text(index)
                                                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                                .foregroundColor(Color(.yellow))
                                                .fontWeight(.bold)
                                            Button(action: {viewModel.decline_request(requestName: index)}, label: {
                                                Image(systemName: "minus.square.fill")
                                                    .background(Color(.yellow))
                                                    .foregroundColor(Color(.red))
                                            })
                                            Button(action: {viewModel.accept_request(requestName: index)}, label: {
                                                Image(systemName: "checkmark.square.fill")
                                                    .background(Color(.red))
                                                    .foregroundColor(Color(.yellow))
                                            })
                                        }
                                        Rectangle()
                                            .fill(Color(.yellow))
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                                    }
                                    else if index.contains("Pending request"){
                                        Text(index)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                            .foregroundColor(Color(.yellow))
                                            .fontWeight(.bold)
                                        Rectangle()
                                            .fill(Color(.yellow))
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                                    }
                                    else if index.contains("Invite from"){
                                        HStack(alignment: .center){
                                            Text(index)
                                                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                                .foregroundColor(Color(.yellow))
                                                .fontWeight(.bold)
                                            Spacer()
                                            Button(action: {viewModel.acceptInvite(inviteName: index)}, label: {
                                                HStack{
                                                    Text("Accept")
                                                    Image(systemName: "checkmark.square.fill")
                                                        .background(Color(.yellow))
                                                        .foregroundColor(Color(.red))
                                                }
                                                .background(Color(.yellow))
                                                .foregroundColor(Color(.red))
                                                
                                            })
                                            Button(action: {viewModel.declineInvite(inviteName: index)}, label: {
                                                HStack{
                                                    Text("Decline")
                                                    Image(systemName: "xmark.square.fill")
                                                        .background(Color(.yellow))
                                                        .foregroundColor(Color(.red))
                                                }
                                                .background(Color(.yellow))
                                                .foregroundColor(Color(.red))
                                                
                                            })
                                            Button(action: {viewModel.removeFriend(requestName: index)}, label: {
                                                Image(systemName: "delete.right.fill")
                                                    .background(Color(.red))
                                                    .foregroundColor(Color(.yellow))
                                            })
                                        }
                                        .padding()
                                        Rectangle()
                                            .fill(Color(.yellow))
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                                        
                                    }
                                    else{
                                        HStack(alignment: .center){
                                            Text(index)
                                                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                                .foregroundColor(Color(.yellow))
                                                .fontWeight(.bold)
                                            Spacer()
                                            Button(action: {viewModel.sendInvite(inviteName: index)}, label: {
                                                HStack{
                                                    Text("Custom game")
                                                    Image(systemName: "arrow.up.square.fill")
                                                        .background(Color(.yellow))
                                                        .foregroundColor(Color(.red))
                                                }
                                                .background(Color(.yellow))
                                                .foregroundColor(Color(.red))
                                                
                                            })
                                            Button(action: {viewModel.removeFriend(requestName: index)}, label: {
                                                Image(systemName: "delete.right.fill")
                                                    .background(Color(.red))
                                                    .foregroundColor(Color(.yellow))
                                            })
                                        }
                                        .padding()
                                        Rectangle()
                                            .fill(Color(.yellow))
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                                    }
                                }
                            }
                        }
                    }
                }
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
            .offset(x: UIScreen.main.bounds.width * -0.36, y: UIScreen.main.bounds.height * -0.375)
        } //ZStack
    }
}
