import Foundation
import MultipeerConnectivity

// This adapter maps the MC Enums to Connectivity Enums.
internal class MultipeerEnumsAdapter {
    
    private init() {}
    
    static func convert(_ sessionState: MCSessionState) -> SessionState {
        switch sessionState {
        case .notConnected:
            return SessionState.notConnected
        case .connecting:
            return SessionState.connecting
        case .connected:
            return SessionState.connected
        @unknown default:
            fatalError("Unknown MCSessionState")
        }
    }
    
    static func convert(_ sessionSendDataMode: MCSessionSendDataMode) -> SessionSendDataMode {
        switch sessionSendDataMode {
        case .reliable:
            return SessionSendDataMode.reliable
        case .unreliable:
            return SessionSendDataMode.unreliable
        @unknown default:
            fatalError("Unknown MCSessionSendDataMode")
        }
    }
    
    static func convert(_ sessionSendDataMode: SessionSendDataMode) -> MCSessionSendDataMode {
        switch sessionSendDataMode {
        case .reliable:
            return MCSessionSendDataMode.reliable
        case .unreliable:
            return MCSessionSendDataMode.unreliable
        }
    }
}
