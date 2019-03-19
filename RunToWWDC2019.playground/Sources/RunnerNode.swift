
import UIKit
import SpriteKit
import GameplayKit

public class RunnerNode: SKSpriteNode {

    public var sprites: [SKTexture] = []
    public var actionKey = "RunnerCurrentAction"

    public init() {
        let texture = SKTexture(imageNamed: "adventurer-idle-1")
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func runAnimation() {
        let action = SKAction.repeatForever(SKAction.animate(with: self.sprites, timePerFrame: 0.2))
        self.run(action, withKey: actionKey)
    }

    public func stopAnimation() {
        self.removeAction(forKey: actionKey)
    }

}
