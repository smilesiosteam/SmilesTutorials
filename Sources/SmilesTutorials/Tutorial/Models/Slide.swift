//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 21/06/2023.
//

import Foundation

struct Slide {
    let title: String
    let subTitle: String
    let imageName: String?
    let animationName: String?
    
    init(title: String, subTitle: String, imageName: String? = nil, animationName: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.imageName = imageName
        self.animationName = animationName
    }
}
