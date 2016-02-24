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

class GameScene: SKScene, ReactToMotionEvent {

    var gameStates : [SwipeGameState<SwipeGameTile>] = []
    var nodes : [SKNode] = []
    let ROWS = 3
    let COLUMNS = 4

    override func didMoveToView(view: SKView) {

        gameStates.append(self.loadNewGame())
        self.resetBoardLocations()

        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeUp(_:)))
        swipeUpRecognizer.direction = .Up
        self.view?.addGestureRecognizer(swipeUpRecognizer)

        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeDown(_:)))
        swipeDownRecognizer.direction = .Down
        self.view?.addGestureRecognizer(swipeDownRecognizer)

        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeLeft(_:)))
        swipeLeftRecognizer.direction = .Left
        self.view?.addGestureRecognizer(swipeLeftRecognizer)

        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeRight(_:)))
        swipeRightRecognizer.direction = .Right
        self.view?.addGestureRecognizer(swipeRightRecognizer)

        let resetRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.doubleTap(_:)))
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
            nodeLabel.userData = [ "tileNumber" : ROWS * COLUMNS + 10]
            nodes.append(nodeLabel)
            self.addChild(nodeLabel)

            let imageNode = SKSpriteNode(imageNamed: "1080pTestImage")
            imageNode.position = nodeLabel.position
            imageNode.zPosition = 0
            imageNode.userData = [ "tileNumber" : ROWS * COLUMNS + 11]
            nodes.append(imageNode)
            self.addChild(imageNode)
        } else {
            for i in 0 ..< ROWS {
                for j in 0 ..< COLUMNS {
                    if let gameTile = gameState.data[i*COLUMNS + j] {
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
            let row = destination / COLUMNS
            let column = destination % COLUMNS

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
        // todo determine good userAcceleration values to trigger undoMove()
        print("\(motion.userAcceleration.x) \(motion.userAcceleration.y) \(motion.userAcceleration.z)")
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

        let image = UIImage(imageLiteral: "1080pTestImage")
        var gameData : [SwipeGameTile?] = []
        for i in 0 ..< ROWS {
            for j in 0 ..< COLUMNS {
                let rect = CGRect(
                    x: j * (Int(self.frame.width) / COLUMNS),
                    y: i * (Int(self.frame.height) / ROWS),
                    width: Int(self.frame.width) / COLUMNS,
                    height: Int(self.frame.height) / ROWS
                )
                let tileImage = image.crop(rect)
                let tileNumber = i * COLUMNS + j + 1
                let gameTime = SwipeGameTile(image: tileImage, tileNumber: tileNumber)
                if (tileNumber != ROWS * COLUMNS) {
                    gameData.append(gameTime)
                }

            }
        }
        gameData.append(nil)
        let newGameState = try! SwipeGameState<SwipeGameTile>(rows: ROWS, columns: COLUMNS, data: gameData)

        let backgroundTexture = SKTexture(image: image.imageWithColorOverlay(UIColor.whiteColor()))
        let backgroundNode = SKSpriteNode(texture: backgroundTexture)
        backgroundNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)

        return newGameState.randomize()
    }

    func positionOf(row row: Int, column: Int, inFrame frame: CGRect) -> CGPoint {
        let tileHeight = Int(frame.height) / ROWS
        let tileWidth = Int(frame.width) / COLUMNS

        return CGPoint(x: column * tileWidth + tileWidth / 2, y: Int(frame.height) - (row * tileHeight + tileHeight / 2))
    }
}
