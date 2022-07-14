//
//  GameHandler.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SocketIO

class GameHandler: NSObject{
    static let sharedInstance = GameHandler()
//    let socket = SocketManager(socketURL: URL(string: ProcessInfo.processInfo.environment["gameSocket"]!)!, config: [.log(true), .compress])
    let socket = SocketManager(socketURL: URL(string: "https://tapped-game.herokuapp.com")!, config: [.log(true), .compress])
//    let socket = SocketManager(socketURL: URL(string: "http://127.0.0.1:4567")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!
    override init(){
        super.init()
        mSocket = socket.defaultSocket
    }
    
    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection(){
        mSocket.connect()
    }

    func closeConnection(){
        mSocket.disconnect()
    }
}
