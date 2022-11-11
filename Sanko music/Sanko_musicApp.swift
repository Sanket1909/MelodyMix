//
//  Sanko_musicApp.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-03.
//

import SwiftUI

@main
struct Sanko_musicApp: App {
    @StateObject var audioManager = AudioManager()
    var body: some Scene {
        WindowGroup {
            MainMessagesView( shakiraVM: MeditationViewModel(shakira: Shakira.data))
                .environmentObject(audioManager)
        }
    }
}
