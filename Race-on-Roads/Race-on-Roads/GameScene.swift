//
//  GameScene.swift
//  Race-on-Roads
//
//  Created by Kas Song on 12/23/21.
//

import CoreMotion
import GameplayKit
import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Properties
    private let player = SKSpriteNode(imageNamed: "player-motorbike")
    private var touchingPlayer = false
    private let motionManager = CMMotionManager()
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        setBackground()
        setParticles()
        setPlayer()
        motionManager.startAccelerometerUpdates()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let accelerometerData = motionManager.accelerometerData else { return }
        let changeX = CGFloat(accelerometerData.acceleration.y) * 10
        let changeY = CGFloat(accelerometerData.acceleration.x) * 10
        player.position.x -= changeX
        player.position.y += changeY
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        if tappedNodes.contains(player) {
            touchingPlayer = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchingPlayer, let touch = touches.first else { return }
        let location = touch.location(in: self)
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingPlayer = false
    }
}

// MARK: - UI
extension GameScene {
    func setBackground() {
        let background = SKSpriteNode(imageNamed: "road.jpg")
        background.zPosition = -1
        background.size = CGSize(width: frame.width, height: frame.height)
        addChild(background)
    }
    
    func setParticles() {
        guard let particle = SKEmitterNode(fileNamed: "Mud") else { fatalError() }
        particle.advanceSimulationTime(10)
        particle.position.x = frame.width
        addChild(particle)
    }
    
    private func setPlayer() {
        player.position.x = -frame.width / 2 + player.frame.width
        player.zPosition = 1
        addChild(player)
    }
}
