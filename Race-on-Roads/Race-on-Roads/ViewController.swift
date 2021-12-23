//
//  ViewController.swift
//  Race-on-Roads
//
//  Created by Kas Song on 12/23/21.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = SKView()
        guard let view = view as? SKView,
              let scene = SKScene(fileNamed: "GameScene") else { fatalError() }
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        view.preferredFramesPerSecond = 120
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
