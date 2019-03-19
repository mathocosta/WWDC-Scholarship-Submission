import PlaygroundSupport
import GameplayKit
import SpriteKit

class GameScene: SKScene {

    var runner: RunnerNode!
    var label: SKLabelNode!

    let longPressGesture = UILongPressGestureRecognizer()

    override func didMove(to view: SKView) {
        self.runner = RunnerNode()
        self.runner.setScale(8.0)
        self.runner.position = CGPoint(x: view.frame.size.width / 2,
                                      y: view.frame.size.height / 2)
        self.addChild(self.runner)

        self.longPressGesture.addTarget(self, action: #selector(GameScene.longPress))
        self.view?.addGestureRecognizer(self.longPressGesture)

        putMessage()
    }

    func putMessage() {
        self.label = SKLabelNode(fontNamed: "SF Regular")
        label.text = "Bom dia a todos"
        label.horizontalAlignmentMode = .left
        label.position = CGPoint(x: 0, y: 100)
        self.addChild(label)
    }

    func changeMessage(to text: String) {
        let singleLineMessage = SKLabelNode(text: text)
        self.label = singleLineMessage.multilined()
    }

    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        let longPressLocation = convertPoint(fromView: sender.location(in: self.view))

        if sender.state == .began {
            for child in self.children {
                if let shapeNode = child as? RunnerNode {
                    if shapeNode.contains(longPressLocation) {
                        print("Found!")
                    }
                }
            }
        } else if sender.state == .ended {
            print("ended")
        }
    }

    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }

    func touchDown(atPoint pos: CGPoint) {
        self.changeMessage(to: "Agora corre negão, tu precisa chegar \n logo lá, eu quero que quebre o texto \n e eu possa ver como fica isso aaaa")
    }

    func touchMoved(toPoint pos: CGPoint) {
    }

    func touchUp(atPoint pos: CGPoint) {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
    }
}

let sceneView = SKView(frame: CGRect(x: 0 , y: 0, width: 800, height: 600))
let scene = GameScene(size: sceneView.frame.size)
scene.scaleMode = .aspectFill
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
