/*:

 # Run to WWDC 2019

 This playground is a mini-game that talks about some benefits of running and, most importantly,
 demonstrates aspects of exercise as a metaphor for some things in life. Overall, the interactions
 are simple, because the main thing about the playground is the message it passes to whoever is watching.

 ## Controls

 I first made thinking for iOS, however later, due to the time and availability, I also
 put support for OSX controls. So it's a playground that would work on both platforms. To change to OSX
 controls, just open the right menu and in the "Playground Settings" section choose the "macOS" platform.
 You can go back to iOS by following the same steps as above.

 On iOS all controls are gestures or touch actions, such as swipe, long press etc. In MacOS, keyboard
 and mouse controls are already used. The commands that must be made are explained during execution.

 */

import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x: 0 , y: 0, width: 800, height: 600))
let scene = GameScene(size: sceneView.frame.size)
scene.scaleMode = .aspectFill
sceneView.presentScene(scene)
sceneView.showsPhysics = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
