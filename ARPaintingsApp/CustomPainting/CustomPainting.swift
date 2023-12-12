//
//  CustomPainting.swift
//  ARPaintingsApp
//
//  Created by Ariel Ortiz on 12/4/23.
//

import Foundation
import SwiftUI
import RealityKit

class CustomPainting{
    
    var image: UIImage
    var entity: ModelEntity?
    
    init(img: UIImage){
        self.image = img
        
        guard let imgTexture = img.cgImage else{return}
        
        var width: Float = 0
        var height: Float = 0
        let w = imgTexture.width
        let h = imgTexture.height
        
        if w > h{
            let h1 = convertSizePercentage(position: Float(h), size: Float(w))
            height = convertPercentageSize(percentage: h1, size: 1)
            width = 1
            
        }else if w == h{
            width = 1
            height = 1
        }else{
            let w1 = convertSizePercentage(position: Float(w), size: Float(h))
            width = convertPercentageSize(percentage: w1, size: 1)
            height = 1
        }
        
        let mul: Float = 0.7
        let mesh: MeshResource = .generatePlane(width: width * mul, depth: height * mul)
        var material = SimpleMaterial()
        material.color.texture = .init(.init(try! .generate(from: imgTexture, options: .init(semantic: .color))))
        self.entity = ModelEntity(mesh: mesh, materials: [material])

    }
    
    
    func convertPercentageSize(percentage: Float, size: Float) -> Float{
        return (percentage / 100) * size
    }
    
    func convertSizePercentage(position: Float, size: Float) -> Float{
        return (position * 100) / size
    }
}
