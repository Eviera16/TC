//
//  SettingsViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 5/1/22.
//

import Foundation
import SwiftUI
import CloudKit
final class SettingsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("notifications") var notifications_on:Bool?
    @Published var username:String = ""
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var friends:Array<String> = [""]
    @Published var numFriends:Int = 0
    @Published var fArrayCount:Int = 0
    @Published var wins: Int = 0
    @Published var losses: Int = 0
    @Published var best_streak: Int = 0
    @Published var win_streak: Int = 0
    @Published var hasST:Bool = false
    @Published var hasRQ:Bool = false
    @Published var hasGI:Bool = false
    
    init(){
        getUser()
    }
    
    func turn_on_off_notifications(){
        print("IN TURN ON OFF NOTIFICATIONS")
        if notifications_on == nil{
            print("IT IS NIL")
            subscribeToNotifications()
        }
        else if notifications_on!{
            print("IT IS ON TURNING IT OFF NOW")
            unsubscribeToNotifications()
        }
        else {
            print("IT IS OFF TURNING IT ON NOW")
            subscribeToNotifications()
        }
    }
    
    func subscribeToNotifications(){
        print("IN SUBSCRIBE TO NOTIFICATIONS")
        while true{
            if !username.isEmpty{
                print("USERNAME IS NOT EMPTY")
                break
            }
            else{
                print("USERNAME IS EMPTY")
                getUser()
            }
        }
        let predicate = NSPredicate(format: "receiver = %@", argumentArray: [username])
        let subscription = CKQuerySubscription(recordType: "FriendRequest", predicate: predicate, subscriptionID: "friend_request_received", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "Friend request received!"
        notification.alertBody = "Open app to accept or decline."
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { [weak self] returnedSubscription, returnedError in
            if let error = returnedError{
                print(error)
            }
            else{
                print("SUCCESSFULLY SUBSCRIBED TO NOTIFICATIONS FOR FRIEND REQUEST")
                DispatchQueue.main.async {
                    self?.notifications_on = true
                }
            }
        }
        let subscription2 = CKQuerySubscription(recordType: "GameInvite", predicate: predicate, subscriptionID: "game_invite_received", options: .firesOnRecordCreation)
        
        let notification2 = CKSubscription.NotificationInfo()
        notification2.title = "Game invite received!"
        notification2.alertBody = "Open app to accept or decline."
        notification2.soundName = "default"
        
        subscription2.notificationInfo = notification2
        
        CKContainer.default().publicCloudDatabase.save(subscription2) { [weak self] returnedSubscription, returnedError in
            if let error = returnedError{
                print(error)
            }
            else{
                print("SUCCESSFULLY SUBSCRIBED TO NOTIFICATIONS FOR GAME INVITES")
                DispatchQueue.main.async {
                    self?.notifications_on = true
                }
            }
        }
    }
    
    func unsubscribeToNotifications(){
        
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "friend_request_received") { [weak self] returnedID, returnedError in
            if let error = returnedError{
                print(error)
            }
            else{
                print("SUCCESSFULLY UNSUBSCRIBED")
                DispatchQueue.main.async{
                    self?.notifications_on = false
                }
            }
        }
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "game_invite_received") { [weak self] returnedID, returnedError in
            if let error = returnedError{
                print(error)
            }
            else{
                print("SUCCESSFULLY UNSUBSCRIBED")
                DispatchQueue.main.async{
                    self?.notifications_on = false
                }
            }
        }
    }
    
    func getUser(){
        print("***** IN GET USER *****")
        //        guard let url = URL(string: ProcessInfo.processInfo.environment["getUser"]!) else{
        //            return
        //        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/info") else{
            return
        }
        
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
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(GUResponse.self, from: data)
                DispatchQueue.main.async {
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
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct GUResponse:Codable {
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
