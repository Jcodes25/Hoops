//
//  Haptics.swift
//  Hoops
//
//  Created by Jordan Barconey on 12/19/22.
//

import CoreHaptics
import SwiftUI
import SpriteKit

//class HapticScene: SKScene, SKPhysicsContactDelegate {
class HapticScene: CHHapticEngine  {
    
    @State  var engine:  CHHapticEngine?
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch{
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
        
    }
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, through: 1, by: 0.1) {
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0 + i)
            events.append(event)
        }
        
//        for i in stride(from: 0, through: 1, by: 0.1) {
//
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
//            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0 + i)
//            events.append(event)
//        }
        
        
        
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters:[])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern \(error.localizedDescription)")
        }
    }
    
}





