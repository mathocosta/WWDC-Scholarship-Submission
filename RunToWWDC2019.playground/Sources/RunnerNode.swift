
import UIKit
import SpriteKit

public class RunnerNode: SKSpriteNode {

    public init() {
        let texture = SKTexture(imageNamed: "adventurer-run-1")
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func runAnimation() {
        let sprites = [
            SKTexture(imageNamed: "adventurer-run-1"),
            SKTexture(imageNamed: "adventurer-run-2"),
            SKTexture(imageNamed: "adventurer-run-3"),
            SKTexture(imageNamed: "adventurer-run-4"),
            SKTexture(imageNamed: "adventurer-run-5"),
            SKTexture(imageNamed: "adventurer-run-6")
        ]

        let action = SKAction.repeatForever(SKAction.animate(with: sprites, timePerFrame: 0.1))
        self.run(action)
    }

}
