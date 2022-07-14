//
//  Settings.swift
//  TapTapCoin
//
//  Created by Eric Viera on 5/1/22.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("notifications") var notifications_on:Bool?
    var body: some View {
        ZStack{
            Color(.yellow)
                .ignoresSafeArea()
            VStack{
                Text("Settings:")
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                    .foregroundColor(Color(.yellow))
                    .background(Color(.red))
                Spacer()
                List{
                    Section(header: Text("Notifications")){
                        HStack{
                            Text("Allow notifications - ")
                            Spacer()
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(.gray))
                                    .frame(width: UIScreen.main.bounds.width * 0.26, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                                Button(action: {
                                    print("PRESSING THE BUTTON")
                                    viewModel.turn_on_off_notifications()
                                }, label: {
                                    RoundedRectangle(cornerRadius:30)
                                        .fill(notifications_on ?? false ? Color(.green) : Color(.red))
                                        .frame(width: UIScreen.main.bounds.height * 0.07, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                                        .offset(x: notifications_on ?? false ? UIScreen.main.bounds.width * -0.054 : UIScreen.main.bounds.width * 0.054)
                                        .animation(Animation.default)
                                })
                            }
                        }
                    }
                }
                .foregroundColor(Color(.red))
                Spacer()
            }
            Button(action: {
                print("PRESSING BACK BUTTON")
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Back")
                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                    .fontWeight(.bold)
                    .foregroundColor(Color(.yellow))
                    .underline()
            })
            .offset(x: UIScreen.main.bounds.width * -0.36, y: UIScreen.main.bounds.height * -0.375)
        }
    }
}
    
