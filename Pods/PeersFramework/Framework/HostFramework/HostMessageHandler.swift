import Foundation
import os.log

class HostMessageHandler: NSObject {
    
    weak var hostFramework: HostFrameworkImpl?
    
    // Interpret a message received from a player.
    // If its context is .game, let the HostGameDelegate handle the message.
    // Otherwise, let's handle the message ourselves by finding out the type
    // and calling the according function.
    func handle(message messageWrapper: MessageWrapper, from peer: Peer) {
        if messageWrapper.context == .game {
            os_log("[FRAMEWORK] Forwarding message of type %s to game delegate", type: .debug, messageWrapper.type)
            self.hostFramework?.currentGameDelegate?.handle(message: messageWrapper.data, ofType: messageWrapper.type, from: peer)
            return
        }
        do {
            switch messageWrapper.type {
            case "\(GameSessionRequest.self)":
                try self.hostFramework?.handleGameSessionRequest(request: try MessageWrapper.decodeData(type: GameSessionRequest.self, data: messageWrapper.data), from: peer)
            case "\(JoinNextGame.self)":
                try self.hostFramework?.handleJoinNextGame(request: try MessageWrapper.decodeData(type: JoinNextGame.self, data: messageWrapper.data), from: peer)
            case "\(GameInitialized.self)":
                try self.hostFramework?.handleGameInitialized(request: try MessageWrapper.decodeData(type: GameInitialized.self, data: messageWrapper.data), from: peer)
            default:
                os_log("[FRAMEWORK] Message with unknown message type received from player.", type: .error)
            }
        } catch {
            os_log("[FRAMEWORK] Failed to handle message: %@", type: .error, error.localizedDescription)
        }
    }
}
