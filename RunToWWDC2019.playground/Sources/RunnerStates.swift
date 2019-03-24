import SpriteKit
import GameplayKit

public class RunnerState: GKState {
    private var runner: RunnerNode

    public var sprites: [SKTexture]!
    public var timePerFrame: TimeInterval!

    public init(runner: RunnerNode) {
        self.runner = runner
    }

    public override func didEnter(from previousState: GKState?) {
        self.runner.sprites = self.sprites
        self.runner.timePerFrame = self.timePerFrame
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
            SKTexture(imageNamed: "idle-1"),
            SKTexture(imageNamed: "idle-2"),
            SKTexture(imageNamed: "idle-3"),
            SKTexture(imageNamed: "idle-4"),
            SKTexture(imageNamed: "idle-5")
        ]

        self.timePerFrame = 0.2
    }
}

public class JumpingState: RunnerState {
    public override init(runner: RunnerNode) {
        super.init(runner: runner)

        self.sprites = [
            SKTexture(imageNamed: "jump-1"),
            SKTexture(imageNamed: "jump-1"),
            SKTexture(imageNamed: "jump-1"),
            SKTexture(imageNamed: "jump-2"),
            SKTexture(imageNamed: "jump-3")
        ]

        self.timePerFrame = 0.1
    }
}

public class RunningState: RunnerState {
    public override init(runner: RunnerNode) {
        super.init(runner: runner)

        self.sprites = [
            SKTexture(imageNamed: "running-1"),
            SKTexture(imageNamed: "running-2"),
            SKTexture(imageNamed: "running-3"),
            SKTexture(imageNamed: "running-4"),
            SKTexture(imageNamed: "running-5"),
            SKTexture(imageNamed: "running-6")
        ]

        self.timePerFrame = 0.1
    }

    public override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        SKTAudio.sharedInstance().playBackgroundMusic("running.wav")
    }

    public override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        SKTAudio.sharedInstance().pauseBackgroundMusic()
    }
}

class RunningAndBreathing: RunningState {
    public override init(runner: RunnerNode) {
        super.init(runner: runner)

        self.timePerFrame = 0.08
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        SKTAudio.sharedInstance().playBackgroundMusic("breathing.wav")
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        SKTAudio.sharedInstance().pauseBackgroundMusic()
    }
}

