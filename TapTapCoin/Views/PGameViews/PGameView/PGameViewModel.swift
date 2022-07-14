//
//  PGameViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
final class PGameViewModel: ObservableObject {
    @AppStorage("pGame") var pGame: String?
    @AppStorage("session") var logged_in_user: String?
    @Published var coins = [true, false, true, false, true, false, true, false, true, false]
    @Published var gameStart = "READY"
    @Published var username = ""
    @Published var winner = ""
    @Published var change1 = ""
    @Published var change2 = ""
    @Published var gameStarted = false
    @Published var endGame = false
    @Published var changing_diff = false
    @Published var fPoints = 0
    @Published var sPoints = 0
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
    private var opp_values = [String]()
    private var easyTime = 0.15
    private var mediumTime = 0.12
    private var hardTime = 0.1
    
    init(){
        getUser()
        set_opps()
        count_down()
    }
    
    func set_opps(){
        for (key,value) in coin_values{
            opp_values.append(key)
        }
    }
    
    func count_down(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "SET"
            self.startingGame()
        }
    }
    
    func startingGame(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "GO"
            self.startGame()
        }
    }
    
    func startGame(){
        gameStarted = true
        if (pGame == "Easy"){
            generate_index(wait:easyTime)
        }
        else if (pGame == "Medium"){
            generate_index(wait:mediumTime)
        }
        else if (pGame == "Hard"){
            generate_index(wait:hardTime)
        }
        
    }
    
    func user_tap(x:Int, y:Int){
        let c_Index = String(x) + String(y)
        coin_values[c_Index] = "bTapCoin"
        fPoints = fPoints + 1
        check_endGame()
    }
    
    func generate_index(wait:Double){
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            let index = Int.random(in: 0..<self.opp_values.count)
            self.computer_tap(index: index)
        }
    }
    
    func computer_tap(index:Int){
        if (pGame == "Easy"){
            if (self.coin_values[opp_values[index]] == "yTapCoin"){
                self.coin_values[opp_values[index]] = "rTapCoin"
                self.sPoints = self.sPoints + 1
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:easyTime)
                }
            }
            else{
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:easyTime)
                }
            }
        }
        else if (pGame == "Medium"){
            if (self.coin_values[opp_values[index]] == "yTapCoin"){
                self.coin_values[opp_values[index]] = "rTapCoin"
                self.sPoints = self.sPoints + 1
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:mediumTime)
                }
            }
            else{
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:mediumTime)
                }
            }
        }
        else if (pGame == "Hard"){
            if (self.coin_values[opp_values[index]] == "yTapCoin"){
                self.coin_values[opp_values[index]] = "rTapCoin"
                self.sPoints = self.sPoints + 1
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:hardTime)
                }
            }
            else{
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:hardTime)
                }
            }
        }
        else{
            pGame = "None"
        }
    }
    
    func check_endGame(){
        let sum = fPoints + sPoints
        if (sum == 35){
            if (fPoints > sPoints){
                winner = username
            }
            else{
                winner = "Computer"
            }
            endGame = true
        }
    }
    
    func getUser(){
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
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    self?.username = response.username
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func return_home(){
        pGame = "None"
    }
    
    func play_again(){
        var dict = [String:String]()
        for (key,_) in coin_values{
            dict[key] = "yTapCoin"
        }
        coin_values = dict
        gameStart = "READY"
        fPoints = 0
        sPoints = 0
        gameStarted = false
        endGame = false
        set_opps()
        count_down()
    }
    
    func change_difficulty(change:String){
        if (change == "Change"){
            changing_diff = true
            if (pGame == "Easy"){
                change1 = "Medium"
                change2 = "Hard"
            }
            else if (pGame == "Medium"){
                change1 = "Easy"
                change2 = "Hard"
            }
            else if (pGame == "Hard"){
                change1 = "Easy"
                change2 = "Medium"
            }
        }
        else{
            play_again()
            changing_diff = false
            pGame = change
        }
    }
    
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let response: String
        let username: String
    }
}
