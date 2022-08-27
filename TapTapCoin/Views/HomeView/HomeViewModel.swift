//
//  HomeViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
final class HomeViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("ad_loaded") var ad_loaded: Bool?
    @Published var username:String = ""
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var friends:Array<String> = [""]
    @Published var numFriends:Int = 0
    @Published var fArrayCount:Int = 0
    @Published var result:String = ""
    @Published var wins: Int = 0
    @Published var losses: Int = 0
    @Published var best_streak: Int = 0
    @Published var win_streak: Int = 0
    @Published var usernameRes:Bool = false
    @Published var hasST:Bool = false
    @Published var hasRQ:Bool = false
    @Published var hasGI:Bool = false
    
    init(){
        ad_loaded = false
        getUser()
        print("THE SCREEN SIZE IS BELOW")
        print(UIScreen.main.bounds.height)
    }
    
    func getUser(){
        print("***** IN GET USER *****")
        //        guard let url = URL(string: ProcessInfo.processInfo.environment["getUser"]!) else{
        //            return
        //        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/info") else{
            return
        }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/info") else{
//            return
//        }
        
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "from": "Profile",
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    self?.username = response.username
                    self?.first_name = response.first_name
                    self?.last_name = response.last_name
                    self?.friends = response.friends
                    self?.wins = response.wins
                    self?.losses = response.losses
                    self?.win_streak = response.win_streak
                    self?.best_streak = response.best_streak
                    
                    if response.friends.count > 0{
                        if response.friends[0] == "0"{
                            self?.numFriends = 0
                        }
                        else{
                            var count = 0
                            for friend in response.friends{
                                if !friend.contains("requested|"){
                                    if !friend.contains("sentTo|"){
                                        count += 1
                                        if response.hasInvite{
                                            self?.hasGI = true
                                        }
                                    }
                                    else{
                                        self?.hasST = true
                                    }
                                }
                                else{
                                    self?.hasRQ = true
                                }
                            }
                            self?.numFriends = count
                            self?.fArrayCount = response.friends.count
                        }
                    }
                    else{
                        self?.numFriends = 0
                        self?.fArrayCount = 0
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let response: String
        let username: String
        let friends:Array<String>
        let invites:Array<String>
        let hasInvite:Bool
        let wins: Int
        let losses: Int
        let win_streak: Int
        let best_streak: Int
    }
    
}
