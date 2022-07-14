//
//  TempHelpView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct TempHelpView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("session") var logged_in_user: String?
    
    var body: some View {
        ZStack{
            Color(.yellow)
                .ignoresSafeArea()
            HStack{
                Spacer()
                VStack{
                    Text("How To Play")
                        .font(.system(size: UIScreen.main.bounds.width * 0.1))
                        .foregroundColor(Color(.red))
                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
                        
                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
                            Text("Find A Game")
                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                .foregroundColor(Color(.yellow))
                                .fontWeight(.bold)
                            Text("and play against an opponent online to tap more coins then they can!")
                                .foregroundColor(Color(.yellow))
                            Text("Be quick there are only 35 coins!")
                                .foregroundColor(Color(.yellow))
                        }
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
                            Text("Create")
                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                .foregroundColor(Color(.yellow))
                                .fontWeight(.bold)
                            Text("a custom game and play against friends!")
                                .foregroundColor(Color(.yellow))
                        }
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
                            Text("Practice")
                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                .foregroundColor(Color(.yellow))
                                .fontWeight(.bold)
                            Text("against the computer to get your skillz up!")
                                .foregroundColor(Color(.yellow))
                        }
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
                        
                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
                            Text("View your Profile")
                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                .foregroundColor(Color(.yellow))
                                .fontWeight(.bold)
                            Text("to see what your current win streak is and your best overall!")
                                .foregroundColor(Color(.yellow))
                        }
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
                    }
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                        Text("Good luck and have fun!!")
                            .font(.system(size: UIScreen.main.bounds.width * 0.08))
                            .foregroundColor(Color(.yellow))
                            .fontWeight(.bold)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color(.red))
                    Spacer()
                }
                Spacer()
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
    }
    
}
