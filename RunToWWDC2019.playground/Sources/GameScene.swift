import PlaygroundSupport
import GameplayKit
import SpriteKit

let allTexts = [
    0: [
        "In a basic way, running is a method of locomotion that allows humans to move quickly on foot.",
        "It's a type of walking characterized by the fact that there's the moment where all the feet are above the ground.",
        "Running is part of human nature, we did it to survive and today we continue doing it, but with other goals as a health exercise or as a challenge itself.",
        "It's simple you have to repeat the same thing you do to walk, only in a faster way."
    ],
    1: [
        "But how does something so simple, that people already learn when children can be so important and interesting to think about?",
        "There are factors that I think are the most common things most people know about, which are health-related.",
        "Did you know that run is a great way to help improve cardiovascular health?",
        "It is also proven that runners tend to sleep better, show signs of better psychological functioning and more focus during the day.",
        "Other studies indicate that exercise can help people cope with stress."
    ]
]

public class GameScene: SKScene {

    var runner: RunnerNode!

    var buttonNext: ButtonNode!

    var textsController: TextsController!

    let longPressGesture = UILongPressGestureRecognizer()
    
    public override func didMove(to view: SKView) {
        self.runner = RunnerNode()
        self.runner.setScale(8.0)
        self.runner.position = CGPoint(x: view.frame.size.width / 2,
                                       y: view.frame.size.height / 2)
        self.addChild(self.runner)

        self.longPressGesture.addTarget(self, action: #selector(GameScene.longPress))
        self.view?.addGestureRecognizer(self.longPressGesture)

        self.textsController = TextsController(scene: self)
        self.textsController.delegate = self
        self.textsController.start(with: allTexts[0]!)
        self.addChild(self.textsController.messageLabel)

        let defaultButtonSize = CGSize(width: 200, height: 70)
        self.buttonNext = ButtonNode(text: "Next", size: defaultButtonSize)
        self.buttonNext.position = CGPoint(x: (frame.width - defaultButtonSize.width / 2) - 50,
                                           y: (defaultButtonSize.height / 2) + 20)
        self.buttonNext.wasClicked = { [weak self] in
            self?.textsController.textShouldChangeToNext()
        }
        self.addChild(self.buttonNext)
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

    public override func update(_ currentTime: TimeInterval) {
    }

}

// MARK: - TextsControllerDelegate
extension GameScene: TextsControllerDelegate {

    func textPartEnded() {
        self.textsController.start(with: allTexts[1]!)
    }

}
