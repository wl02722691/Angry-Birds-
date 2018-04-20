//
//  LevelScene.swift
//  bird
//
//  Created by 張書涵 on 2018/4/16.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    var SceneManagerDelegate:SceneManagerDelegate?

    override func didMove(to view: SKView) {
        setupLevelSelection()
    }
    
    func setupLevelSelection(){
        var level = 1
        let columnStartingPoint = frame.midX/2
        let rowStartingPoint = frame.midY + frame.midY/2
        //欄的位置
        for row in 0..<3{
            for column in 0..<3{
                //3*3做出9格
                let levelBoxButton = SpriteKitButton(defaultButtonImage: "woodButton", action: goToGameSceneFor, index: level)
                levelBoxButton.position = CGPoint(x:columnStartingPoint+CGFloat(column)*columnStartingPoint, y: rowStartingPoint - CGFloat(row) * frame.midY/2)
                levelBoxButton.zPosition = Zposition.hudBackground
                addChild(levelBoxButton)
        
                let levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
                levelLabel.fontSize = 200
                levelLabel.verticalAlignmentMode = .center
                levelLabel.text = "\(level)"
                levelLabel.zPosition = Zposition.hudLabel
                levelBoxButton.addChild(levelLabel)
                levelLabel.aspectScale(to: levelBoxButton.size, width: false, multiplier: 0.5)
                
                level += 1
                
            }
        }
    }

    func goToGameSceneFor(level:Int){
        SceneManagerDelegate?.presentGameSceneFor(level:level)
    }
}
