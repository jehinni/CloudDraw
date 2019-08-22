import Foundation
import os.log

class HostSendHandler: NSObject {
    
    weak var hostFramework: HostFrameworkImpl?
    
    // Private base function for sending messages to players.
    private func sendToPlayers<T>(context: MessageContext, message: T, to players: [Player], sendMode: SessionSendDataMode) where T: Codable  {
        do {
            let message = try MessageWrapper.build(context: context, type: "\(T.self)", data: message)
            try self.hostFramework?.connectivity.send(message.encode(), toPeers: players.map({ $0.peer }), with: sendMode)
        } catch {
            os_log("[FRAMEWORK] Could not send message %s to players: %@", type: .error, String(describing: message), error.localizedDescription)
        }
    }
    
    // Send a framework message to all active players.
    func sendToAllPlayers<T>(message: T, sendMode: SessionSendDataMode = .reliable) where T: Codable {
        guard let players = self.hostFramework?.playersHandler?.players else {
            os_log("[FRAMEWORK] Cannot send a message to players because they are undefined.", type: .error)
            return
        }
        self.sendToPlayers(context: .framework, message: message, to: players, sendMode: sendMode)
    }
    
    // Send a framework message to all playing players.
    func sendToPlayingPlayers<T>(message: T, sendMode: SessionSendDataMode = .reliable) where T: Codable {
        guard let playingPlayers = self.hostFramework?.playersHandler?.playingPlayers else {
            os_log("[FRAMEWORK] Cannot send a message to playing players because they are undefined.", type: .error)
            return
        }
        self.sendToPlayers(context: .framework, message: message, to: playingPlayers, sendMode: sendMode)
    }
    
    // Send a framework message to some players.
    func sendToSomePlayers<T>(message: T, to players: [Player], sendMode: SessionSendDataMode = .reliable) where T: Codable {
        self.sendToPlayers(context: .framework, message: message, to: players, sendMode: sendMode)
    }

    // Send a game message to all or some playing players. Should only be used by games.
    func sendGameDataToPlayers<T>(message: T, to players: [Player]?, sendMode: SessionSendDataMode = .reliable) where T: Codable {
        guard players != nil else {
            guard let playingPlayers = self.hostFramework?.playersHandler?.playingPlayers else {
                os_log("[FRAMEWORK] Cannot send a game message to playing players because they are undefined.", type: .error)
                return
            }
            self.sendToPlayers(context: .game, message: message, to: playingPlayers, sendMode: sendMode)
            return
        }
        self.sendToPlayers(context: .game, message: message, to: players!, sendMode: sendMode)
    }
}
