import Foundation

// Used to send data to peers and to manage the connectivity session.
internal protocol Connectivity {
    
    var maxNumberOfPeers: Int { get }

    var delegate: ConnectivityDelegate? { get set }
    
    init(peer: Peer)
    
    // Get all peers that are connected to you.
    func connectedPeers() -> [Peer]
    
    // When in client mode, you can invite a server to connect.
    // Invite an advertising peer to connect with me.
    func invitePeer(_ peer: Peer) throws
    
    // Send data to one or multiple peers. The SessionSendDataMode defines whether the message
    // should be delivered reliably or unreliably. The second one is faster.
    // The SessionSendDataMode can be compared with TCP and UDP.
    // If a Peer is not connected anymore, it will be removed from the recipients list.
    // Set the optional argument "failHard" to true if an error should be thrown instead.
    // If no failHard argument is supplied, the default value is "false" (see Connectivity extension).
    func send(_ data: Data, toPeers peers: [Peer], with sessionSendDataMode: SessionSendDataMode, failHard: Bool) throws

    // Start a named byte stream with the remote peer.
    func startStream(withName: String, toPeer peer: Peer) throws -> OutputStream
    
    // Start advertising this peer so that other peers can find it with their browsers.
    func startAdvertising()
    
    // Stop advertising this peer so that other peers can no longer find it with their browsers.
    func stopAdvertising()
    
    // Start searching for advertised peers.
    func startBrowsing()
    
    // Stop searching for advertised peers.
    func stopBrowsing()
    
    // Disconnect this peer from any connections.
    func disconnect()
}

extension Connectivity {
    
    // Does extactly the same as the normal send() function,
    // but defaults the argument "failHard" to false.
    func send(_ data: Data, toPeers peers: [Peer], with sessionSendDataMode: SessionSendDataMode, failHard: Bool = false) throws {
        try self.send(data, toPeers: peers, with: sessionSendDataMode, failHard: failHard)
    }

}
