//
//  GameScene.swift
//  bird
//
//  Created by 張書涵 on 2018/3/19.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mapNode = SKTileMapNode()
    
    let gameCamera = GameCamera()//建立遊戲鏡頭
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var maxScale:CGFloat = 0
    
    
    override func didMove(to view: SKView) {
        setupLevel()
        setupGestureRecognizers()
        }
    
    func setupGestureRecognizers() {
        guard let view = view else { return }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        //在觸動UIPanGestureRecognizer時會利用到@objc func pan(sender:UIPanGestureRecognizer)
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    func setupLevel(){
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode{
            self.mapNode = mapNode
            maxScale = mapNode.mapSize.height/frame.size.height
            
    
        }
        addCamera()
    }
    
    func addCamera(){
        guard let view = view else {return}
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)//gmaeCamera一開始的設定位置
        camera = gameCamera //resizeFill讀取camera = gameCamera
        gameCamera.setConstraints(with: self, and: mapNode.frame, to: gameCamera)
        }
    }


extension GameScene{

    @objc func pan(sender:UIPanGestureRecognizer) {
        guard let view = view else { return }
        let translation = sender.translation(in: view) * gameCamera.yScale//sender回傳手勢移動距離，存在translation
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x,
                                      y: gameCamera.position.y + translation.y)
        //手勢移動時，frame的移動計算方式，+-的方式是跟拖曳的方向有關
        sender.setTranslation(CGPoint.zero, in: view)
    }

    @objc func pinch(sender:UIPinchGestureRecognizer){
        let locationInView = sender.location(in: view)
        let location = convertPoint(fromView: locationInView)
        
        guard let view = view else {return}
        if sender.numberOfTouches == 2 {
            if sender.state == .changed{
                let convertedScale = 1/sender.scale
                let newScale = gameCamera.yScale*convertedScale
                if newScale < maxScale && newScale > 0.5{
                    gameCamera.setScale(newScale)
                }
                gameCamera.setScale(newScale)
                
                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = CGPoint(x: location.x - locationAfterScale.x , y: location.y-locationAfterScale.y)
                let newPosition = CGPoint(x: gameCamera.position.x + locationDelta.x, y: gameCamera.position.x + locationDelta.y)
                gameCamera.position = newPosition
                sender.scale = 1.0
                gameCamera.setConstraints(with: self, and: mapNode.frame, to: gameCamera)
            }
        }
    }
}



