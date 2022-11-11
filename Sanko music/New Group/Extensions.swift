//
//  Extensions.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-08.
//

import Foundation

extension DateComponentsFormatter{
    static let  abbreviated: DateComponentsFormatter = {
        print("Initializing DateComponentsFormatter.abbreviated")
        let forematter = DateComponentsFormatter()
        
        forematter.allowedUnits = [.hour, .minute,.second]
        forematter.unitsStyle = .abbreviated
        
        return forematter
    }()
    static let  positional: DateComponentsFormatter = {
        print("Initializing DateComponentsFormatter.positional")
        let forematter = DateComponentsFormatter()
        
        forematter.allowedUnits = [ .minute,.second]
        forematter.unitsStyle = .positional
        forematter.zeroFormattingBehavior = .pad
        
        return forematter
    }()
    
    
    
}
