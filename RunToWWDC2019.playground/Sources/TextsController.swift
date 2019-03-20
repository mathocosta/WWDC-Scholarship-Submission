import SpriteKit

public class MessageLabel: SKLabelNode {

    public override init() {
        super.init()

        self.fontName = "SF Regular"
        self.fontSize = 20
        self.horizontalAlignmentMode = .left
        self.lineBreakMode = .byWordWrapping
        self.verticalAlignmentMode = .top
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

    // MARK: - Properties

    public var scene: GameScene
    public var messageLabel: MessageLabel

    private var currentTextsIndex: Int
    private var currentTexts: [String]!

    weak var delegate: TextsControllerDelegate?

    // MARK: - Life cycle

    public init(scene: GameScene) {
        self.scene = scene
        self.currentTextsIndex = 0

        self.messageLabel = MessageLabel()
        self.messageLabel.position = CGPoint(x: 20, y: scene.frame.height - 20)
        self.messageLabel.preferredMaxLayoutWidth = scene.frame.width * 0.8
    }

    func start(with part: TextPart) {
        self.currentTexts = part.texts
        self.currentTextsIndex = 0
        self.messageLabel.text = self.currentTexts[self.currentTextsIndex]
    }

    public func textShouldChangeToNext() {
        self.currentTextsIndex += 1

        if self.currentTextsIndex < self.currentTexts.count {
            self.messageLabel.text = self.currentTexts[self.currentTextsIndex]
        } else {
            self.delegate?.textPartEnded()
        }
    }

}
