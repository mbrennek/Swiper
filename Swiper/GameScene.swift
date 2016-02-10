//
//  GameScene.swift
//  Swiper
//
//  Created by Matt Brenneke on 12/1/15.
//  Copyright (c) 2015 Matt Brenneke. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var gameState : SwipeGameState<SwipeGameTile>?
    var nodes : [SKNode] = []
    let ROWS = 3
    let COLUMNS = 4

    override func didMoveToView(view: SKView) {

        gameState = self.loadNewGame()
        self.updateBoardLocations()

        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        swipeUpRecognizer.direction = .Up
        self.view?.addGestureRecognizer(swipeUpRecognizer)

        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        swipeDownRecognizer.direction = .Down
        self.view?.addGestureRecognizer(swipeDownRecognizer)

        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        swipeLeftRecognizer.direction = .Left
        self.view?.addGestureRecognizer(swipeLeftRecognizer)

        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        swipeRightRecognizer.direction = .Right
        self.view?.addGestureRecognizer(swipeRightRecognizer)

        let resetRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        resetRecognizer.numberOfTapsRequired = 2
        self.view?.addGestureRecognizer(resetRecognizer)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func updateBoardLocations() {
        self.removeChildrenInArray(nodes)

        guard let gameState = gameState else {
            return
        }

        if gameState.won() {
            let nodeLabel = SKLabelNode(fontNamed: "Chalkduster")
            nodeLabel.text = "You Won!"
            nodeLabel.fontSize = 200
            nodeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            nodeLabel.zPosition = 1
            nodes.append(nodeLabel)
            self.addChild(nodeLabel)

            let imageNode = SKSpriteNode(imageNamed: "1080pTestImage")
            imageNode.position = nodeLabel.position
            imageNode.zPosition = 0
            nodes.append(imageNode)
            self.addChild(imageNode)
        } else {
            for i in 0 ..< ROWS {
                for j in 0 ..< COLUMNS {
                    if let gameTile = gameState.data[i*COLUMNS + j] {
                        let spriteNode = SKSpriteNode(texture: SKTexture(image: gameTile.image))
                        spriteNode.position = positionOf(row: i, column: j, inFrame: self.frame)
                        spriteNode.zPosition = 0;
                        nodes.append(spriteNode)
                        self.addChild(spriteNode)

                        let nodeLabel = SKLabelNode(fontNamed: "Chalkduster")
                        nodeLabel.text = "\(gameTile.tileNumber)"
                        nodeLabel.fontSize = 32
                        let x = Int(self.frame.width / CGFloat(COLUMNS)) * j + 135
                        let y = Int(self.frame.height) - (Int(self.frame.height / CGFloat(ROWS)) * i + 125)
                        nodeLabel.position = CGPoint(x: x, y: y)
                        nodeLabel.zPosition = 1
                        nodes.append(nodeLabel)

                        self.addChild(nodeLabel)
                    }
                }
            }
        }
    }

    func swipeUp(recognizer: UISwipeGestureRecognizer) {
        gameState = gameState?.swipeUp()
        self.updateBoardLocations()
    }

    func swipeDown(recognizer: UISwipeGestureRecognizer) {
        gameState = gameState?.swipeDown()
        self.updateBoardLocations()
    }

    func swipeLeft(recognizer: UISwipeGestureRecognizer) {
        gameState = gameState?.swipeLeft()
        self.updateBoardLocations()
    }

    func swipeRight(recognizer: UISwipeGestureRecognizer) {
        gameState = gameState?.swipeRight()
        self.updateBoardLocations()
    }

    func doubleTap(recognizer: UITapGestureRecognizer) {
        gameState = gameState?.randomize()
        self.updateBoardLocations()
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
        let newGameState = SwipeGameState<SwipeGameTile>(rows: ROWS, columns: COLUMNS, data: gameData)

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
