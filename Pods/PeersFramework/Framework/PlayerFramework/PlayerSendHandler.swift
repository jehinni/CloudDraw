import Foundation
import os.log

class PlayerSendHandler: NSObject {
    
    weak var playerFramework: PlayerFrameworkImpl?

    // Private base function for sending messages to players.
    private func sendToHost<T>(context: MessageContext, message: T, to host: Peer, sendMode: SessionSendDataMode) where T: Codable  {
        do {
            let message = try MessageWrapper.build(context: context, type: "\(T.self)", data: message)
            try self.playerFramework?.connectivity.send(message.encode(), toPeers: [host], with: sendMode)
        } catch {
            os_log("[FRAMEWORK] Could not send message to host: %@", type: .error, error.localizedDescription)
        }
    }

    // Send a framework message to the host.
    func sendToHost<T>(message: T, sendMode: SessionSendDataMode = .reliable) where T: Codable {
        guard let host = self.playerFramework?.connectedHost else {
            os_log("[FRAMEWORK] Cannot send a message to the host because he is undefined.", type: .error)
            return
        }
        self.sendToHost(context: .framework, message: message, to: host, sendMode: sendMode)
    }
    
    // Send a game message to the host. Should only be used by games.
    func sendGameDataToHost<T>(message: T, sendMode: SessionSendDataMode = .reliable) where T: Codable {
        guard let host = self.playerFramework?.connectedHost else {
            os_log("[FRAMEWORK] Cannot send a game message to the host because he is undefined.", type: .error)
            return
        }
        self.sendToHost(context: .game, message: message, to: host, sendMode: sendMode)
    }
}
