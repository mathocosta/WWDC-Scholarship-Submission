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
    func activateInteractionFor(_ partTitle: String)
}

public class TextsController {

    // MARK: - Properties

    public var scene: GameScene
    public var titleLabel: MessageLabel
    public var messageLabel: MessageLabel

    public var currentTextsIndex: Int
    private var currentTitle: String!
    private var currentTexts: [String]!

    private var hasInteraction: Bool!

    weak var delegate: TextsControllerDelegate?

    // MARK: - Life cycle

    public init(scene: GameScene) {
        self.scene = scene
        self.currentTextsIndex = 0

        self.titleLabel = MessageLabel()
        self.titleLabel.position = CGPoint(x: 20, y: scene.frame.height - 20)
        self.titleLabel.preferredMaxLayoutWidth = scene.frame.width * 0.8

        self.messageLabel = MessageLabel()
        self.messageLabel.fontSize = 30
        self.messageLabel.position = CGPoint(x: 20, y: scene.frame.height - 40)
        self.messageLabel.preferredMaxLayoutWidth = scene.frame.width * 0.8
    }

    func start(with part: TextPart) {
        self.currentTexts = part.texts
        self.currentTitle = part.title
        self.hasInteraction = part.hasInteraction

        self.titleLabel.text = self.currentTitle

        self.currentTextsIndex = 0
        self.messageLabel.text = self.currentTexts[self.currentTextsIndex]
    }

    public func textShouldChangeToNext() {
        self.currentTextsIndex += 1

        if self.currentTextsIndex < self.currentTexts.count {
            let next = self.currentTexts[self.currentTextsIndex]
            self.messageLabel.text = next
            if next == self.currentTexts.last && self.hasInteraction {
                self.delegate?.activateInteractionFor(self.currentTitle)
            }
        } else {
            self.delegate?.textPartEnded()
        }
    }

}
