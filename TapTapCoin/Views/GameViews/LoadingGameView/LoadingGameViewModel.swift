//
//  LoadingGameViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
import Network
import SocketIO
final class LoadingGameViewModel: ObservableObject{
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @Published var loading_status:String = "Loading . . ."
    @Published var queue_pop:String = "_ players in queue"
    private var found_queue:Bool = false
    private var found_opponent:Bool = false
    private var got_first:Bool = false
    private var got_second:Bool = false
    private var got_gameId = false
    private var got_game = false
    private var connected = false
    private var checked_queue = false;
    private var creating_game = false;
    private var created_game = false;
    private var find_game_bool = false;
    private var sent_create2game = false;
    private var in_create2game = false;
    private var removed_from_queue = false;
    private var mSocket = QueueHandler.sharedInstance.getSocket()
    private var player1:String = "None"
    private var player2:String = "None"
    
    init() {
        custom_game = false
        QueueHandler.sharedInstance.establishConnection()
        mSocket.on("connected") {(dataArr, ack) -> Void in
            let is_connected = dataArr[0] as! String
            if (is_connected == "CONNECTED"){
                if (self.connected == false){
                    let token = self.logged_in_user ?? "None"
                    if (token != "None"){
                        self.mSocket.emit("PUTINQUEUE", token)
                        self.connected = true
                    }
                }
            }
        }
        mSocket.on("PUTINQUEUE") {(dataArr, ack) -> Void in
            let in_queue = dataArr[0] as! String
            let in_queue_arr = in_queue.split(separator: "|").map { String($0)}
            if (in_queue_arr[0] == "SUCCESS"){
                if (self.checked_queue == false){
                    self.mSocket.emit("CHECKQUEUE")
                    self.checked_queue = true
                    self.loading_status = "Finding Opponent"
                    self.queue_pop = in_queue_arr[1] + " players in queue."
                }
            }
        }
        mSocket.on("CHECKQUEUE") {(dataArr, ack) -> Void in
            let q_pop = dataArr[0] as! String
            self.queue_pop = q_pop + " players in queue."
            self.mSocket.emit("CHECKQUEUE")
        }
        mSocket.on("FOUNDGAME1") {(dataArr, ack) -> Void in
            if (self.find_game_bool == false){
                let found_game = dataArr[0] as! String
                let player_arr = found_game.split(separator: "|").map { String($0)}
                if (player_arr[0] == "PLAYER1"){
                    self.player1 = player_arr[1]
                }
                else if (player_arr[0] == "PLAYER2"){
                    self.player2 = player_arr[1]
                }
                if (self.player2 != "None"){
                    if (self.player1 != "None"){
                        self.find_game_bool = true
                        self.loading_game()
                    }
                }
            }
        }
        mSocket.on("FOUNDGAME2") {(dataArr, ack) -> Void in
            if (self.find_game_bool == false){
                let found_game = dataArr[0] as! String
                let player_arr = found_game.split(separator: "|").map { String($0)}
                if (player_arr[0] == "PLAYER1"){
                    self.player1 = player_arr[1]
                }
                else if (player_arr[0] == "PLAYER2"){
                    self.player2 = player_arr[1]
                }
                if (self.player2 != "None"){
                    if (self.player1 != "None"){
                        self.find_game_bool = true
                    }
                }
            }
        }
        mSocket.on("CREATE2GAME") {(dataArr, ack) -> Void in
            if (self.in_create2game == false){
                self.in_create2game = true
                self.loading_game()
            }
        }
        mSocket.on("LEFTQUEUE") {(dataArr, ack) -> Void in
            QueueHandler.sharedInstance.closeConnection()
            self.in_queue = false
            self.in_game = true
        }
        mSocket.on("DISCONNECT") {(dataArr, ack) -> Void in
            self.return_home()
        }
    }//init
    
    deinit {
        self.in_queue = false
    }
    
    func loading_game() {
        if (creating_game == false){
            creating_game = true;
            loading_status =  "Found Opponent"
            DispatchQueue.main.async { [weak self] in
                self?.getUser(token:self?.player1 ?? "None", this_user: 1)
            }
            DispatchQueue.main.async { [weak self] in
                self?.getUser(token: self?.player2 ?? "None", this_user: 2)
            }
            DispatchQueue.main.async { [weak self] in
                self?.createGame(first: self?.player1 ?? "None", second: self?.player2 ?? "None")
            }
            
        }
    }
    
    func createGame(first:String, second:String){
        
        guard let session = logged_in_user else{
            return
        }
        
        if first == "None"{
            return
        }
        else if second == "None"{
            return
        }
        
//        guard let url = URL(string: ProcessInfo.processInfo.environment["createGame"]!) else{
//            return
//        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/createGame") else{
            return
        }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/createGame") else{
//            return
//        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "first": first,
            "second": second,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Game_Id.self, from: data)
                    self?.game_id = response.gameId
                    self?.got_gameId = true
                    if (response.first == "True"){
                        self?.is_first = true
                        if (self?.sent_create2game == false){
                            self?.sent_create2game = true;
                            self?.mSocket.emit("CREATE2GAME", second)
                        }
                    }
                    else{
                        self?.is_first = false
                    }
                    if (self?.created_game ?? true == false){
                        if (self?.game_made() ?? true){
                            if (self?.removed_from_queue == false){
                                self?.removed_from_queue = true
                                self?.mSocket.emit("REMOVEFROMQUEUE")
                            }
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func getUser(token:String, this_user:Int){
        var username = ""
//        guard let url = URL(string: ProcessInfo.processInfo.environment["getUser"]!) else{
//            return
//        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/info") else{
            return
        }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/info") else{
//            return
//        }
        
        if token == "None" {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token": token
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    username = response.username
                    if (this_user == 1){
                        self?.got_first = true
                        self?.first_player = username
                    }
                    else{
                        self?.got_second = true
                        self?.second_player = username
                    }
                    if (self?.created_game == false){
                        if (self?.game_made() ?? false){
                            if (self?.removed_from_queue == false){
                                self?.removed_from_queue = true
                                self?.mSocket.emit("REMOVEFROMQUEUE")
                            }
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
        return
    }
    
    func game_made() -> Bool{
        if (got_first){
            if (got_second){
                if (got_gameId){
                    loading_status = "Created Game"
                    from_queue = true
                    created_game = true
                    return true
                }
            }
        }
        return false
    }
    
    func return_home(){
        QueueHandler.sharedInstance.closeConnection()
        in_queue = false
    }
    
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let response: String
        let username: String
    }
    
    struct Game_Id:Codable {
        let gameId: String
        let first: String
    }
}
