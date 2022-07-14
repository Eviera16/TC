//
//  FriendsViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/16/22.
//

import Foundation
import SwiftUI
import CloudKit
final class FriendsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @Published var username:String = ""
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var friends:Array<String> = []
    @Published var invites:Array<String> = []
    @Published var hInvite:Bool = false
    @Published var wins:Int = 0
    @Published var losses:Int = 0
    @Published var win_streak:Int = 0
    @Published var best_streak:Int = 0
    @Published var numFriends:Int = 0
    @Published var fArrayCount:Int = 0
    
    private var mSocket = GameHandler.sharedInstance.getSocket()
    private var first_time:Bool = true
    
    init(){
        getUser()
        GameHandler.sharedInstance.establishConnection()
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
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self]data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async{
                    self?.username = response.username
                    self?.first_name = response.first_name
                    self?.last_name = response.last_name
                    self?.friends = response.friends
                    self?.wins = response.wins
                    self?.losses = response.losses
                    self?.win_streak = response.win_streak
                    self?.best_streak = response.best_streak
                    
                    self?.hInvite = response.hasInvite
                    self?.invites = response.invites
                    
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
                                    }
                                }
                            }
                            self?.numFriends = count
                            self?.fArrayCount = response.friends.count
                        }
                        self?.sortFriends()
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
    
    func sortFriends(){
        var newFriends:Array<String> = []
        for friend in friends{
            if friend.contains("sentTo|"){
                let fSplit = friend.split(separator: "|")
                let new_friend = "Pending request to " + fSplit[1]
                newFriends.append(new_friend)
            }
            else if friend.contains("requested|"){
                let fSplit = friend.split(separator: "|")
                let new_friend = "Friend request from " + fSplit[1]
                newFriends.append(new_friend)
            }
            else{
                if hInvite{
                    var foundFriendInvite = false
                    for invite in invites{
                        if invite == friend{
                            foundFriendInvite = true
                        }
                    }
                    if foundFriendInvite{
                        let inv_friend = "Invite from " + friend
                        newFriends.append(inv_friend)
                    }
                    else{
                        newFriends.append(friend)
                    }
                }
                else{
                    newFriends.append(friend)
                }
            }
        }
        friends = newFriends
    }
    
    func decline_request(requestName:String){
        let rNameSplit = requestName.split(separator: " ")
        let rUsername = rNameSplit[3]
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/dfr") else{
//            return
//        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/dfr") else{
            return
        }


        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rUsername,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(DResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.result == "Declined"{
                        self?.findFriendRequest(frSender: String(rUsername))
                        self?.getUser()
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct DResponse:Codable {
        let result: String
    }
    
    func accept_request(requestName:String){
        let rNameSplit = requestName.split(separator: " ")
        let rUsername = rNameSplit[3]
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/afr") else{
//            return
//        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/afr") else{
            return
        }

        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rUsername,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(AResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.result == "Accepted"{
                        self?.findFriendRequest(frSender: String(rUsername))
                        self?.getUser()
                    }
                }
                
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct AResponse:Codable {
        let result: String
    }
    
    struct FRModel:Hashable{
        let sender:String
        let receiver:String
        let record:CKRecord
    }
    
    func findFriendRequest(frSender:String){
        print("IN FIND FRIEND REQUEST")
        print(username)
        let predicate = NSPredicate(format: "receiver = %@", argumentArray: [username])
        let query = CKQuery(recordType: "FriendRequest", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var friendRequests: [FRModel] = []
        
        if #available(iOS 15.0, *){
            print("IN HERE IN HERE IN HERE")
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult{
                case .success(let record):
                    //logic here
                    print("FOUND A RECORD")
                    let sender = record["sender"] as? String
                    print(sender)
                    let receiver = record["receiver"] as? String
                    print(receiver)
                    friendRequests.append(FRModel(sender: sender ?? "Null", receiver: receiver ?? "Null", record: record))
                    break
                case .failure(let error):
                    print("ERROR recordMatchBlock: \(error)")
                }
            }
        }
        else{
            queryOperation.recordFetchedBlock = { (returnedRecord) in
                //logic here
                let sender = returnedRecord["sender"] as? String
                print(sender)
                let receiver = returnedRecord["receiver"] as? String
                print(receiver)
                friendRequests.append(FRModel(sender: sender ?? "Null", receiver: receiver ?? "Null", record: returnedRecord))
            }
        }
        
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
                print("RETURNED queryResultBlock: \(returnedResult)")
                for frqt in friendRequests{
                    print("REQUEST IS BELOW")
                    print(frqt.sender)
                    print(frqt.receiver)
                    print(frqt.record)
                    if frqt.sender == frSender{
                        self?.deleteFriendRequest(record:frqt.record)
                    }
                }
            }
        }
        else{
            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
                print("RETURNED queryCompletionBlock")
                for frqt in friendRequests{
                    print("REQUEST IS BELOW")
                    print(frqt.sender)
                    print(frqt.receiver)
                    print(frqt.record)
                    if frqt.sender == frSender{
                        self?.deleteFriendRequest(record:frqt.record)
                    }
                }
            }
        }
        addOperation(operation: queryOperation)
    }
    
    func addOperation(operation:CKDatabaseOperation){
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func deleteFriendRequest(record:CKRecord){
        print("DELETING THE REQUEST NOW")
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { returnedRecordID, returnedError in
            print("IN DELETE FRINED REQUEST COMPLETION")
            print(returnedRecordID)
            print(returnedError)
        }
    }
    
    func removeFriend(requestName:String){
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/remove_friend") else{
//            return
//        }
        
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/remove_friend") else{
            return
        }

        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": requestName,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(RResponse.self, from: data)
                if response.result == "Removed"{
                    DispatchQueue.main.async {
                        self?.getUser()
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct RResponse:Codable {
        let result: String
    }
    
    func sendInvite(inviteName:String){
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/send_invite") else{
//            return
//        }
        
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/send_invite") else{
            return
        }

        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": inviteName,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(CGResponse.self, from: data)
                if response.first != "ALREADY EXISTS"{
                    print(response.gameId)
                    GameHandler.sharedInstance.closeConnection()
                    DispatchQueue.main.async {
                        self?.first_player = response.first
                        self?.second_player = response.second
                        self?.game_id = response.gameId
                        self?.from_queue = false
                        self?.custom_game = true
                        self?.is_first = true
                        self?.in_game = true
                        ///////////////////////////////////
                        self?.addGameInvite(sender: response.first, receiver: response.second)
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct CGResponse:Codable {
        let first: String
        let second: String
        let gameId: String
    }
    
    private func addGameInvite(sender:String, receiver:String){
        print("IN ADD GAME INVITE")
        let newGameInvite = CKRecord(recordType: "GameInvite")
        newGameInvite["sender"] = sender
        newGameInvite["receiver"] = receiver
        saveGameInvite(record: newGameInvite)
    }
    
    private func saveGameInvite(record:CKRecord){
        print("IN SAVE GAME INVITE")
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("RETURNED RECORD BELOW")
            print(returnedRecord ?? "NOTHING HERE")
            print("RETURNED ERROR BELOW")
            print(returnedError ?? "NOTHING HERE")
        }
    }
    
    func declineInvite(inviteName:String){
        let rNameSplit = inviteName.split(separator: " ")
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/ad_invite") else{
//            return
//        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/ad_invite") else{
            return
        }

        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rNameSplit[2],
            "token": session,
            "adRequest": "delete"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(DIResponse.self, from: data)
                if response.result == "Cancelled"{
                    DispatchQueue.main.async {
                        self?.getUser()
                        self?.findGameInvite(giSender: String(rNameSplit[2]))
                        self?.mSocket.emit("DECLINED", String(rNameSplit[2]))
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct DIResponse:Codable {
        let result: String
    }
    
    func acceptInvite(inviteName:String){
        let rNameSplit = inviteName.split(separator: " ")
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/ad_invite") else{
//            return
//        }
        
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/ad_invite") else{
            return
        }

        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rNameSplit[2],
            "token": session,
            "adRequest": "accept"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(AIResponse.self, from: data)
                if response.result == "Accepted"{
                    GameHandler.sharedInstance.closeConnection()
                    DispatchQueue.main.async {
                        self?.first_player = response.first
                        self?.second_player = response.second
                        self?.game_id = response.gameId
                        self?.from_queue = false
                        self?.is_first = false
                        self?.custom_game = true
                        self?.in_game = true
                        self?.findGameInvite(giSender: String(rNameSplit[2]))
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct AIResponse:Codable {
        let result: String
        let first: String
        let second: String
        let gameId: String
    }
    
    struct GIModel:Hashable{
        let sender:String
        let receiver:String
        let record:CKRecord
    }
    
    func findGameInvite(giSender:String){
        print("IN FIND GAME INVITE")
//        let predicate = NSPredicate(value: true)
        print(username)
        let predicate = NSPredicate(format: "receiver = %@", argumentArray: [username])
        let query = CKQuery(recordType: "GameInvite", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var gameInvites: [GIModel] = []
        
        if #available(iOS 15.0, *){
            print("IN HERE IN HERE IN HERE")
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult{
                case .success(let record):
                    //logic here
                    print("FOUND A RECORD")
                    let sender = record["sender"] as? String
                    print(sender)
                    let receiver = record["receiver"] as? String
                    print(receiver)
                    gameInvites.append(GIModel(sender: sender ?? "Null", receiver: receiver ?? "Null", record: record))
                    break
                case .failure(let error):
                    print("ERROR recordMatchBlock: \(error)")
                }
            }
        }
        else{
            queryOperation.recordFetchedBlock = { (returnedRecord) in
                //logic here
                let sender = returnedRecord["sender"] as? String
                print(sender)
                let receiver = returnedRecord["receiver"] as? String
                print(receiver)
                gameInvites.append(GIModel(sender: sender ?? "Null", receiver: receiver ?? "Null", record: returnedRecord))
            }
        }
        
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
                print("RETURNED queryResultBlock: \(returnedResult)")
                for gi in gameInvites{
                    print("GAME INVITE IS BELOW")
                    print(gi.sender)
                    print(gi.receiver)
                    print(gi.record)
                    if gi.sender == giSender{
                        self?.deleteGameInvite(record:gi.record)
                    }
                }
            }
        }
        else{
            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
                print("RETURNED queryCompletionBlock")
                for gi in gameInvites{
                    print("GAmE INVITE IS BELOW")
                    print(gi.sender)
                    print(gi.receiver)
                    print(gi.record)
                    if gi.sender == giSender{
                        self?.deleteGameInvite(record:gi.record)
                    }
                }
            }
        }
        addOperation(operation: queryOperation)
    }
    
    func deleteGameInvite(record:CKRecord){
        print("DELETING THE GAME INVITE NOW")
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { returnedRecordID, returnedError in
            print("IN DELETE GAME INVITE COMPLETION")
            print(returnedRecordID)
            print(returnedError)
        }
    }
}
