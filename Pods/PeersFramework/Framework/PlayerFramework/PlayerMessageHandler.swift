import Foundation
import os.log

class PlayerMessageHandler: NSObject {
    
    weak var playerFramework: PlayerFrameworkImpl?
    
    // Interpret a message received from the host.
    // If its context is .game, let the PlayerGameDelegate handle the message.
    // Otherwise, let's handle the message ourselves by finding out the type
    // and calling the according function.
    func handle(message messageWrapper: MessageWrapper, from peer: Peer) {
        if messageWrapper.context == .game {
            os_log("[FRAMEWORK] Forwarding message of type %s to game delegate", type: .debug, messageWrapper.type)
            self.playerFramework?.currentGameDelegate?.handle(message: messageWrapper.data, ofType: messageWrapper.type)
            return
        }
        do {
            switch messageWrapper.type {
            case "\(GamePossible.self)":
                self.playerFramework?.handleGamePossible()
            case "\(GameNotPossible.self)":
                self.playerFramework?.handleGameNotPossible()
            case "\(GameCouldStartSoon.self)":
                self.playerFramework?.handleGameCouldStartSoon(request: try MessageWrapper.decodeData(type: GameCouldStartSoon.self, data: messageWrapper.data))
            case "\(AcceptGameRequest.self)":
                self.playerFramework?.handleAcceptGameRequest(request: try MessageWrapper.decodeData(type: AcceptGameRequest.self, data: messageWrapper.data))
            case "\(JoinNextGameSuccessful.self)":
                self.playerFramework?.handleJoinedNextGameSuccessfully()
            case "\(GameCannotStartTooFewPlayers.self)":
                self.playerFramework?.handleGameCannotStartTooFewPlayers()
            case "\(GameInitialize.self)":
                self.playerFramework?.handleGameInitialize(request: try MessageWrapper.decodeData(type: GameInitialize.self, data: messageWrapper.data))
            case "\(GameStarts.self)":
                try self.playerFramework?.handleGameStarts()
            case "\(GameResult.self)":
                self.playerFramework?.handleGameResult(request: try MessageWrapper.decodeData(type: GameResult.self, data: messageWrapper.data))
            default:
                os_log("[FRAMEWORK] Message with unknown message type received from host.", type: .error)
            }
        } catch {
            os_log("[FRAMEWORK] Failed to handle message: %@", type: .error, error.localizedDescription)
        }
    }
}
