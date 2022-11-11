//
//  AudioManager.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-08.
//

import Foundation
import AVKit

final class AudioManager : ObservableObject{
    
    static let shared = AudioManager()
    
    var player: AVAudioPlayer?
    @Published private(set) var isPlaying:Bool = false{
        didSet{
            print("isPlaying",isPlaying)
        }
    }
    
    func startPlayer(track: String,isPriview:Bool = false){
        
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else{
            print("Resource not found:\(track)")
                  return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
           player = try AVAudioPlayer(contentsOf: url)
            
            if isPriview{
                player?.prepareToPlay()
            }else{
                
                player?.play()
                isPlaying = true
            }
            
            
                    } catch  {
            print("Fail to initialize" , error)
        }
    }
        
        func playPause(){
            
            
            guard let player = player else {
                print("audio player not found")
                return
            }
            if player.isPlaying{
                player.pause()
                isPlaying = false
            }else{
                player.play()
                isPlaying = true
            }

        }
    
    func stop(){
        guard let player = player else {
            return
        }
        if player.isPlaying{
            player.stop()
            isPlaying = false
        }

    }
    
}

