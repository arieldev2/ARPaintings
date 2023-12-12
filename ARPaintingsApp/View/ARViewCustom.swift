//
//  ARViewCustom.swift
//  ARPaintingsApp
//
//  Created by Ariel Ortiz on 12/4/23.
//

import Foundation
import ARKit
import RealityKit

class ARViewCustom: ARView, ARCoachingOverlayViewDelegate{
    
    var canPlace: Bool = false
    
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.delegate = self
#if !targetEnvironment(simulator)
        coachingOverlay.session = self.session
#endif
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .verticalPlane
        self.addSubview(coachingOverlay)
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("active")
        canPlace = false
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("deactivate")
        canPlace = true

        
        
    }
    
}
