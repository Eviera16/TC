//
//  ProfileViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
import CloudKit

final class ProfileViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @Published var username:String = ""
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var friends:Array<String> = [""]
    @Published var numFriends:Int = 0
    @Published var fArrayCount:Int = 0
    @Published var sUsername:String = ""
    @Published var result:String = ""
    @Published var wins: Int = 0
    @Published var losses: Int = 0
    @Published var best_streak: Int = 0
    @Published var win_streak: Int = 0
    @Published var showRequest:Bool = false
    @Published var usernameRes:Bool = false
    @Published var hasST:Bool = false
    @Published var hasRQ:Bool = false
    @Published var hasGI:Bool = false
    
    init(){
        GameHandler.sharedInstance.closeConnection()
    }
    func logout(){
//        guard let url = URL(string: ProcessInfo.processInfo.environment["logout"]!) else{
//            return
//        }
        
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/logout") else{
            return
        }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/logout") else{
//            return
//        }
        
        
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                DispatchQueue.main.async {
                    self?.logged_in_user = nil
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
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
    
    func sendRequest(){
        self.usernameRes = false
        if sUsername.count > 0{
//            guard let url = URL(string: "http://127.0.0.1:8000/api/user/sfr") else{
//                return
//            }
            guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/sfr") else{
                return
            }
            var request = URLRequest(url: url)
            guard let session = logged_in_user else{
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: AnyHashable] = [
                "username": sUsername,
                "token": session
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(rResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.usernameRes = true
                        if response.result != "Success"{
                            if response.result == "ALREADY SENT TO"{
                                self?.result = "Already sent to " + response.friends[0]
                            }
                            else if response.result == "ALREADY RECIEVED"{
                                self?.result = "Already recieved request from " + response.friends[0]
                            }
                            else{
                                self?.result = response.result
                            }
                        }
                        else{
                            self?.result = "Successfully sent"
                            self?.friends = response.friends
                            self?.addFriendRequest()
                        }
                    }
                }
                catch{
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    struct rResponse:Codable {
        let result: String
        let friends:Array<String>
    }
    private func addFriendRequest(){
        print("IN ADD FRIEND REQUEST")
        let newFriendRequest = CKRecord(recordType: "FriendRequest")
        newFriendRequest["sender"] = username
        newFriendRequest["receiver"] = sUsername
        saveFriendRequest(record: newFriendRequest)
    }
    
    private func saveFriendRequest(record:CKRecord){
        print("IN SAVE FRIEND REQUEST")
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("RETURNED RECORD BELOW")
            print(returnedRecord ?? "NOTHING HERE")
            print("RETURNED ERROR BELOW")
            print(returnedError ?? "NOTHING HERE")
            DispatchQueue.main.async {
                self?.sUsername = ""
            }
        }
    }
}
