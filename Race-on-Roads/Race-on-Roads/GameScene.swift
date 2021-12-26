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
    private var gameTimer: Timer?
    private let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    private var score = 0 {
        willSet {
            scoreLabel.text = "SCORE: \(newValue)"
        }
    }
    private let backgroundMusic = SKAudioNode(fileNamed: "firebrand")
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        scoreLabel.zPosition = 2
        scoreLabel.position.y = 100
        addChild(scoreLabel)
        score = 0
        
        physicsWorld.gravity = .zero
        setBackground()
        setParticles()
        setPlayer()
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.categoryBitMask = 1
        physicsWorld.contactDelegate = self
        addChild(backgroundMusic)
//        motionManager.startAccelerometerUpdates()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let accelerometerData = motionManager.accelerometerData else { return }
        let changeX = CGFloat(accelerometerData.acceleration.y) * 10
        let changeY = CGFloat(accelerometerData.acceleration.x) * 10
        player.position.x -= changeX
        player.position.y += changeY
        
        if abs(changeX) + abs(changeY) <= 2 {
            score += 1
        }
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
        let background = SKSpriteNode(imageNamed: "road")
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
    
    @objc
    private func createEnemy() {
        let randomDistribution = GKRandomDistribution(lowestValue: -350, highestValue: 350)
        let sprite = SKSpriteNode(imageNamed: "car")
        sprite.position = CGPoint(x: 300, y: randomDistribution.nextInt())
        sprite.name = "enemy"
        sprite.zPosition = 1
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.categoryBitMask = 0
        createBonus()
    }
    
    private func createBonus() {
        let randomDistribution = GKRandomDistribution(lowestValue: -350, highestValue: 350)
        let sprite = SKSpriteNode(imageNamed: "coin")
        sprite.position = CGPoint(x: 300, y: randomDistribution.nextInt())
        sprite.name = "bonus"
        sprite.zPosition = 1
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.categoryBitMask = 0
        sprite.physicsBody?.collisionBitMask = 0
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }
    }
    
    func playerHit(_ node: SKNode) {
        if node.name == "bonus" {
            score += 1
            node.removeFromParent()
            return
        }
        if let particles = SKEmitterNode(fileNamed: "Explosion") {
            particles.position = player.position
            particles.zPosition = 3
            addChild(particles)
        }
        
        let sound = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)
        run(sound)
        player.removeFromParent()
        backgroundMusic.removeFromParent()
        let gameOver = SKSpriteNode(imageNamed: "gameOver-1")
        gameOver.zPosition = 10
        addChild(gameOver)
    }
}
