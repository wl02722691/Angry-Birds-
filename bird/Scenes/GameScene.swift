//
//  GameScene.swift
//  bird
//
//  Created by 張書涵 on 2018/3/19.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RoundState{
    case ready,flying,finished,animating
}

class GameScene: SKScene {
    var SceneManagerDelegate:SceneManagerDelegate?
    
    var mapNode = SKTileMapNode()
    
    let gameCamera = GameCamera()//建立遊戲鏡頭
    var panRecognizer = UIPanGestureRecognizer()//讓鏡頭用手指能移動
    var pinchRecognizer = UIPinchGestureRecognizer()//雙指縮放
    var maxScale:CGFloat = 0//雙指縮放最大scale
    var bird = Bird(type: .red)
    var birds = [
        Bird(type: .red),
        Bird(type: .yellow),
        Bird(type: .blue)
    ]
    let anchor = SKNode()
    
    var roundState = RoundState.ready //開場時設定為ready
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupLevel()
        setupGestureRecognizers()
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch roundState {
        case .ready:
            if let touch = touches.first{
                let location = touch.location(in: self)
                if bird.contains(location){
                    panRecognizer.isEnabled = false
                    bird.grabbed = true
                    bird.position = location
                }
            }
        case .flying:
            break
        case .finished:
            roundState = .animating
            guard let view = view else{ return }
            let moveCameraBackAction = SKAction.move(to: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), duration: 2.0)
            moveCameraBackAction.timingMode = .linear
            gameCamera.run(moveCameraBackAction, completion: {
                self.panRecognizer.isEnabled = true
                self.addBird()
            })
        case .animating:
            break
       
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if bird.grabbed{
                let location = touch.location(in: self)
                bird.position = location
            }
        
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //放開手時
        if bird.grabbed{
            gameCamera.setConstraints(with: self, and: mapNode.frame, to: bird)
            bird.grabbed = false
            bird.flying = true// physicsBody?.isDynamic = true
            roundState = .flying
            constraintToAnchor(active: false)
            
            //用applyImpulse加上重力在物件上
            let dx = anchor.position.x - bird.position.x
            let dy = anchor.position.y - bird.position.y
            let impulse = CGVector(dx: dx, dy: dy)
            bird.physicsBody?.applyImpulse(impulse)
            bird.isUserInteractionEnabled = false
        }
    }
    
    func setupGestureRecognizers() {
        guard let view = view else { return }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        //在觸動UIPanGestureRecognizer時會利用到@objc func pan(sender:UIPanGestureRecognizer)
        view.addGestureRecognizer(panRecognizer)
        
        
        //UIPinchGestureRecognizer時會利用到@objc @objc func pinch
        //讓他能兩指縮放功能
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    func setupLevel(){
        
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode{
            self.mapNode = mapNode
             maxScale = mapNode.mapSize.height/frame.size.height//雙指縮放最大height
             maxScale = mapNode.mapSize.width/frame.size.width//雙指縮放最大width
    
        }
        addCamera()
        
        for child in mapNode.children{
            if let child = child as? SKSpriteNode{
                guard let name = child.name else {continue}
                if !["wood","stone","glass"].contains(name) {continue}
                //如果不包含以上的字就繼續
                guard let type = BlockType(rawValue: name) else {continue}
                let block = Block(type: type)
                block.size = child.size
                block.position = child.position
                block.zRotation = child.zRotation
                block.zPosition = Zposition.obstacles
                block.creatPhysicsBody()
                mapNode.addChild(block)
                child.removeFromParent()
            }
        }
        
        let physicsRect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height - mapNode.tileSize.height )//讓鳥不要掉到底，而是在土的上面
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsRect)
        physicsBody?.categoryBitMask = PhysicsCategory.edge//设置物理体的标识符
        physicsBody?.contactTestBitMask = PhysicsCategory.bird | PhysicsCategory.block//设置可与哪一类的物理体发生碰撞
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
        anchor.position = CGPoint(x: mapNode.frame.midX/2, y: mapNode.frame.midY/2)
        addChild(anchor)
        addBird()
    }
    
    func addCamera(){
        guard let view = view else {return}
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)//gmaeCamera一開始的設定位置
        camera = gameCamera //resizeFill讀取camera = gameCamera
        gameCamera.setConstraints(with: self, and: mapNode.frame, to: gameCamera)
        }
    
    
    func addBird(){
        if birds.isEmpty{
            print("No more birds")
            return
        }
        
        bird = birds.removeFirst()
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)//物理範圍：鳥
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.all
        bird.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge //撞到東西時
        
        bird.physicsBody?.isDynamic = false
        bird.aspectScale(to: mapNode.tileSize, width: false, multiplier: 1.0)
        bird.position = anchor.position
        addChild(bird)
        
        constraintToAnchor(active: true)
        roundState = .ready
        }
    
    //設定constraintToAnchor，讓鳥最遠只能在自身大小三倍內移動
    func constraintToAnchor(active:Bool){
        if active{
            let singleRange = SKRange(lowerLimit: 0.0, upperLimit: bird.size.width*3)
            let positionConstrain = SKConstraint.distance(singleRange, to: anchor)
            bird.constraints = [positionConstrain]
        }else{
            bird.constraints?.removeAll()
            }
        }
    
    override func didSimulatePhysics() {
        guard let physicsBody = bird.physicsBody else{return}
        if roundState == .flying && physicsBody.isResting{
            //狀態是flying但物體已經不動
            gameCamera.setConstraints(with: self, and: mapNode.frame, to: nil)
            bird.removeFromParent()
            roundState = .finished
            }
        }
    }

