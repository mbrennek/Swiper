//
//  GameScene.swift
//  Swiper
//
//  Created by Matt Brenneke on 12/1/15.
//  Copyright (c) 2015 Matt Brenneke. All rights reserved.
//

import SpriteKit
import GameController

protocol ReactToMotionEvent {
    func motionUpdate(motion: GCMotion) -> Void
}

private extension Selector {
    static let swipeUp = #selector(GameScene.swipeUp(_:))
    static let swipeDown = #selector(GameScene.swipeDown(_:))
    static let swipeLeft = #selector(GameScene.swipeLeft(_:))
    static let swipeRight = #selector(GameScene.swipeRight(_:))
    static let doubleTap = #selector(GameScene.doubleTap(_:))
}

class GameScene: SKScene, ReactToMotionEvent {

    var gameStates : [SwipeGameState<SwipeGameTile>] = []
    var nodes : [SKNode] = []
    var difficulty = GameDifficulty.Beginner {
        didSet {
            self.gameStates = [self.loadNewGame()]
            self.resetBoardLocations()
        }
    }
    var imageName = "1080pTestImage"

    override func didMoveToView(view: SKView) {

        gameStates.append(self.loadNewGame())
        self.resetBoardLocations()

        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: .swipeUp)
        swipeUpRecognizer.direction = .Up
        self.view?.addGestureRecognizer(swipeUpRecognizer)

        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: .swipeDown)
        swipeDownRecognizer.direction = .Down
        self.view?.addGestureRecognizer(swipeDownRecognizer)

        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: .swipeLeft)
        swipeLeftRecognizer.direction = .Left
        self.view?.addGestureRecognizer(swipeLeftRecognizer)

        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: .swipeRight)
        swipeRightRecognizer.direction = .Right
        self.view?.addGestureRecognizer(swipeRightRecognizer)

        let resetRecognizer = UITapGestureRecognizer(target: self, action: .doubleTap)
        resetRecognizer.numberOfTapsRequired = 2
        self.view?.addGestureRecognizer(resetRecognizer)

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.motionDelegate = self
    }

    func resetBoardLocations() {
        self.removeChildrenInArray(nodes)
        nodes.removeAll()

        guard let gameState = gameStates.last else {
            return
        }

        if gameState.won() {
            let nodeLabel = SKLabelNode(fontNamed: "Chalkduster")
            nodeLabel.text = "You Won!"
            nodeLabel.fontSize = 200
            nodeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            nodeLabel.zPosition = 1
            nodeLabel.userData = [ "tileNumber" : difficulty.rows() * difficulty.columns() + 10]
            nodes.append(nodeLabel)
            self.addChild(nodeLabel)

            let imageNode = SKSpriteNode(imageNamed: imageName)
            imageNode.position = nodeLabel.position
            imageNode.zPosition = 0
            imageNode.userData = [ "tileNumber" : difficulty.rows() * difficulty.columns() + 11]
            nodes.append(imageNode)
            self.addChild(imageNode)
        } else {
            for i in 0 ..< difficulty.rows() {
                for j in 0 ..< difficulty.columns() {
                    if let gameTile = gameState.data[i*difficulty.columns() + j] {
                        let spriteNode = SKSpriteNode(texture: SKTexture(image: gameTile.image))
                        spriteNode.position = positionOf(row: i, column: j, inFrame: self.frame)
                        spriteNode.zPosition = 0
                        spriteNode.userData = [ "tileNumber" : gameTile.tileNumber ]
                        nodes.append(spriteNode)
                        self.addChild(spriteNode)
                    }
                }
            }
        }
    }

    func updateBoardLocations(potentialState: SwipeGameState<SwipeGameTile>) {
        guard let lastState = gameStates.last else {
            return
        }

        if (lastState != potentialState) {
            gameStates.append(potentialState)
            let sourceIndex = potentialState.blankIndex()
            let gameTile = lastState.data[sourceIndex]
            let node = nodes.filter({ $0.userData!["tileNumber"] as? Int == gameTile?.tileNumber }).first

            let destination = lastState.blankIndex()
            let row = destination / difficulty.columns()
            let column = destination % difficulty.columns()

            let newPosition = self.positionOf(row: row, column: column, inFrame: self.frame)

            let moveAction = SKAction.moveTo(newPosition, duration: NSTimeInterval(0.2))
            node?.runAction(moveAction, completion: {
                if potentialState.won() {
                    self.resetBoardLocations()
                }
            })
        }

    }

    func motionUpdate(motion: GCMotion) {
        // @TODO determine good userAcceleration values to trigger undoMove()
//        print("\(motion.userAcceleration.x) \(motion.userAcceleration.y) \(motion.userAcceleration.z)")
    }

    func swipeUp(recognizer: UISwipeGestureRecognizer) {
        guard let lastState = gameStates.last else {
            return
        }
        self.updateBoardLocations(lastState.swipeUp())
    }

    func swipeDown(recognizer: UISwipeGestureRecognizer) {
        guard let lastState = gameStates.last else {
            return
        }
        self.updateBoardLocations(lastState.swipeDown())
    }

    func swipeLeft(recognizer: UISwipeGestureRecognizer) {
        guard let lastState = gameStates.last else {
            return
        }
        self.updateBoardLocations(lastState.swipeLeft())
    }

    func swipeRight(recognizer: UISwipeGestureRecognizer) {
        guard let lastState = gameStates.last else {
            return
        }
        self.updateBoardLocations(lastState.swipeRight())
    }

    func doubleTap(recognizer: UITapGestureRecognizer) {
        guard let lastState = gameStates.last else {
            return
        }

        gameStates.append(lastState.randomize())
        self.resetBoardLocations()
    }

    func undoMove() {
        if gameStates.count < 2 {
            return
        }
        let previousState = gameStates[gameStates.endIndex.predecessor().predecessor()]
        self.updateBoardLocations(previousState)
        gameStates.removeLast()
        gameStates.removeLast()
    }

    func loadNewGame() -> SwipeGameState<SwipeGameTile> {
        self.removeAllChildren()

        let image = UIImage(imageLiteral: imageName)
        var gameData : [SwipeGameTile?] = []
        for i in 0 ..< difficulty.rows() {
            for j in 0 ..< difficulty.columns() {
                let rect = CGRect(
                    x: j * (Int(self.frame.width) / difficulty.columns()),
                    y: i * (Int(self.frame.height) / difficulty.rows()),
                    width: Int(self.frame.width) / difficulty.columns(),
                    height: Int(self.frame.height) / difficulty.rows()
                )
                let tileImage = image.crop(rect)
                let tileNumber = i * difficulty.columns() + j + 1
                let gameTime = SwipeGameTile(image: tileImage, tileNumber: tileNumber)
                if (tileNumber != difficulty.rows() * difficulty.columns()) {
                    gameData.append(gameTime)
                }

            }
        }
        gameData.append(nil)
        let newGameState = try! SwipeGameState<SwipeGameTile>(rows: difficulty.rows(), columns: difficulty.columns(), data: gameData)

        let backgroundTexture = SKTexture(image: image.grayscaleImage().imageWithColorOverlay(.whiteColor()))
        let backgroundNode = SKSpriteNode(texture: backgroundTexture)
        backgroundNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)

        return newGameState.randomize()
    }

    func positionOf(row row: Int, column: Int, inFrame frame: CGRect) -> CGPoint {
        let tileHeight = Int(frame.height) / difficulty.rows()
        let tileWidth = Int(frame.width) / difficulty.columns()

        return CGPoint(x: column * tileWidth + tileWidth / 2, y: Int(frame.height) - (row * tileHeight + tileHeight / 2))
    }
}
