//
//  SwiftUIView.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-03.
//

import SwiftUI


struct SwiftUIView: View {
    @EnvironmentObject var audioManager: AudioManager
    var shakiraVM: MeditationViewModel
    
    var isPreview:Bool = false
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @Environment(\.dismiss) var dismiss
    
    let timer = Timer
        .publish(every: 0.5,  on: .main, in: .common)
        .autoconnect()
    var body: some View {
        
        ZStack{
            Image("Image-2")
                .resizable()
                .scaledToFill()
                .frame(width:UIScreen.main.bounds.width)
                .ignoresSafeArea()
            
            
            VStack(spacing: 32) {
                HStack{
                Button {
                    audioManager.stop()
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 37))
                        .foregroundColor(.white)
                    
                    
                        
                    
                }
                Spacer()
                }
            Text("Shakira")
                .font(.title)
                .foregroundColor(.black)
            Spacer()
                if let player = audioManager.player{
            VStack(spacing: 5){
                Slider(value: $value, in: 0...player.duration){
                    editing in
                    print("editing",editing)
                    isEditing = editing
                    
                    if !editing{
                        player.currentTime = value
                    }
                }
                    .accentColor(.black)
                
                HStack{
                    Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                    Spacer()
                    Text(DateComponentsFormatter.positional.string(from: player.duration - player.currentTime) ?? "0:00")
                }
                .font(.caption)
                .foregroundColor(.black)
            }
                
                HStack{
                    PlaybackControlButton(systeName: "repeat"){
                        
                }
                    Spacer()
                    PlaybackControlButton(systeName: "gobackward.10"){
                        player.currentTime  -= 10
                        
                }
                    Spacer()
                    PlaybackControlButton(systeName: audioManager.isPlaying ? "pause.circle.fill":"play.circle.fill",fontSize: 50){
                        audioManager.playPause()
                        
                }
                    Spacer()
                    PlaybackControlButton(systeName: "goforward.10"){
                        player.currentTime += 10
                        
                        
                }
                    Spacer()
                    PlaybackControlButton(systeName: "stop.fill"){
                        audioManager.stop()
                        dismiss()
                        
                 }
                    
                }
                    
                }
                
            }
        .padding(20)
        }
        .onAppear{
           // AudioManager.shared.startPlayer(track: shakiraVM.shakira.track,isPriview: isPreview)
            audioManager.startPlayer(track: shakiraVM.shakira.track,isPriview: isPreview)
        }
        .onReceive(timer) {_ in
            
            guard let player = audioManager.player,!isEditing else {return}
            
            value = player.currentTime
            
        }
        
}
}


struct SwiftUIView_Previews: PreviewProvider {
    static var shakiraVM = MeditationViewModel(shakira: Shakira.data)
    
    static var previews: some View {
        SwiftUIView(shakiraVM: shakiraVM,isPreview: true)
            .environmentObject(AudioManager())
    }
}
