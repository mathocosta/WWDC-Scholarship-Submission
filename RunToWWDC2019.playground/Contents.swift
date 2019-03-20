import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x: 0 , y: 0, width: 800, height: 600))
let scene = GameScene(size: sceneView.frame.size)
scene.scaleMode = .aspectFill
sceneView.presentScene(scene)
sceneView.showsPhysics = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
