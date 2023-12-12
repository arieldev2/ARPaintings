//
//  ARViewCustom.swift
//  ARPaintingsApp
//
//  Created by Ariel Ortiz on 12/4/23.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit


struct ARRepresentable: UIViewRepresentable {
    
    @Binding var selectedModel: CustomPainting?
    
    func makeUIView(context: Context) -> ARViewCustom {
        let arView = ARViewCustom(frame: .zero)
        self.setupARView(ar: arView)
        arView.addCoaching()
        context.coordinator.view = arView
        context.coordinator.setupGestures()
        return arView
    }
    
    func updateUIView(_ uiView: ARViewCustom, context: Context) {
        if let mod = selectedModel{
            context.coordinator.model = mod
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func setupARView(ar: ARView){
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical]
        config.environmentTexturing = .automatic
        config.isLightEstimationEnabled = true
        
        ar.environment.sceneUnderstanding.options.insert([.occlusion])
        ar.environment.sceneUnderstanding.options.insert(.receivesLighting)
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        ar.renderOptions = [.disableMotionBlur,
                            .disableDepthOfField]
        ar.session.run(config)
    }
    
}


class Coordinator: NSObject{
        
    weak var view: ARViewCustom?
    var model: CustomPainting?
    
    func setupGestures() {
        guard let view = self.view else{
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let view = self.view else{
            return
        }
        
        if !view.canPlace{
            print("can't place")
            return
        }
        
        guard let touchInView = sender?.location(in: view) else{
            return
        }
        
        if let entity = view.entity(at: touchInView){
            entity.anchor?.removeFromParent()
            
        }else{
            rayCastingMethod(point: touchInView)
        }
        
        
    }
    
    func rayCastingMethod(point: CGPoint) {
        
        guard let view = self.view, let mod = self.model, let entity = mod.entity else{
            return
        }
        
        let raycast = view.raycast(from: point, allowing: .estimatedPlane, alignment: .any)
        
        if let ray = raycast.first{
            
            let anchor = AnchorEntity(world: ray.worldTransform)
            
            entity.generateCollisionShapes(recursive: true)
            anchor.addChild(entity.clone(recursive: true))
            
            let directionalLight = DirectionalLight()
            directionalLight.light.color = .white
            directionalLight.light.intensity = 10000
            directionalLight.shadow?.maximumDistance = 5
            directionalLight.shadow?.depthBias = 1
            directionalLight.look(at: [1,0,1], from: [0,1,0], relativeTo: nil)
            
            anchor.addChild(directionalLight)
            view.scene.addAnchor(anchor)
            
        }
        
    }
    

}


