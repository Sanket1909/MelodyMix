//
//  ViewModel.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-07.
//

import Foundation
import UIKit


final class MeditationViewModel: ObservableObject {
    @Published var artists: [Artist]
    @Published var selectedArtist: Artist?
    
    init(artists: [Artist]) {
        self.artists = artists
    }
}


struct Shakira {
    
    let id = UUID()
    let title: String
   
    let duration: TimeInterval
    let track: String
    let image: String
    
    
    static let data = Shakira (title: "Shakira", duration: 80, track:"Shakira_ft_Wyclef_Jean_-_Hips_Dont_Lie_[NaijaGreen.Com]_" , image: "shakira")
}

struct Artist:Identifiable  {
    let id = UUID()
    let name: String
    let image: String
    let songs: [Song]
}

struct Song {
        let title: String
        let duration: TimeInterval
        let track: String
        let image: String
}

let artist1 = Artist(name: "Shakira", image: "shakira", songs: [
    Song(title: "Latest Song", duration: 180, track: "Shakira_ft_Wyclef_Jean_-_Hips_Dont_Lie_[NaijaGreen.Com]_", image: "Image-1"),
   
    
])

let artist2 = Artist(name: "Justin Bieber", image: "justin", songs: [
    Song(title: "Latest Song", duration: 200, track: "justin", image: "Image-1"),
    
])
let artist3 = Artist(name: "50-Cent", image: "50cent", songs: [
    Song(title: "Latest Song", duration: 200, track: "50-cent", image: "Image-1"),
    
])
let artist4 = Artist(name: "ColdPlay", image: "coldplay", songs: [
    Song(title: "Latest Song", duration: 200, track: "coldplay", image: "Image-1"),
    
])
let artist5 = Artist(name: "Taylor Swift ", image: "taylor", songs: [
    Song(title: "Latest Song", duration: 200, track: "taylor", image: "Image-1"),
    
])
let artist6 = Artist(name: "Maroon-5 ", image: "maroon", songs: [
    Song(title: "Latest Song", duration: 200, track: "maroon-5", image: "Image-1"),
    
])
let artist7 = Artist(name: "Eminem", image: "eminem", songs: [
    Song(title: "Latest Song", duration: 200, track: "eminem", image: "Image-1"),
    
])
let artist8 = Artist(name: "Daddy-Yankee", image: "daddyyankee", songs: [
    Song(title: "Latest Song", duration: 200, track: "daddy-yankee", image: "Image-1"),
    
])
let artist9 = Artist(name: "Selena Gomez", image: "selena", songs: [
    Song(title: "Latest Song", duration: 200, track: "selena", image: "Image-1"),
    
])
let artist10 = Artist(name: "Lil Nas x", image: "lilnas", songs: [
    Song(title: "Latest Song", duration: 200, track: "lil-nas", image: "Image-1"),
    
])







let artistsData = [artist1, artist2,artist3,artist4,artist5,artist6,artist7,artist8,artist9,artist10]

