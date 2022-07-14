//
//  SoundManager.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/27/22.
//

import Foundation
import AVKit

class SoundManager{
    
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(){
        print("IN PLAY SOUND FUNCTION")
        guard let url = Bundle.main.url(forResource: "coin-sound", withExtension: "mp3") else { return }
        print("NOT RETURN FROM URL")
        print(url)
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                options: AVAudioSession.CategoryOptions.mixWithOthers
            )
            
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("PLAYED SOUND?")
        }
        catch let error{
            print("NO SOUND: \(error.localizedDescription) ******")
        }
    }
}
