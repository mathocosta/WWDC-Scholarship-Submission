import PlaygroundSupport
import GameplayKit
import SpriteKit

public class GameScene: SKScene {

    // MARK: - Properties

    var runner: RunnerNode!

    var buttonNext: ButtonNode!
    var interactionTimer: Timer!

    var keyToCheck: UInt16!

    var allTextsIndex = 0
    var allTexts: [TextPart]!
    var textsController: TextsController!

    #if os(iOS)
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
    #endif

    // MARK: - Life cycle

    public override func didMove(to view: SKView) {
        self.runner = RunnerNode()
        self.runner.setScale(8.0)
        self.runner.position = CGPoint(x: view.frame.size.width / 2,
                                       y: view.frame.size.height / 2)
        self.runner.whenTapped = { [weak self] in
            self?.interactionWasPerformed()
        }
        self.addChild(self.runner)

        // Add the gestures if is iOS
        #if os(iOS)
        view.addGestureRecognizer(self.longPressGesture)
        view.addGestureRecognizer(self.swipeGesture)
        #endif

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
        let runnerPosition = CGPoint(x: self.runner.size.width / 2,
                                     y: frame.size.height / 2)
        let actionForRunner = SKAction.move(to: runnerPosition, duration: 0.5)
        self.runner.run(actionForRunner)

        // Text must appear on the right side and must have a maximum of 50% of the screen width
        self.textsController.messageLabel.preferredMaxLayoutWidth = self.frame.width * 0.4
        self.textsController.titleLabel.position = CGPoint(x: self.frame.width / 2 - 20, y: self.frame.height - 20)
        self.textsController.messageLabel.position = CGPoint(x: self.frame.width / 2 - 20, y: self.frame.height - 40)
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

    // Activates the interaction that part
    func activateInteractionFor(_ partTitle: String) {
        self.buttonNext.isUserInteractionEnabled = false
        self.buttonNext.isHidden = true
        self.interactionTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.interactionWasPerformed(false)
        }

        #if os(iOS)
        switch partTitle {
        case "Life as a running":
            // Taps
            self.runner.isUserInteractionEnabled = true
        case "Obstacles":
            // Swipe up
            self.changeSwipeDirection(to: .up)
        case "Hills":
            // Swipe rigth
            self.changeSwipeDirection(to: .right)
        case "Pace":
            // Swipe left
            self.changeSwipeDirection(to: .left)
        case "Goals":
            // Long press
            self.swipeGesture.isEnabled = false
            self.longPressGesture.isEnabled = true
        case "Conclusion":
            self.prepareForConclusion()
        default:
            print("None")
        }

        #elseif os(OSX)

        let leftKey: UInt16  = 0x7B
        let rightKey: UInt16 = 0x7C
        let upKey: UInt16    = 0x7E
        let downKey: UInt16  = 0x7D

        switch partTitle {
        case "Life as a running":
            // Mouse down
            self.runner.isUserInteractionEnabled = true
        case "Obstacles":
            // Press up arrow
            self.keyToCheck = upKey
        case "Hills":
            // Press right arrow
            self.keyToCheck = rightKey
        case "Pace":
            // Press left arrow
            self.keyToCheck = leftKey
        case "Goals":
            // Press down key
            self.keyToCheck = downKey
        case "Conclusion":
            self.prepareForConclusion()
        default:
            print("None")
        }

        #endif
    }

    // Called when the interaction ends
    // It changes the screen text at the end according to the paramenter
    func interactionWasPerformed(_ changeText: Bool = true) {
        self.buttonNext.isUserInteractionEnabled = true
        self.buttonNext.isHidden = false
        self.interactionTimer.invalidate()

        if changeText {
            self.textsController.textShouldChangeToNext()
        }
    }

}

#if os(iOS)
// MARK: - Gestures (iOS Controls)
extension GameScene {

    @objc func onLongPress(_ sender: UILongPressGestureRecognizer) {
        let longPressLocation = convertPoint(fromView: sender.location(in: self.view))

        if sender.state == .began {
            for child in self.children {
                if let shapeNode = child as? RunnerNode {
                    if shapeNode.contains(longPressLocation) {
                        self.interactionWasPerformed()
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
                self.interactionWasPerformed()
            }
        }
    }

    private func changeSwipeDirection(to newDirection: UISwipeGestureRecognizer.Direction) {
        self.swipeGesture.isEnabled = false
        self.swipeGesture.direction = newDirection
        self.swipeGesture.isEnabled = true
    }

}
#endif

#if os(OSX)
// MARK: - Keyboard (OSX Controls)
extension GameScene {

    public override func keyDown(with event: NSEvent) {

        let key = event.keyCode

        if key == self.keyToCheck {
            self.interactionWasPerformed()
        }
    }

}
#endif
