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
    private var baseGround: SKShapeNode!

    private var player: SKNode!
    private var joystick: SKNode!
    private var knob: SKNode!
    
    var joystickMoved = false
    var knobLimit : CGFloat = 50.0
    var nodeCount = 0
    
    var onGround = true
    var flag = false
    
    var initLocation = CGPoint(x: 0, y: 0)
    var obstacleSizes = [150,200,250,300]
    var colorSelections = [UIColor.systemGreen, UIColor.orange, UIColor.yellow, UIColor.systemPink, UIColor.systemPurple, UIColor.systemCyan, UIColor.systemMint, UIColor.systemBrown]
 
    var timer = Timer()
    var time = 2

    var timeInterval:TimeInterval = 0
    var playerSpeed = 10.0
    
    override func didMove(to view: SKView) {
        player = (self.childNode(withName: "player")!)
        joystick = (self.childNode(withName: "SKJoystick")!)
        knob = (joystick.childNode(withName: "knob"))
        
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
        baseGround.physicsBody?.collisionBitMask = 3
        baseGround.physicsBody?.categoryBitMask = 1
        baseGround.physicsBody?.angularDamping = 0
        baseGround.physicsBody?.linearDamping = 0
        baseGround.physicsBody?.friction = 0
        baseGround.physicsBody?.restitution = 0
        baseGround.physicsBody?.contactTestBitMask = 3
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
        // tapRecognizer.cancelsTouchesInView = false // can be added later

        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.createObstacle), userInfo: nil, repeats: true)
        
    }
    
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        if (onGround) {
            onGround = false
            let moveAction = SKAction.moveBy(x: 0, y: CGFloat(350), duration: 0.3)
            player.run(moveAction)

        } else {
            print("we're already on air")
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Once we detect the contact point of the 2 bodies, we determine which body is the one that is colliding by checking their names. Then, we checked its CGPoints y position. The Y position can be compared to the other body's Y pos to know exactly which side is colliding.
        
        // if bodyA's Y position >= bodyB's x position, bodyA is on top of bodyB and if not, it's underneath bodyB.
        
        // We need to determine which side is colliding, because we're changing the "onGround" variable. If the player collides a ground from "TOP" then it can jump again. However, if it collides to a node from another-side, it shall not jump. Otherwise bugs occur, and player jumps several times in a row.
        
        let firstContact = contact.bodyA.node?.name
        let secondContact = contact.bodyB.node?.name
        if ((firstContact == "baseGround" && secondContact!.contains("obstacle")) || (firstContact!.contains("obstacle") && secondContact == "baseGround")) {
            if (firstContact!.contains("obstacle")) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
        }
        if ((firstContact == "player" && (secondContact == "baseGround" || secondContact!.contains("obstacle")))) {
            if (contact.bodyA.node!.position.y >= contact.bodyB.node!.position.y) {
                onGround = true
            }
        }
        
        else if ((firstContact == "baseGround" || firstContact!.contains("obstacle")) && secondContact == "player" ) {
            if (contact.bodyA.node!.position.y <= contact.bodyB.node!.position.y) {
                onGround = true
            }
        }

    }
    
    @objc func createObstacle() {
        time = time - 1
        if (time == 0){
            
            if (flag) {
                // RIGHT OBSTACLE
                initLocation = CGPoint(x: 250, y: CGFloat(frame.maxY*0.96))
                //obstacle.fillColor = .systemMint
                flag = false

            } else {
                // LEFT OBSTACLE
                initLocation = CGPoint(x: -250, y: CGFloat(frame.maxY*0.96))
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: joystick!)
            joystickMoved = knob.frame.contains(location)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !joystickMoved {return}
        
        for touch in touches {
            let pos = touch.location(in: joystick)
            if knobLimit > abs(pos.x) {
                knob.position.x = pos.x
            } else {
                if (pos.x < 0) {
                    knob.position.x = -knobLimit
                } else {
                    knob.position.x = knobLimit
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            let centralize = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1)
            centralize.timingMode = .easeIn
            knob.run(centralize)
            joystickMoved = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let dTime = currentTime - timeInterval
        timeInterval = currentTime
        
        let xPos = Double(knob.position.x)
        let vector = CGVector(dx: dTime * xPos * playerSpeed, dy: 0)
        let act = SKAction.move(by:vector,duration: 0)
        player.run(act)
    }
    
}
