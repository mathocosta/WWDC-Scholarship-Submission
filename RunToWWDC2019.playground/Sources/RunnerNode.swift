import SpriteKit
import GameplayKit

public class RunnerNode: SKSpriteNode {

    // MARK: - Properties

    public var sprites: [SKTexture] = []
    public var actionKey = "RunnerCurrentAction"

    var lastAbsoluteTime: CFAbsoluteTime!
    var tapsCounter = 0

    var stateMachine: GKStateMachine!

    var whenTapped: (() -> Void)?

    // MARK: - Life cycle

    public init() {
        let texture = SKTexture(imageNamed: "adventurer-idle-1")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.isUserInteractionEnabled = false
        self.name = "RunnerNode"

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

    public func jump() {
        self.runAnimation()

        let jumpUpAction = SKAction.moveBy(x: 0, y: 40, duration: 0.2)
        let jumpDownAction = SKAction.moveBy(x: 0, y: -40, duration: 0.2)
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])

        self.run(jumpSequence)
    }

    // MARK: - Actions
    #if os(iOS)
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.stateMachine.enter(RunningState.self)
        self.isUserInteractionEnabled = false
        guard let whenTapped = self.whenTapped else { return }
        whenTapped()
    }

    #elseif os(OSX)

    public override func mouseDown(with event: NSEvent) {
        self.stateMachine.enter(RunningState.self)
        self.isUserInteractionEnabled = false
        guard let whenTapped = self.whenTapped else { return }
        whenTapped()
    }

    #endif
}
