import SpriteKit

public class ButtonNode: SKSpriteNode {

    // MARK: - Properties

    public var wasClicked: (() -> Void)?

    // MARK: - Life cycle

    public init(size: CGSize, textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: texture.size())

        self.isUserInteractionEnabled = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Actions
    #if os(iOS)
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let wasClicked = self.wasClicked else { return }
        wasClicked()
    }
    #elseif os(OSX)
    public override func mouseDown(with event: NSEvent) {
        guard let wasClicked = self.wasClicked else { return }
        wasClicked()
    }
    #endif

}
