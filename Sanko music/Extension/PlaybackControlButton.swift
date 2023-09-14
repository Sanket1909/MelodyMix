//
//  PlaybackControlButton.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-07.
//

import SwiftUI

struct PlaybackControlButton: View {
    var systeName: String = "play"
    var fontSize : CGFloat = 24
    var color: Color = .white
    var action: () -> Void
    var body: some View {
        Button{
            action()
        } label: {
            Image(systemName: systeName)
                .font(.system(size: fontSize))
                .foregroundColor(color)
        }
    }
}

struct PlaybackControlButton_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackControlButton( action: {})
    }
}
