//
//  ViewController.swift
//  Spot-The-Odd-One-Out
//
//  Created by Doyoung Song on 12/27/21.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension ViewController {
    private func setupView() {
        view = SKView()
        guard let view = view as? SKView else { fatalError() }
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        view.presentScene(scene)
    }
}
