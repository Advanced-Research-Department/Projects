import UIKit

enum EnemyType: String {
    case soldier
    case tank
    case helicopter
}

final class EnemySprite {
    let color: UIColor
    let image: UIImage
    let type: EnemyType
    
    init(color: UIColor, image: UIImage, type: EnemyType) {
        self.color = color
        self.image = image
        self.type = type
    }
    
    func draw(at point: CGPoint) {
        let address = Unmanaged<EnemySprite>
            .passUnretained(self).toOpaque()
        print("Draw new Enemy of type \(type.rawValue.capitalized) with sprite object \(address)")
    }
}

final class Enemy {
    var point: CGPoint
    var size: Double
    var sprite: EnemySprite
    
    init(point: CGPoint, size: Double, sprite: EnemySprite) {
        self.point = point
        self.size = size
        self.sprite = sprite
    }
    
    func draw() {
        sprite.draw(at: point)
    }
}


final class EnemySpriteFactory {
    
    static private var sprites: [EnemyType: EnemySprite] = [:] {
        didSet {
            print("Amount of sprites has changed to \(sprites.count)")
        }
    }
    
    static func makeEnemySprite(for type: EnemyType) -> EnemySprite {
        if let sprite = sprites[type] {
            return sprite
        } else {
            var newSprite: EnemySprite
            switch type {
            case .soldier:
                newSprite = EnemySprite(color: .red, image: UIImage(), type: type)
            case .tank:
                newSprite = EnemySprite(color: .green, image: UIImage(), type: type)
            case .helicopter:
                newSprite = EnemySprite(color: .blue, image: UIImage(), type: type)
            }
            sprites[type] = newSprite
            return newSprite
        }
    }
}



let enemyTypes: [EnemyType] = [.soldier, .tank, .helicopter]

for _ in 0..<1000 {
    let randomType = enemyTypes[Int(arc4random_uniform(UInt32(enemyTypes.count)))]
    let newEnemySprite = EnemySpriteFactory.makeEnemySprite(for: randomType)
    let newEnemy = Enemy(point: .zero, size: 0.3, sprite: newEnemySprite)
    newEnemy.draw()
}
