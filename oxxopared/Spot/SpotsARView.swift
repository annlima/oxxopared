//
//  SpotsARView.swift
//  oxxopared
//
//  Created by Azuany Mila Cerón on 24/04/24.
//


import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct ARViewContainer: UIViewRepresentable {
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView()
        // arView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // Start AR session
        let session = arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        session.run(config)
        // addcoaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
        
        
        Spots.loadSceneAsync(completion: { (result) in
                    do {
                        let spot1 = try result.get()
                        arView.scene.anchors.append(spot1)
                    }catch{
                        print("The AR view could not be loaded")
                    }
                    
                })
        
        Spots.loadSceneAsync() { result in
            switch result {
            case .success(let anchor):
                // Add the loaded scene to the ARView
                arView.scene.anchors.append(anchor)
            case .failure(let error):
                // Handle errors here
                print("Error loading scene: \(error.localizedDescription)")
            }
        }
        
        return arView
    }
        
    let text = MeshResource.generateText("hola")
    
}

struct SpotsARView: View {
    var body: some View {
        ARViewContainer()
    }
}

#Preview {
    SpotsARView()
}
