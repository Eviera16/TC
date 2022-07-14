//
//  BackButtonView.swift
//  TapTapCoin
//
//  Created by Eric Viera on 4/8/22.
//

import Foundation
import SwiftUI

struct BackButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            print("PRESSING BACK BUTTON")
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Back")
                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                .fontWeight(.bold)
                .foregroundColor(Color(.yellow))
                .background(Color(.red))
                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
        })
    }
}
