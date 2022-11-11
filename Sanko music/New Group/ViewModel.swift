//
//  ViewModel.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-07.
//

import Foundation
import UIKit

final class MeditationViewModel: ObservableObject{
    
    private(set) var shakira:Shakira
    
    init(shakira:Shakira){
        self.shakira = shakira
    }
}

struct Shakira {
    
    let id = UUID()
    let title: String
   
    let duration: TimeInterval
    let track: String
    let image: String
    
    
    static let data = Shakira (title: "Shakira", duration: 80, track:"Shakira_ft_Wyclef_Jean_-_Hips_Dont_Lie_[NaijaGreen.Com]_" , image: "Image-2")
}
