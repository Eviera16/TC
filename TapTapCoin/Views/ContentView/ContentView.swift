//
//  ContentView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("pGame") var pGame: String?
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                if logged_in_user != nil && in_game != nil{
                    if in_game ?? false{
                        GameView()
                    }
                    else{
                        if in_queue ?? false{
                            LoadingGameView()
                        }
                        else{
                            if pGame ?? "None" != "None"{
                                PGameView()
                            }
                            else{
                                HomeView()
                            }
                        }
                    }
                }
                else{
                    RegistrationView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
