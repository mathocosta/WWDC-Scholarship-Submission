import PlaygroundSupport
import GameplayKit
import SpriteKit

public class GameScene: SKScene {

    var runner: RunnerNode!
    var messageLabel: MessageLabel!

    let longPressGesture = UILongPressGestureRecognizer()

    var messageIndex = 0
    let messages = [
        "In a basic way, running is a method of locomotion that allows humans to move quickly on foot.",
        "It's a type of walking characterized by the fact that there's the moment where all the feet are above the ground.",
        "Running is part of human nature, we did it to survive and today we continue doing it, but with other goals as a health exercise or as a challenge itself.",
        "It's simple you have to repeat the same thing you do to walk, only in a faster way."
    ]

    public override func didMove(to view: SKView) {
        self.runner = RunnerNode()
        self.runner.setScale(8.0)
        self.runner.position = CGPoint(x: view.frame.size.width / 2,
                                       y: view.frame.size.height / 2)
        self.addChild(self.runner)

        self.longPressGesture.addTarget(self, action: #selector(GameScene.longPress))
        self.view?.addGestureRecognizer(self.longPressGesture)

        self.messageLabel = MessageLabel()
        self.messageLabel.position = CGPoint(x: 10, y: self.frame.height - 200)
        self.messageLabel.preferredMaxLayoutWidth = self.frame.width * 0.8
        self.messageLabel.text = self.messages[0]
        self.addChild(self.messageLabel)
    }

    func changeMessage(to text: String) {
        self.messageLabel.text = text
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

    func touchDown(atPoint pos: CGPoint) {
        self.messageIndex += 1
        self.changeMessage(to: self.messages[messageIndex])
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }

    public override func update(_ currentTime: TimeInterval) {
    }
}
