import Foundation
import MultipeerConnectivity

// The SessionState defines the connection state between two peers.
enum SessionState {
    case notConnected
    case connecting
    case connected
}

// The SessionSendDataMode defines whether the message should be
// delivered reliably or unreliably. The second one is faster.
// The SessionSendDataMode can be compared with TCP and UDP.
public enum SessionSendDataMode {
    case reliable
    case unreliable
}
