import Playdate

// Ways to 'prevent' crash:
// 1. Change Thing from struct to class
// 2. Remove either of the two String properties from Thing struct
// 3. Remove currentThing from SceneWithThing

struct Thing {
    let id: String
    let name: String
    let length: Int
    
    init(id: String, name: String, length: Int) {
        self.id = id
        self.name = name
        self.length = length
    }
}

class SceneBase {
    func onSceneUpdate(deltaTime: Float) -> Void {}
}

class SceneWithThing: SceneBase {
    var currentThing: Thing = Thing(id: "A", name: "Cool Thing", length: 42)
    var totalElapsed: Float = 0.0
    
    override func onSceneUpdate(deltaTime: Float) {
        totalElapsed += deltaTime
        Graphics.fillRect(x: 0, y: 0, width: 400, height: 240, color: 1)
        Graphics.fillRect(x: 20, y: 140, width: CInt(totalElapsed * 10.0), height: 50, color: 0)
    }
}

struct Game {
    var current: SceneBase
    var lastElapsedTime: Float = 0
    var switchSceneTimer: Float = 0
    
    init() {
        // Setup the device before any other operations.
        srand(System.getSecondsSinceEpoch(milliseconds: nil))
        Display.setRefreshRate(rate: 50)
        
        current = SceneWithThing()
    }
    
    mutating func updateGame() {
        let elapsedTime = System.elapsedTime
        let deltaTime = elapsedTime - lastElapsedTime
        lastElapsedTime = elapsedTime
        
        current.onSceneUpdate(deltaTime: deltaTime)
        
        switchSceneTimer += deltaTime
        if switchSceneTimer > 2.5 {
            // Crash happens during the next line:
            current = SceneWithThing()
            switchSceneTimer = 0
        }
        
        System.drawFPS(x: 0, y: 0)
    }
}
