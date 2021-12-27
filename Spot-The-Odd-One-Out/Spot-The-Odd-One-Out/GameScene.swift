//
//  GameScene.swift
//  Spot-The-Odd-One-Out
//
//  Created by Doyoung Song on 12/27/21.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background-leaves")
        background.name = "background"
        background.zPosition = -1
        addChild(background)
        createGrid()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension GameScene {
    private func createGrid() {
        let width = size.width
        let height = size.height
        let xOffset = Int(-width / 2.5)
        let yOffset = Int(-height / 9)
        print(yOffset)
//        let yOffset = -100
        
        for row in 0..<8 {
            for col in 0..<12 {
                let item = SKSpriteNode(imageNamed: "elephant")
                item.size = CGSize(width: width / 20, height: width / 20)
                item.position = CGPoint(x: xOffset + (col * 56), y: yOffset + (row * 42))
                addChild(item)
            }
        }
    }
}
