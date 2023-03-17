//
//  GameScene.swift
//  Hoops
//
//  Created by Jordan Barconey on 12/12/22.
//

import CoreMotion
import SpriteKit
import SwiftUI
import CoreHaptics

enum CollisionType: UInt32 {
    case player = 1
    case hoop = 4
}
var haptics: HapticScene?

class GameScene: SKScene, SKPhysicsContactDelegate {
    var motionManager: CMMotionManager?
    let player = SKSpriteNode(imageNamed: "Player")
    @State private var engine: CHHapticEngine?

    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Background")
        background.position = CGPoint(x: size.width/38 , y: size.height/20 )
        background.zPosition = -1
        addChild(background)
        
        let hoop = SKSpriteNode(imageNamed: "Hoop")
        hoop.name = "Hoop"
        hoop.position = CGPoint(x: size.width/2.4 , y:size.height/20)
        hoop.zPosition = 1
        
        addChild(hoop)
        hoop.physicsBody = SKPhysicsBody(texture: hoop.texture!, size: hoop.texture!.size())
//        hoop.physicsBody?.allowsRotation = false
//        hoop.physicsBody?.restitution = 0
//        hoop.physicsBody?.friction = 0
//        hoop.physicsBody?.affectedByGravity = false
        hoop.physicsBody?.isDynamic = false
        hoop.physicsBody?.categoryBitMask = CollisionType.hoop.rawValue
        hoop.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        hoop.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        
        player.name = "player"
        player.position.x  = frame.minX + 75
        player.zPosition = 1
        //        let playerRadius = player.frame.width / 2.0
        
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 0
        player.physicsBody?.friction = 0
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.hoop.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.hoop.rawValue
//        player.physicsBody?.contactTestBitMask = player.physicsBody?.collisionBitMask ??  0
        addChild(player)
        
        
        physicsBody = SKPhysicsBody (edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: -10, left: 0,
                                                                                bottom: 0, right: 0)))
        
       physicsWorld.contactDelegate = self
      
        
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
        
    }
    
    
    func collision(between player: SKNode, object: SKNode) {
        if object.name == "Hoop" {
            haptics?.prepareHaptics()
            haptics?.complexSuccess()
            destroy(player: player)
            player.position.x  = frame.minX + 75
            addChild(player)
            
        }
        
    }
    
    func destroy(player: SKNode) {
        if let explosive = SKEmitterNode(fileNamed: "Explosive") {
            explosive.position = player.position
            explosive.advanceSimulationTime(2)
            addChild(explosive)
        }
        player.removeFromParent()
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        haptics?.complexSuccess()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name  == "player" {
            collision(between: contact.bodyA.node! , object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "player" {
            collision(between: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        player.position.x  = frame.minX + 75
//        addChild(player)
//      
//    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -31, dy: accelerometerData.acceleration.x * 31)
            
            if player.position.y < frame.minY {
                player.position.y = frame.minY
            } else if player.position.y > frame.maxY {
                player.position.y = frame.maxY
            }
        }
        
    }
}
        
        
    
    