extension GameScene:SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch mask {
        case PhysicsCategory.bird | PhysicsCategory.block,
             PhysicsCategory.block | PhysicsCategory.edge: //讓bird與block能夠溝通
            if let block = contact.bodyB.node as? Block{
                block.impact(with: Int(contact.collisionImpulse))
            }else if let block = contact.bodyA.node as? Block{
                block.impact(with: Int(contact.collisionImpulse))
            }
            
        case PhysicsCategory.block | PhysicsCategory.block:
            if let block = contact.bodyA.node as? Block{
                block.impact(with: Int(contact.collisionImpulse))
            }
            if let block = contact.bodyB.node as? Block{
                block.impact(with: Int(contact.collisionImpulse))
            }
        
        case PhysicsCategory.bird | PhysicsCategory.edge:
            bird.flying = false
   
        default:
            break
        }
    }
}


extension GameScene{

    @objc func pan(sender:UIPanGestureRecognizer) {
        guard let view = view else { return }
        let translation = sender.translation(in: view) * gameCamera.yScale //sender回傳手勢移動距離，存在translation
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x,
                                      y: gameCamera.position.y + translation.y)
        //手勢移動時，frame的移動計算方式，+-的方式是跟拖曳的方向有關
        sender.setTranslation(CGPoint.zero, in: view)
    }
    

    //雙點縮放
    @objc func pinch(sender:UIPinchGestureRecognizer){
        guard let view = view else {return}
        if sender.numberOfTouches == 2 { //有兩指點選螢幕的狀態下

            let locationInView = sender.location(in: view)
            let location = convertPoint(fromView: locationInView)

            if sender.state == .changed{

                let convertedScale = 1/sender.scale
                let newScale = gameCamera.yScale*convertedScale
                if newScale < maxScale && newScale > 0.5 {
                    gameCamera.setScale(newScale)
                }
               

                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = location - locationAfterScale
                //原本是這樣let locationDelta = CGPoint(x: location.x - locationAfterScale.x , y: location.y-locationAfterScale.y)但有Configuration的extension所以可以轉換為比較看得懂的方式
                let newPosition = gameCamera.position + locationDelta
                ////原本是這樣let newPosition = CGPoint(x: gameCamera.position.x + locationDelta.x, y: gameCamera.position.x + locationDelta.y)
                gameCamera.position = newPosition
                sender.scale = 1.0
                gameCamera.setConstraints(with: self, and: mapNode.frame, to: gameCamera)
                
            }
        }
    }
}



