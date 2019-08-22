import Foundation
import UIKit

// Implemented by the Game to generate a concrete
// host or player Game for the App.
// This will alwys create the game with the newest version.
public protocol GamePartFactory {
    
    func createHostGame(containerViewController: UIViewController) -> HostGame
    
    func createPlayerGame(containerViewController: UIViewController) -> PlayerGame
}
