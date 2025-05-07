//
//  PlayBackButtonControl.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 08/11/1446 AH.
//

import SwiftUI

struct PlayBackButtonControl: View {
    
    var systemName: String = "play"
    var fontSize: CGFloat = 24
    var color: Color = .pigOrange
    var action: ()-> Void
    
    var body: some View {
        
        Button{
            action()
            
        }label: {
            Image(systemName: systemName)
                .font(.system(size: fontSize))
                .foregroundColor(Color.pigOrange)
        }
    }
}

#Preview {
    PlayBackButtonControl(action: {})
        .preferredColorScheme(.light)
}
