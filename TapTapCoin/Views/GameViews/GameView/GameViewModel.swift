//
//  GameViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
import zlib
final class GameViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @Published var coins = [true, false, true, false, true, false, true, false, true, false]
    @Published var coin_values = [
        "00":"yTapCoin",
        "10":"yTapCoin",
        "20":"yTapCoin",
        "30":"yTapCoin",
        "01":"yTapCoin",
        "11":"yTapCoin",
        "21":"yTapCoin",
        "02":"yTapCoin",
        "12":"yTapCoin",
        "22":"yTapCoin",
        "32":"yTapCoin",
        "03":"yTapCoin",
        "13":"yTapCoin",
        "23":"yTapCoin",
        "04":"yTapCoin",
        "14":"yTapCoin",
        "24":"yTapCoin",
        "34":"yTapCoin",
        "05":"yTapCoin",
        "15":"yTapCoin",
        "25":"yTapCoin",
        "06":"yTapCoin",
        "16":"yTapCoin",
        "26":"yTapCoin",
        "36":"yTapCoin",
        "07":"yTapCoin",
        "17":"yTapCoin",
        "27":"yTapCoin",
        "08":"yTapCoin",
        "18":"yTapCoin",
        "28":"yTapCoin",
        "38":"yTapCoin",
        "09":"yTapCoin",
        "19":"yTapCoin",
        "29":"yTapCoin",
    ]
    @Published var first:String = ""
    @Published var second:String = ""
    @Published var fPoints:Int = 0
    @Published var sPoints:Int = 0
    @Published var paVotes:Int = 0
    @Published var count:Int = 10
    @Published var gameId:String = ""
    @Published var gameStart:String = "Ready"
    @Published var winner = ""
    @Published var waitingStatus = "Waiting on opponent ..."
    @Published var disconnectMessage = "Opponent Disconnected"
    @Published var startGame:Bool = false
    @Published var endGame:Bool = false
    @Published var cancelled:Bool = false
    @Published var ready:Bool = false
    @Published var paPressed:Bool = false
    @Published var currPaPressed:Bool = false
    @Published var opp_disconnected:Bool = false
    @Published var is_a_tie:Bool = false
    @Published var ready_uped:Bool = false
    @Published var fColor:Color = Color(.yellow)
    @Published var sColor:Color = Color(.yellow)
    private enum coin_val:String {
        case Yellow = "yTapCoin"
        case Blue = "bTapCoin"
        case Red = "rTapCoin"
    }
    private var mSocket = GameHandler.sharedInstance.getSocket()
    private var connected:Bool = false
    private var startingGame:Bool = false
    private var curr_username = ""
    private var oppLeft:Bool = false
    private var time_is_up = false
    
    init(){
        if (from_queue ?? true){
            getUser()
            GameHandler.sharedInstance.establishConnection()
            first = first_player ?? "No First"
            second = second_player ?? "No Second"
            gameId = game_id ?? "No Game Id"
            mSocket.on("connected") {(dataArr, ack) -> Void in
                let is_connected = dataArr[0] as! String
                if (is_connected == "CONNECTED"){
                    if (self.connected == false){
                        if (self.gameId != "No Game Id"){
                            var gClient_data = ""
                            if (self.is_first ?? false){
                                gClient_data = self.gameId + "|" + self.first
                            }
                            else{
                                gClient_data = self.gameId + "|" + self.second
                            }
                            self.mSocket.emit("GAMEID", gClient_data)
                            self.connected = true
                        }
                    }
                }
            }
            mSocket.on("GAMEID") {(dataArr, ack) -> Void in
                let game_id_response = dataArr[0] as! String
                if (game_id_response == "SUCCESS"){
                    self.cancelled = true
                    self.second = self.second_player ?? "No Second"
                    self.waitingStatus = "Opponent connected"
                }
                else{
                    self.second = "Waiting"
                }
            }
            mSocket.on("TAP") {(dataArr, ack) -> Void in
                let tap_data = dataArr[0] as! String
                let tap_data_split = tap_data.split(separator: "|")
                let x_index = tap_data_split[0]
                let y_index = tap_data_split[1]
                let coin_v_index = x_index + y_index
                if (self.curr_username == self.first){
                    self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Red.rawValue
                    self.sPoints = self.sPoints + 1
                    let sum = self.fPoints + self.sPoints
                    if (sum == 35){
                        if (self.fPoints > self.sPoints){
                            self.endGame = true
                            self.winner = self.first
                            self.send_points()
                        }
                        else{
                            self.endGame = true
                            self.winner = self.second
                            self.send_points()
                        }
                    }
                }
                else{
                    self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Blue.rawValue
                    self.fPoints = self.fPoints + 1
                    let sum = self.fPoints + self.sPoints
                    if (sum == 35){
                        if (self.fPoints > self.sPoints){
                            self.endGame = true
                            self.winner = self.first
                            self.send_points()
                        }
                        else{
                            self.endGame = true
                            self.winner = self.second
                            self.send_points()
                        }
                    }
                }
            }
            mSocket.on("REMOVEDUSER") {(dataArr, ack) -> Void in
                let value = dataArr[0] as! String
                if value == "NEXT"{
                    GameHandler.sharedInstance.closeConnection()
                    self.in_queue = true
                    self.in_game = false
                }
                else if value == "HOME"{
                    GameHandler.sharedInstance.closeConnection()
                    self.in_game = false
                }
                else if value == "EXIT"{
                    GameHandler.sharedInstance.closeConnection()
                    self.in_game = false
                }
            }
            
            mSocket.on("READY") {(dataArr, ack) -> Void in
                let response = dataArr[0] as! String
                let user1_status = response.split(separator: "|")[0]
                let user2_status = response.split(separator: "|")[1]
                let ready_username = response.split(separator: "|")[2]
                if user1_status == "true"{
                    if String(ready_username) == self.first_player ?? "None"{
                        self.fColor = Color(.green)
                    }
                    else if String(ready_username) == self.second_player ?? "None"{
                        self.sColor = Color(.green)
                    }
                    if user2_status == "true"{
                        self.start_game(username: String(ready_username))
                    }
                }
                else{
                    if user2_status == "true"{
                        if String(ready_username) == self.second_player ?? "None"{
                            self.sColor = Color(.green)
                        }
                    }
                }
            }
            
            mSocket.on("CANCELLED") {(dataArr, ack) -> Void in
                self.waitingStatus = "Opponent disconnected"
            }
            
            mSocket.on("STARTCGAME") {(dataArr, ack) -> Void in
                self.ready_uped = true
                self.count_down()
            }
            
            mSocket.on("DISCONNECT") {(dataArr, ack) -> Void in
                self.disconnected()
            }
        } //from queue
        else{
            if custom_game ?? true{
                getUser()
                GameHandler.sharedInstance.establishConnection()
                first = first_player ?? "No First"
                gameId = game_id ?? "No Game Id"
                mSocket.on("connected") {(dataArr, ack) -> Void in
                    let is_connected = dataArr[0] as! String
                    if (is_connected == "CONNECTED"){
                        if (self.connected == false){
                            if (self.gameId != "No Game Id"){
                                var gClient_data = ""
                                if (self.is_first ?? false){
                                    gClient_data = self.gameId + "|" + (self.first_player ?? "Nothing")
                                }
                                else{
                                    gClient_data = self.gameId + "|" + (self.second_player ?? "Nothing")
                                }
                                self.mSocket.emit("GAMEID", gClient_data)
                                self.connected = true
                            }
                        }
                    }
                }
                mSocket.on("GAMEID") {(dataArr, ack) -> Void in
                    let game_id_response = dataArr[0] as! String
                    if (game_id_response == "SUCCESS"){
                        self.cancelled = true
                        self.second = self.second_player ?? "No Second"
                        self.waitingStatus = "Opponent connected"
                    }
                    else{
                        self.second = "Waiting"
                    }
                } // GAMEID Handler

                mSocket.on("DECLINED") {(dataArr, ack) -> Void in
                    self.waitingStatus = "Opponent declined"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.cancel_game(cancelled: true)
                    }
                }

                mSocket.on("READY") {(dataArr, ack) -> Void in
                    let response = dataArr[0] as! String
                    let user1_status = response.split(separator: "|")[0]
                    let user2_status = response.split(separator: "|")[1]
                    let ready_username = response.split(separator: "|")[2]
                    if user1_status == "true"{
                        if String(ready_username) == self.first_player ?? "None"{
                            self.fColor = Color(.green)
                        }
                        else if String(ready_username) == self.second_player ?? "None"{
                            self.sColor = Color(.green)
                        }
                        if user2_status == "true"{
                            self.start_game(username: String(ready_username))
                        }
                    }
                    else{
                        if user2_status == "true"{
                            if String(ready_username) == self.second_player ?? "None"{
                                self.sColor = Color(.green)
                            }
                        }
                    }
                }

                mSocket.on("STARTCGAME") {(dataArr, ack) -> Void in
                    self.custom_game = false
                    self.count_down()
                }

                mSocket.on("TAP") {(dataArr, ack) -> Void in
                    let tap_data = dataArr[0] as! String
                    let tap_data_split = tap_data.split(separator: "|")
                    let x_index = tap_data_split[0]
                    let y_index = tap_data_split[1]
                    let coin_v_index = x_index + y_index
                    if (self.curr_username == self.first){
                        self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Red.rawValue
                        self.sPoints = self.sPoints + 1
                        let sum = self.fPoints + self.sPoints
                        if (sum == 35){
                            if (self.fPoints > self.sPoints){
                                self.endGame = true
                                self.winner = self.first
                            }
                            else{
                                self.endGame = true
                                self.winner = self.second
                            }
                        }
                    }
                    else{
                        self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Blue.rawValue
                        self.fPoints = self.fPoints + 1
                        let sum = self.fPoints + self.sPoints
                        if (sum == 35){
                            if (self.fPoints > self.sPoints){
                                self.endGame = true
                                self.winner = self.first
                            }
                            else{
                                self.endGame = true
                                self.winner = self.second
                            }
                        }
                    }
                }
                mSocket.on("PLAYAGAIN") {(dataArr, ack) -> Void in
                    print("IN THE PLAY AGAIN HANDLER")
                    let data = dataArr[0] as! String
                    self.paVotes += 1
                    if self.paVotes == 2{
                        print("PLAY AGAIN VOTES == 2")
                        var dict = [String:String]()
                        for (key,_) in self.coin_values{
                            dict[key] = "yTapCoin"
                        }
                        self.coin_values = dict
                        self.gameStart = "READY"
                        self.startGame = false
                        self.fPoints = 0
                        self.sPoints = 0
                        self.endGame = false
                        self.paVotes = 0
                        self.count = 10
                        self.paPressed = false
                        self.currPaPressed = false
                        self.count_down()
                    }
                    else{
                        print("PLAY AGAIN VOTES == 1")
                        if data == self.curr_username{
                            print("THIS IS FOR THE CURRENT USERNAME")
                            self.waitingStatus = "Waiting on opponent ..."
                            self.paPressed = true
                            self.currPaPressed = true
                        }
                        else{
                            print("THIS IS NOT FOR THE CURRENT USERNAME")
                            self.waitingStatus = data + " voted play again"
                            self.paPressed = true
                        }
                    }
                }

                mSocket.on("OPPLEFT") {(dataArr, ack) -> Void in
                    print("IN OPP LEFT HANDLER")
                    let data = dataArr[0] as! String
                    self.oppLeft = true
                    self.paPressed = true
                    self.currPaPressed = true
                    self.waitingStatus = data + " has left"
                }

                mSocket.on("CANCELLED") {(dataArr, ack) -> Void in
                    self.waitingStatus = "Opponent disconnected"
                    self.paPressed = true
                    self.currPaPressed = true
                }
                
                mSocket.on("REMOVEDUSER") {(dataArr, ack) -> Void in
                    let value = dataArr[0] as! String
                    if value == "NEXT"{
                        GameHandler.sharedInstance.closeConnection()
                        self.in_queue = true
                        self.in_game = false
                    }
                    else if value == "HOME"{
                        GameHandler.sharedInstance.closeConnection()
                        self.in_game = false
                    }
                    else if value == "EXIT"{
                        GameHandler.sharedInstance.closeConnection()
                        self.in_game = false
                    }
                }
                
                mSocket.on("DISCONNECT") {(dataArr, ack) -> Void in
                    self.disconnected()
                }
            }
        }
    } //init
    
    deinit {
        GameHandler.sharedInstance.closeConnection()
        in_game = false
    }
    
    func start_game(username:String){
        mSocket.emit("STARTCGAME", username)
    }
    
    func count_down(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "SET"
            self.count_start()
        }
    }
    
    func count_start(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "START"
            self.startGame = true
        }
