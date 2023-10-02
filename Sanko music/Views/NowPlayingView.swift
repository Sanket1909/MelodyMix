//
//  SwiftUIView.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-03.
//

import SwiftUI


struct SwiftUIView: View {
    @EnvironmentObject var audioManager: AudioManager
    @StateObject var shakiraVM: MeditationViewModel = MeditationViewModel(artists: artistsData)
    var isPreview:Bool = false
    var selectedArtist: Artist  
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @Environment(\.dismiss) var dismiss
    
    let timer = Timer
        .publish(every: 0.5,  on: .main, in: .common)
        .autoconnect()
    var body: some View {
        
        ZStack{
            LinearGradient(
                         gradient: Gradient(colors: [Color(red: 0.8, green: 0.8, blue: 0.8), Color(red: 0.6, green: 0.6, blue: 0.6)]),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing
                     )
                     .edgesIgnoringSafeArea(.all)
            Image(selectedArtist.image)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250) 
                .clipShape(Circle()) 
                .padding(8)
                .shadow(color: Color.gray.opacity(0.6), radius: 5,x:5,y:5)
                .shadow(color: Color.black, radius: 5,x:5,y:-5)
               
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .scaleEffect(1 + abs(sin(Date().timeIntervalSince1970 * 2))) 
                        .opacity(0.5)
                        .frame(width: 160, height: 260) 
                )
                .overlay(
                    Circle()
                        .stroke(Color.green, lineWidth: 2)
                        .scaleEffect(1 + abs(cos(Date().timeIntervalSince1970 * 2))) 
                        .opacity(0.5)
                        .frame(width: 150, height: 270) 
                )
            VStack(spacing: 32) {
                HStack{
                    Button {
                        audioManager.stop()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 37))
                            .foregroundColor(.white)
                            
                            .shadow(color: Color.black, radius: 5,x:5,y:5)
                        
                        
                        
                        
                    }
                    Spacer()
                }
                Text(selectedArtist.name)
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
                        
                        HStack {
                            Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                                .font(.caption)
                                .foregroundColor(.black)
                            Spacer()
                            Text(DateComponentsFormatter.positional.string(from: player.duration - player.currentTime) ?? "0:00")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10)) 
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.3), radius: 5, x: -5, y: -5)

                    }
                    ZStack{
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
                    } .shadow(color: Color.black, radius: 5,x:5,y:5)
                    
                }
                
            }
            .padding(20)
        }
        .onAppear{
           
            audioManager.startPlayer(track: selectedArtist.songs[0].track, isPriview: true)
        }
        .onReceive(timer) {_ in
            
            guard let player = audioManager.player,!isEditing else {return}
            
            value = player.currentTime
            
        }
        
    }
}




