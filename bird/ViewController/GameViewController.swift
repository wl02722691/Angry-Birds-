//
//  GameViewController.swift
//  bird
//
//  Created by 張書涵 on 2018/3/19.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentLevelScene()
    func presentGameSceneFor(level:Int)
}



class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()


    }
    
}


extension GameViewController:SceneManagerDelegate{
    func presentMenuScene(){
        let menuScene = MenuScene()
        menuScene.SceneManagerDelegate = self
        
        present(scene: menuScene)
    }
    
    func presentLevelScene() {
        let levelScene = LevelScene()
        levelScene.SceneManagerDelegate = self
        present(scene: levelScene)
        
    }
    
    func presentGameSceneFor(level: Int) {
        let sceneName = "GameScene_\(level)"
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene{
            gameScene.SceneManagerDelegate = self
            
            present(scene: gameScene)
        }
        
    }
    
    func present(scene:SKScene){
        if let view = self.view as! SKView?{
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            
        }
    }
}









