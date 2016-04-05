//
//  Meme.swift
//  MemeMe v1.0
//
//  Created by Hoff Henry Pereira da Silva on 24/08/15.
//  Copyright (c) 2015 Hoff Silva. All rights reserved.
//

import Foundation
import UIKit

class Meme{
    
    
    var top = ""
    var bottom = ""
    var orinalImage: UIImage!
    var memedImagem: UIImage!
    
    init( text: String, image: UIImage, memedImage: UIImage){
        orinalImage  = image
        memedImagem = image
        top = text
        bottom = text
    }
    
    func save() {
        //Create the meme
        var meme = Meme( text: top, image:orinalImage, memedImage: memedImagem)
    }
    
    
}