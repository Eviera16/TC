//
//  PMenuViewModel.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

final class PMenuViewModel: ObservableObject{
    @AppStorage("pGame") var pGame: String?
    
    func got_difficulty(diff:String){
        pGame = diff
    }
}
