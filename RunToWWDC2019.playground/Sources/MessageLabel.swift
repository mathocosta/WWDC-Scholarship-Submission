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
