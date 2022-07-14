//
//  ContentViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
import CloudKit
final class ContentViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("pGame") var pGame: String?
    @AppStorage("notifications") var notifications_on:Bool?
    @Published var current_screen:String = "Home"
    @Published var iCloudAccountError:String?
    @Published var hasiCloudAccountError:Bool?
    @Published var isSignedInToiCloud:Bool?
    @Published var user_name:String?
    @Published var username:String = "NULL"
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
    private var checked_in_game:Bool = false
    
    init() {
        print("IN CONTENT VIEW INIT")
        getUser()
        check_in_game()
        getiCloudStatus()
    }
    
    private func getiCloudStatus(){
        print("IN GET ICLOUD STATUS")
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async{
                switch returnedStatus{
                case .available:
                    print("IS AVAILABLE")
                    self?.isSignedInToiCloud = true
                    self?.requestPermission()
                case .noAccount:
                    print("NO ACCOUNT")
                    self?.iCloudAccountError = CloudKitError.iCloudAccountNotFound.rawValue
                    self?.hasiCloudAccountError = true
                case .couldNotDetermine:
                    print("NOT DETERMINED")
                    self?.iCloudAccountError = CloudKitError.iCloudAccountNotDetermined.rawValue
                    self?.hasiCloudAccountError = true
                case .restricted:
                    print("RESTRICTED")
                    self?.iCloudAccountError = CloudKitError.iCloudAccountRestricted.rawValue
                    self?.hasiCloudAccountError = true
                default:
                    print("DEFAULT")
                    self?.iCloudAccountError = CloudKitError.iCloudAccountUnknown.rawValue
                    self?.hasiCloudAccountError = true
                }
            }
        }
    }
    
    private enum CloudKitError: String, LocalizedError{
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func requestPermission(){
        print("IN REQUEST PERMISSION")
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted{
                    print("STATUS IS GRANTED")
                    self?.fetchiCloudUserRecordID()
                }
                else{
                    print("STATUS IS NOT GRANTED")
                    print(returnedStatus)
                }
            }
        }
    }
    
    func fetchiCloudUserRecordID(){
        print("IN FETCH ICLOUD USER RECORD ID")
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID{
                print("HAS AN ID")
                self?.discoveriCloudUser(id: id)
            }
            else{
                print("NO ID")
                print(returnedError)
            }
        }
    }
    
    func discoveriCloudUser(id: CKRecord.ID){
        print("IN DISCOVER ICLOUD USER")
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    print("HAS A GIVEN NAME")
                    self?.user_name = name
                    print(name)
                    //request permission for notifications
                    self?.requestNotificationPermissions()
                }
                else{
                    print("NO GIVEN NAME")
                }
            }
        }
    }
    
    func requestNotificationPermissions(){
        print("IN REQUEST NOTIFICATION PERMISSIONS")
        let options:UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { [weak self] success, error in
            if let error = error{
                print(error)
            }
            else if success{
                print("Notification permissions success.")
                DispatchQueue.main.async{
                    UIApplication.shared.registerForRemoteNotifications()
                    self?.subscribeToNotifications()
                }
            }
            else{
                print("Notification permissions failure.")
            }
        }
    }
    
    func subscribeToNotifications(){
        print("IN SUBSCRIBE TO NOTIFICATIONS")
        if notifications_on != nil{
            print("NOTIFICATIONS ARE ALREADY SET")
            return
        }
        if username == "NULL"{
            return
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
                print("SUCCESSFULLY SUBSCRIBED TO NOTIFICATIONS")
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
    
    func check_in_game(){
//        if let environment = ProcessInfo.processInfo.environment["check_in_game"], let url = URL(string: environment) {
            guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/check_in_game") else{
                return
            }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/check_in_game") else{
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
            let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    do {
                        let response = try JSONDecoder().decode(Response.self, from: data)
                        if (response.response == "INGAME"){
                            self?.in_game = true
                            self?.game_id = "No Game Id"
                        }
                        else{
                            self?.in_game = false
                            self?.pGame = "None"
                            self?.in_queue = false
                            self?.game_id = "No Game Id"
                            self?.from_queue = false
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            })
            task.resume()
//        }
        
    }
    struct Response:Codable {
        let response: String
    }
    
    func getUser(){
        print("***** IN GET USER ***8*")
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
                    let response = try JSONDecoder().decode(GUResponse.self, from: data)
                    self?.username = response.username
                    print("GOT THE USERNAME")
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
