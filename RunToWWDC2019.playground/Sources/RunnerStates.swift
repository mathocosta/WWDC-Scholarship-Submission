import SpriteKit
import GameplayKit

public class RunnerState: GKState {
    private var runner: RunnerNode

    public var sprites: [SKTexture]!

    public init(runner: RunnerNode) {
        self.runner = runner
    }

    public override func didEnter(from previousState: GKState?) {
        self.runner.sprites = self.sprites
        self.runner.runAnimation()
    }

    public override func willExit(to nextState: GKState) {
        self.runner.stopAnimation()
    }
}

public class IdleState: RunnerState {
    public override init(runner: RunnerNode) {
        super.init(runner: runner)

        self.sprites = [
            SKTexture(imageNamed: "adventurer-idle-1"),
            SKTexture(imageNamed: "adventurer-idle-2")
        ]
    }
}

public class RunningState: RunnerState {
    public override init(runner: RunnerNode) {
        super.init(runner: runner)

        self.sprites = [
            SKTexture(imageNamed: "adventurer-run-1"),
            SKTexture(imageNamed: "adventurer-run-2"),
            SKTexture(imageNamed: "adventurer-run-3"),
            SKTexture(imageNamed: "adventurer-run-4"),
            SKTexture(imageNamed: "adventurer-run-5"),
            SKTexture(imageNamed: "adventurer-run-6")
        ]
    }
}

