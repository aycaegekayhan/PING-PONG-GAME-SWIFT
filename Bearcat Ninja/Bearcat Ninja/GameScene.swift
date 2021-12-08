//
//  GameScene.swift
//  Bearcat Ninja
//
//  Created by Berk Çohadar on 11/18/21.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var obstacle: SKShapeNode!
    private var player: SKNode!
    // initialize obstacle array
    
    var baseGround: SKShapeNode!
    
    var flag = false
    var nodeCount = 0
    
    var timer = Timer()
    var time = 2
    
    var initLocation = CGPoint(x: 0, y: 0)
    
    var obstacleSizes = [100,150,200,250,300,350]
    var colorSelections = [UIColor.systemGreen, UIColor.orange, UIColor.yellow, UIColor.systemPink, UIColor.systemPurple, UIColor.systemCyan, UIColor.systemMint, UIColor.systemBrown]
    
    var onGround = true
    override func didMove(to view: SKView) {
        player = (self.childNode(withName: "player")!)
        
        let background = SKSpriteNode(imageNamed: "3")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = 0
        background.physicsBody?.friction = 0
        self.addChild(background)
        
        let initLocation = CGPoint(x: CGFloat(frame.midX), y: CGFloat(-self.frame.maxY))
        let baseSize = CGSize(width: self.frame.width, height: 120.0)
        baseGround = SKShapeNode(rectOf: baseSize, cornerRadius: CGFloat(10))
        baseGround.position = initLocation
        baseGround.fillColor = .systemGreen
        baseGround.physicsBody = SKPhysicsBody(rectangleOf: baseSize)
        baseGround.physicsBody!.affectedByGravity = false
        baseGround.physicsBody?.isDynamic = false
        baseGround.physicsBody?.collisionBitMask = 2
        baseGround.physicsBody?.categoryBitMask = 1
        baseGround.physicsBody?.angularDamping = 0
        baseGround.physicsBody?.linearDamping = 0
        baseGround.physicsBody?.friction = 0
        baseGround.physicsBody?.restitution = 0
        baseGround.physicsBody?.contactTestBitMask = 2
        baseGround.name = "baseGround"
        baseGround.zPosition = 2
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        self.physicsBody?.contactTestBitMask = 2
        self.physicsWorld.contactDelegate = self
        self.name = "gameArea"
        
        self.addChild(baseGround)
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        let longTapRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longTapRecognizer.minimumPressDuration = 0.2
        // tapRecognizer.cancelsTouchesInView = false // can be added later

        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)
        view.addGestureRecognizer(longTapRecognizer)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.createObstacle), userInfo: nil, repeats: true)
        
    }
    
    @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            print("Move! (location: \(recognizer.location(in: nil))")
        }
    }

    @objc func handleTap(recognizer: UIGestureRecognizer) {
        print("Jump! (location: \(recognizer.location(in: nil))")
        if (onGround) {
            onGround = false
            player.physicsBody?.applyImpulse(CGVector(dx:0,dy:250))
        } else {
            print("we're already on air")
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstContact = contact.bodyA.node?.name
        let secondContact = contact.bodyB.node?.name
        
        if ((firstContact == "player" && (secondContact == "baseGround" || secondContact!.contains("obstacle"))) || ((firstContact == "baseGround" || firstContact!.contains("obstacle")) && secondContact == "player" )) {
            onGround = true
        }

    }
    
    @objc func createObstacle() {
        time = time - 1
        if (time == 0){
            
            if (flag) {
                // RIGHT OBSTACLE
                initLocation = CGPoint(x: 250, y: CGFloat(frame.midY))
                //obstacle.fillColor = .systemMint
                flag = false

            } else {
                // LEFT OBSTACLE
                initLocation = CGPoint(x: -250, y: CGFloat(frame.midY))
                //obstacle.fillColor = .systemBrown
                flag = true
            }
            time = 2
            nodeCount+=1
            let randomSize = Int.random(in: 0..<obstacleSizes.count)       //making obstacle size random
            let obstacleWidth = obstacleSizes[randomSize]
            
            let randomColor = Int.random(in: 0..<colorSelections.count)       //making obstacle color random
            
            let obstacleSize = CGSize(width: CGFloat(obstacleWidth), height: 40.0)
            obstacle = SKShapeNode(rectOf: obstacleSize, cornerRadius: CGFloat(10))
            obstacle.name = "obstacle"+String(nodeCount)
            obstacle.position = initLocation
            obstacle.zPosition = 1
            obstacle.fillColor = colorSelections[randomColor]
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacleSize)
            obstacle.physicsBody?.affectedByGravity = false
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.collisionBitMask = 1
            obstacle.physicsBody?.categoryBitMask = 1
            obstacle.physicsBody?.contactTestBitMask = 2
            
            self.addChild(obstacle)
            obstacle.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -obstacleWidth/3))
        }
    }
    
}
