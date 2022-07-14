//
//  LoginViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class LoginViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var testing:String = "Testing"
    @Published var is_error:Bool = false
    @Published var log_pressed:Bool = false
    @Published var user_error:Error_States?
    @Published var password_error:Error_States?
    
    enum Error_States:String {
        case Required = "Required"
        case No_Match_User = "Could not find username."
        case No_Match_Password = "Incorrect Password."
    }
    func login(){
        is_error = false
        log_pressed = true
        if check_errors(state: Error_States.Required, user:username, password:password) == false{
            testing = "Errors"
            return
        }
        
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        //          if let environment = "https://tapcoin1.herokuapp.com/api/user/login", let url = URL(string: environment){
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/login") else{
            return
        }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/login") else{
//            return
//        }
        testing = "Got link"
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username":username,
            "password":password
        ]
        testing = "Created body"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.testing = "Errors in data"
                }
                return
            }
            DispatchQueue.main.async {
                do {
                    self?.testing = "In do"
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    self?.logged_in_user = response.token
                    self?.in_game = false
                }
                catch{
                    self?.testing = "In first catch"
                    do{
                        self?.testing = "In second do"
                        let response2 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        let error_dict: NSDictionary = response2 as? NSDictionary ?? [
                            "user" : "No user",
                            "password" : "No password",
                        ]
                        let user_error = error_dict["user"] as? String ?? ""
                        let password_error = error_dict["password"] as? String ?? ""
                        
                        if user_error.count > 0{
                            if self?.check_errors(state: Error_States.No_Match_User, user:user_error, password:password_error) == false{
                                return
                            }
                            else {
                                self?.is_error = false
                            }
                        }
                        else{
                            if self?.check_errors(state: Error_States.No_Match_Password, user:user_error, password:password_error) == false{
                                return
                            }
                            else{
                                self?.is_error = false
                            }
                        }
                    }
                    catch{
                        self?.testing = "In second catch"
                        print(error)
                    }
                }
            }
        })
        task.resume()
    }
    
    func check_errors(state:Error_States, user:String, password:String) -> Bool{
        switch state {
        case .Required:
            if user.count <= 0{
                is_error = true
                log_pressed = false
                user_error = Error_States.Required
                password_error = Error_States.Required
                return false
            }
            else if password.count <= 0{
                is_error = true
                log_pressed = false
                user_error = Error_States.Required
                password_error = Error_States.Required
                return false
            }
            break
        case .No_Match_User:
            is_error = true
            log_pressed = false
            user_error = Error_States.No_Match_User
            password_error = Error_States.No_Match_Password
            return false
        case .No_Match_Password:
            log_pressed = false
            is_error = true
            user_error = Error_States.No_Match_User
            password_error = Error_States.No_Match_Password
            return false
        }
        return true
    }
    
    struct Response:Codable {
        let response: String
        let token: String
        let username: String
    }
    struct Error:Codable {
        let error: String
        let password: String
        let user: String
    }
}
