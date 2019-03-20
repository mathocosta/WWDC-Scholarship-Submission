import SpriteKit

public class ButtonNode: SKSpriteNode {

    // MARK: - Properties

    public var label = SKLabelNode(fontNamed: "SFRegular")
    public var wasClicked: (() -> Void)?

    // MARK: - Life cycle

    public init(text: String, size: CGSize) {
        let texture = SKTexture(imageNamed: "")
        super.init(texture: texture, color: .clear, size: size)

        self.isUserInteractionEnabled = true

        self.label.text = text
        self.label.verticalAlignmentMode = .center
        self.label.horizontalAlignmentMode = .center
        self.addChild(self.label)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Touch Actions

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let wasClicked = self.wasClicked else { return }
        wasClicked()
    }

}