//        game_timer(game_time: 10)
    }
    
    func ready_up(username:String){
        mSocket.emit("READY", username)
        ready = true
        if username == first_player{
            self.fColor = Color(.green)
        }
        else if username == second_player{
            self.sColor = Color(.green)
        }
    }
    
    func sendTap(x:Int, y:Int){
        let x_index = String(x)
        let y_index = String(y)
        let coin_v_index = x_index + y_index
        let index_str = String(x) + "|" + String(y) + "*" + gameId
        mSocket.emit("TAP", index_str)
        if (curr_username == first){
            coin_values[String(coin_v_index)] = GameViewModel.coin_val.Blue.rawValue
            fPoints = fPoints + 1
            let sum = fPoints + sPoints
            if (sum == 35){
                if (fPoints > sPoints){
                    endGame = true
                    winner = first
                    send_points()
                }
                else{
                    endGame = true
                    winner = second
                    send_points()
                }
            }
        }
        else{
            coin_values[String(coin_v_index)] = GameViewModel.coin_val.Red.rawValue
            sPoints = sPoints + 1
            let sum = fPoints + sPoints
            if (sum == 35){
                if (fPoints > sPoints){
                    endGame = true
                    winner = first
                    send_points()
                }
                else{
                    endGame = true
                    winner = second
                    send_points()
                }
            }
        }
    }
    func getUser(){
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
                    self?.curr_username = response.username
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func send_points(){
//        guard let url = URL(string: ProcessInfo.processInfo.environment["sendPoints"]!) else{
//            return
//        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/sendPoints") else{
            return
        }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/sendPoints") else{
//            return
//        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "fPoints": fPoints,
            "sPoints": sPoints,
            "gameId": gameId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(GameOver.self, from: data)
                    if response.gameOver == true{
                        self?.ready = false
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func cancel_game(cancelled:Bool){
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/ad_invite") else{
//            return
//        }
        
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/ad_invite") else{
            return
        }
        
        guard let session = logged_in_user else{
            return
        }
        
        if waitingStatus == "Opponent connected"{
            mSocket.emit("CANCELLED", curr_username)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": self.second_player ?? "No Second",
            "token": session,
            "adRequest": "delete",
            "cancelled":cancelled
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(ADRequest.self, from: data)
                    if response.result == "Cancelled"{
                        self?.from_queue = false
                        self?.custom_game = false
                        self?.is_first = false
                        GameHandler.sharedInstance.closeConnection()
                        self?.in_game = false
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }

    func play_again(){
        self.mSocket.emit("PLAYAGAIN", curr_username)
        paPressed = true
        currPaPressed = true
    }
    
    func return_home(isCGame:Bool, exit:Bool){
        if isCGame{
            if !oppLeft{
                oppLeft = true
                mSocket.emit("OPPLEFT", curr_username)
                mSocket.emit("REMOVEGAMECLIENT", "HOME")
            }
            else{
                mSocket.emit("REMOVEGAMECLIENT", "HOME")
            }
        }
        else{
            if exit{
                mSocket.emit("REMOVEGAMECLIENT", "EXIT")
            }
            else{
                mSocket.emit("REMOVEGAMECLIENT", "HOME")
            }
        }
    }
    
    func next_game(){
        mSocket.emit("REMOVEGAMECLIENT", "NEXT")
    }
    
    func disconnected(){
        opp_disconnected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.return_home(isCGame: false, exit: false)
        }
    }
    
    func times_up(){
        if time_is_up == false{
            time_is_up = true
            if fPoints > sPoints{
                winner = first
            }
            else if sPoints > fPoints{
                winner = second
            }
            else{
                is_a_tie = true
                winner = "Nobody"
            }
            endGame = true
            send_points()
        }
    }
    
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let response: String
        let username: String
    }
    struct GameOver:Codable {
        let gameOver: Bool
    }
    struct ADRequest:Codable {
        let result: String
    }
    struct ISRequest:Codable {
        let status: String
    }

}
