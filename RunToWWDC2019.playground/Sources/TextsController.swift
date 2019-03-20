import SpriteKit

public class MessageLabel: SKLabelNode {

    public override init() {
        super.init()

        self.fontName = "SF Regular"
        self.horizontalAlignmentMode = .left
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

protocol TextsControllerDelegate: class {
    func textPartEnded()
}

public class TextsController {

    public var scene: GameScene
    public var messageLabel: MessageLabel

    private var currentTextsIndex: Int
    private var currentTexts: [String]!

    weak var delegate: TextsControllerDelegate?

    public init(scene: GameScene) {
        self.scene = scene
        self.currentTextsIndex = 0

        self.messageLabel = MessageLabel()
        self.messageLabel.position = CGPoint(x: 10, y: scene.frame.height - 200)
        self.messageLabel.preferredMaxLayoutWidth = scene.frame.width * 0.8
    }

    func start(with texts: [String]) {
        self.currentTexts = texts
        self.currentTextsIndex = 0
        self.messageLabel.text = self.currentTexts[self.currentTextsIndex]
    }

    public func textShouldChangeToNext() {
        self.currentTextsIndex += 1
        print("index: \(self.currentTextsIndex)")
        if self.currentTextsIndex < self.currentTexts.count {
            self.messageLabel.text = self.currentTexts[self.currentTextsIndex]
        } else {
            self.delegate?.textPartEnded()
        }
    }

}
