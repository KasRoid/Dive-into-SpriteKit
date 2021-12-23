//
//  GameScene.swift
//  Race-on-Roads
//
//  Created by Kas Song on 12/23/21.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "road.jpg")
        background.zPosition = -1
        background.size = CGSize(width: frame.width, height: frame.height)
        addChild(background)
        
        guard let particle = SKEmitterNode(fileNamed: "Mud") else { fatalError() }
        particle.advanceSimulationTime(10)
        particle.position.x = frame.width
        addChild(particle)
    }
}
