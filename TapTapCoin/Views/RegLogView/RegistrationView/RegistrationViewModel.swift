//
//  RegistrationViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

final class RegistrationViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var confirm_password:String = ""
    @Published var first_name_error:Error_States?
    @Published var last_name_error:Error_States?
    @Published var username_error:Error_States?
    @Published var password_error:Error_States?
    @Published var is_fName_error:Bool = false
    @Published var is_lName_error:Bool = false
    @Published var is_uName_error:Bool = false
    @Published var is_password_error:Bool = false
    @Published var reg_pressed:Bool = false
    
    enum Error_States:String {
        case Required = "Required"
        case Invalid_Username = "Username already exists."
        case Password_Match = "Passwords must match."
    }
    
    func register(){
        reg_pressed = true
        is_fName_error = false
        is_lName_error = false
        is_uName_error = false
        is_password_error = false
        if check_errors(state: Error_States.Required, fName: first_name, lName: last_name, uName: username, p1: password, p2:confirm_password) == false{
            return
        }
//        guard let url = URL(string: ProcessInfo.processInfo.environment["register"]!) else{
//            return
//        }
        guard let url = URL(string: "https://tapcoin1.herokuapp.com/api/user/register") else{
            return
        }
//        guard let url = URL(string: "http://127.0.0.1:8000/api/user/register") else{
//            return
//        }
        
        if check_errors(state: Error_States.Password_Match, fName: first_name, lName: last_name, uName: username, p1: password, p2:confirm_password) == false{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "first_name":first_name,
            "last_name":last_name,
            "username":username,
            "password":password,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    self?.logged_in_user = response.token
                    self?.in_game = false
                }
                catch{
                    do {
                        let response2 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        if self?.check_errors(state: Error_States.Invalid_Username, fName: self?.first_name ?? "", lName: self?.last_name ?? "", uName: self?.username ?? "", p1: self?.password ?? "", p2:self?.confirm_password ?? "") == false{
                            return
                        }
                        else {
                            self?.is_fName_error = false
                            self?.is_lName_error = false
                            self?.is_uName_error = false
                            self?.is_password_error = false
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }
            
        })
        task.resume()
    }
    func check_errors(state:Error_States, fName:String, lName:String, uName:String, p1:String, p2:String) -> Bool{
        switch state {
        case .Required:
            is_fName_error = fName.count <= 0 ? true : false
            is_lName_error = lName.count <= 0 ? true : false
            is_uName_error = uName.count <= 0 ? true : false
            is_password_error = p1.count <= 0 ? true : p2.count <= 0 ? true : false
            first_name_error = Error_States.Required
            last_name_error = Error_States.Required
            username_error = Error_States.Required
            password_error = Error_States.Required
            if !is_fName_error && !is_lName_error && !is_uName_error && !is_password_error{
                return true
            }
            reg_pressed = false
            return false
        case .Invalid_Username:
            is_uName_error = true
            username_error = Error_States.Invalid_Username
            reg_pressed = false
            return false
        case .Password_Match:
            if p1 != p2{
                password_error = Error_States.Password_Match
                is_password_error = true
                reg_pressed = false
                return false
            }
            break
        }
        return true
    }
    struct Response:Codable {
        let response: String
        let token: String
        let username: String
    }
}
