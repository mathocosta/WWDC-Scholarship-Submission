import PlaygroundSupport
import GameplayKit
import SpriteKit

public class GameScene: SKScene {

    // MARK: - Properties

    var runner: RunnerNode!

    var buttonNext: ButtonNode!

    var allTextsIndex = 0
    var allTexts: [TextPart]!
    var textsController: TextsController!

    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer()
        recognizer.addTarget(self, action: #selector(GameScene.onLongPress(_:)))
        recognizer.isEnabled = false

        return recognizer
    }()

    lazy var swipeGesture: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.addTarget(self, action: #selector(GameScene.onSwipe(_:)))
        recognizer.isEnabled = false

        return recognizer
    }()

    // MARK: - Life cycle

    public override func didMove(to view: SKView) {
        self.runner = RunnerNode()
        self.runner.setScale(8.0)
        self.runner.position = CGPoint(x: view.frame.size.width / 2,
                                       y: view.frame.size.height / 2)
        self.addChild(self.runner)
        
        view.addGestureRecognizer(self.longPressGesture)
        view.addGestureRecognizer(self.swipeGesture)

        self.allTexts = TextsParser.processFile()

        self.textsController = TextsController(scene: self)
        self.textsController.delegate = self
        self.textsController.start(with: self.allTexts[0])
        self.addChild(self.textsController.titleLabel)
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

    public override func update(_ currentTime: TimeInterval) {
    }

    private func prepareForConclusion() {
        // Character must move to right side of screen
        let runnerPosition = CGPoint(x: (self.frame.size.width - self.runner.size.width / 2) - 20,
                                     y: frame.size.height / 2)
        let actionForRunner = SKAction.move(to: runnerPosition, duration: 0.5)
        self.runner.run(actionForRunner)

        // Text must appear on the right side and must have a maximum of 50% of the screen width
        self.textsController.messageLabel.preferredMaxLayoutWidth = self.frame.width * 0.4
    }

    // MARK: - Gestures (iOS Controls)

    @objc func onLongPress(_ sender: UILongPressGestureRecognizer) {
        let longPressLocation = convertPoint(fromView: sender.location(in: self.view))

        if sender.state == .began {
            for child in self.children {
                if let shapeNode = child as? RunnerNode {
                    if shapeNode.contains(longPressLocation) {
                        self.textsController.textShouldChangeToNext()
                    }
                }
            }
        } else if sender.state == .ended {
            self.buttonNext.isUserInteractionEnabled = true
        }
    }

    @objc func onSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if gestureRecognizer.direction == .up ||
                gestureRecognizer.direction == .right ||
                gestureRecognizer.direction == .left {
                self.textsController.textShouldChangeToNext()
                self.buttonNext.isUserInteractionEnabled = true
            }
        }
    }

    private func changeSwipeDirection(to newDirection: UISwipeGestureRecognizer.Direction) {
        self.swipeGesture.isEnabled = false
        self.swipeGesture.direction = newDirection
        self.swipeGesture.isEnabled = true
    }

}

// MARK: - TextsControllerDelegate
extension GameScene: TextsControllerDelegate {

    func textPartEnded() {
        self.allTextsIndex += 1
        if self.allTextsIndex < self.allTexts.count {
            self.textsController.start(with: allTexts[self.allTextsIndex])
        }

    }

    func activateInteractionFor(_ partTitle: String) {
        self.buttonNext.isUserInteractionEnabled = false

        switch partTitle {
        case "Life as a running":
            // Taps
            self.runner.isUserInteractionEnabled = true
            print("Life is a running")
        case "Obstacles":
            // Swipe up
            self.runner.isUserInteractionEnabled = false
            self.changeSwipeDirection(to: .up)
            print("obstacles")
        case "Hills":
            // Swipe rigth
            self.changeSwipeDirection(to: .right)
            print("hills")
        case "Pace":
            // Swipe left
            self.changeSwipeDirection(to: .left)
            print("pace")
        case "Goals":
            // Long press
            self.swipeGesture.isEnabled = false
            self.longPressGesture.isEnabled = true
            print("goals")
        case "Conclusion":
            self.prepareForConclusion()
        default:
            print("Nada")
        }
    }

}
