import SpriteKit
import GameplayKit

public class RunnerNode: SKSpriteNode {

    // MARK: - Properties

    public var sprites: [SKTexture] = []
    public var actionKey = "RunnerCurrentAction"

    var lastAbsoluteTime: CFAbsoluteTime!
    var tapsCounter = 0

    var stateMachine: GKStateMachine!

    // MARK: - Life cycle

    public init() {
        let texture = SKTexture(imageNamed: "adventurer-idle-1")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.isUserInteractionEnabled = true

        self.stateMachine = GKStateMachine(states: [
            IdleState(runner: self),
            RunningState(runner: self)
        ])
        self.stateMachine.enter(IdleState.self)
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

    // MARK: - Touch Actions

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.stateMachine.enter(RunningState.self)
    }
    
}
