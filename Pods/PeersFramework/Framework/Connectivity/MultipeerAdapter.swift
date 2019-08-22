import Foundation
import MultipeerConnectivity
import os.log

// Use ConnectivityFactory to get an instance of this class!
internal class MultipeerAdapter: NSObject, Connectivity {
    
    private let serviceName = "peers-minigames"
    private let myPeer: Peer
    private let myMCPeerID: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private let session: MCSession
    
    // Dictionary with key = UUID, value = Tuple of Peer and MCPeerID
    // This allows us to map a Peer object to the currently connected MCPeerID
    // and have an easy way to get from one to the other
    // (via the UUID as key, which is included as a value in both objects)
    private var knownPeers: [String: (Peer, MCPeerID)]
    
    var maxNumberOfPeers: Int = kMCSessionMaximumNumberOfPeers
    
    weak var delegate: ConnectivityDelegate?
    
    required init(peer: Peer) {
        self.myPeer = peer
        self.myMCPeerID = MCPeerID(displayName: peer.id)
        do {
            guard let jsonEncodedPeer: String = String(data: try JSONEncoder().encode(self.myPeer), encoding: .utf8) else {
                throw ConnectivityError.encoding
            }
            self.advertiser = MCNearbyServiceAdvertiser(peer: self.myMCPeerID, discoveryInfo: ["jsonEncodedPeer": jsonEncodedPeer], serviceType: self.serviceName)
        } catch {
            os_log("[FRAMEWORK CONNECTIVITY] FATAL: failed to encode peer info, Multipeer advertiser will NOT work correctly", type: .error)
            self.advertiser = MCNearbyServiceAdvertiser(peer: self.myMCPeerID, discoveryInfo: nil, serviceType: self.serviceName)
        }
        self.browser = MCNearbyServiceBrowser(peer: self.myMCPeerID, serviceType: self.serviceName)
        self.session = MCSession(peer: myMCPeerID, securityIdentity: nil, encryptionPreference: .required)
        self.knownPeers = [:]
        super.init()
        setDelegates()
    }
    
    // MultipeerAdapter is a delegate of session, advertiser and browser.
    // That's why we extend this class with delegate methods session(...), browser(...) and advertiser(...).
    func setDelegates() {
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
    }
    
    // Get all peers that are connected to you.
    // Here, we map the displayName of the MCPeerID (which is our UUID) to the
    // Peer object in our knownPeers dictionary associated with the UUID as key.
    func connectedPeers() -> [Peer] {
        return self.session.connectedPeers
            .filter({ self.knownPeers[$0.displayName] != nil })
            .map({ self.knownPeers[$0.displayName]!.0 })
    }
    
    // Invite an advertising peer to connect with me.
    func invitePeer(_ peer: Peer) throws {
        guard let peerID = self.knownPeers[peer.id]?.1 else {
            throw ConnectivityError.peerNotFound
        }
        try self.browser.invitePeer(peerID, to: self.session, withContext: myPeer.encode(), timeout: 10)
    }
    
    // Send data to one or multiple peers. The SessionSendDataMode defines whether the message
    // should be delivered reliably or unreliably. The second one is faster.
    // The SessionSendDataMode can be compared with TCP and UDP.
    // If a Peer is not connected anymore, it will be removed from the recipients list.
    // Set the optional argument "failHard" to true if an error should be thrown instead.
    func send(_ data: Data, toPeers peers: [Peer], with sessionSendDataMode: SessionSendDataMode, failHard: Bool) throws {
        try peers.forEach({
            if self.knownPeers[$0.id] == nil {
                throw ConnectivityError.peerNotFound
            }
        })
        try self.session.send(
            data,
            toPeers: failHard ? peers.map({ self.knownPeers[$0.id]!.1 }) : self.getActuallyConnectedMCPeerIDs(of: peers),
            with: MultipeerEnumsAdapter.convert(sessionSendDataMode)
        )
    }
    
    // Start a named byte stream with the remote peer.
    func startStream(withName: String, toPeer peer: Peer) throws -> OutputStream {
        guard let peerID = self.knownPeers[peer.id]?.1 else {
            throw ConnectivityError.peerNotFound
        }
        return try self.session.startStream(withName: withName, toPeer: peerID)
    }
    
    // Start advertising this peer so that other peers can find it with their browsers.
    func startAdvertising() {
        self.advertiser.startAdvertisingPeer()
    }
    
    // Stop advertising this peer so that other peers can no longer find it with their browsers.
    func stopAdvertising() {
        self.advertiser.stopAdvertisingPeer()
    }
    
    // Start searching for advertised peers.
    func startBrowsing() {
        self.browser.startBrowsingForPeers()
    }
    
    // Stop searching for advertised peers.
    func stopBrowsing() {
        self.browser.stopBrowsingForPeers()
    }
    
    // Disconnect this peer from any connections.
    func disconnect() {
        self.session.disconnect()
    }
    
    // Check if the peer is already known. If so, update the values of the Peer object
    // without changing the object reference. If not, create a new entry in the knownPeers dictionary.
    func saveToKnownPeers(_ peer: Peer, _ peerID: MCPeerID) -> Peer {
        var knownPeerTuple = self.knownPeers[peerID.displayName]
        if knownPeerTuple != nil {
            knownPeerTuple!.0.name = peer.name
            knownPeerTuple!.0.profilePicture = peer.profilePicture
            knownPeerTuple!.0.supportedGames = peer.supportedGames
            knownPeerTuple!.1 = peerID
            return knownPeerTuple!.0
        }
        self.knownPeers[peerID.displayName] = (peer, peerID)
        return peer
    }
    
    // Map an array of Peers to actually (at this moment) connected MCPeerIDs.
    // Any non-connected peers will be dropped.
    private func getActuallyConnectedMCPeerIDs(of peers: [Peer]) -> [MCPeerID] {
        return self.session.connectedPeers.filter({ mcPeer in
            peers.first(where: { peer in
                mcPeer.displayName == peer.id
            }) != nil })
    }
}

// This extension contains all functions coming from MCSessionDelegate.
extension MultipeerAdapter: MCSessionDelegate {
    
    // The connection state to another peer changed.
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        guard let peer = self.knownPeers[peerID.displayName]?.0 else {
            os_log("[FRAMEWORK CONNECTIVITY] Session didChange state %s, but peer associated with MCPeerID %@ not found", type: .error, "\(state)", peerID)
            return
        }
        self.delegate?.session(peer, didChange: MultipeerEnumsAdapter.convert(state))
    }
    
    // The peer received data from another peer.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let peer = self.knownPeers[peerID.displayName]?.0 else {
            os_log("[FRAMEWORK CONNECTIVITY] Session didReceive data, but peer associated with MCPeerID %@ not found", type: .error, peerID)
            return
        }
        self.delegate?.session(didReceive: data, fromPeer: peer)
    }
    
    // The peer received a stream of data from another peer.
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        guard let peer = self.knownPeers[peerID.displayName]?.0 else {
            os_log("[FRAMEWORK CONNECTIVITY] Session didReceive stream, but peer associated with MCPeerID %@ not found", type: .error, peerID)
            return
        }
        self.delegate?.session(didReceive: stream, withName: streamName, fromPeer: peer)
    }
    
    // The peer started receiving resource data from another peer.
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        guard let peer = self.knownPeers[peerID.displayName]?.0 else {
            os_log("[FRAMEWORK CONNECTIVITY] Session didStartReceivingResourceWithName %s, but peer associated with MCPeerID %@ not found", type: .error, resourceName, peerID)
            return
        }
        self.delegate?.session(didStartReceivingResourceWithName: resourceName, fromPeer: peer, with: progress)
    }
    
    // The peer stopped receiving resource data from another peer.
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        guard let peer = self.knownPeers[peerID.displayName]?.0 else {
            os_log("[FRAMEWORK CONNECTIVITY] Session didFinishReceivingResourceWithName %s, but peer associated with MCPeerID %@ not found", type: .error, resourceName, peerID)
            return
        }
        self.delegate?.session(didFinishReceivingResourceWithName: resourceName, fromPeer: peer, at: localURL, withError: error)
    }
}

// This extension contains all functions coming from MCNearbyServiceAdvertiserDelegate.
extension MultipeerAdapter: MCNearbyServiceAdvertiserDelegate {
    
    // The advertising peer received a connection invitation from another peer.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard self.delegate != nil else {
            os_log("[FRAMEWORK CONNECTIVITY] Delegate is not set, skipping invitation")
            return
        }
        guard context != nil else {
            os_log("[FRAMEWORK CONNECTIVITY] Received invitation without context, discarding...")
            return
        }
        do {
            let receivedPeer = try Peer.decode(context!)
            guard peerID.displayName == receivedPeer.id else {
                os_log("[FRAMEWORK CONNECTIVITY] Received invitation's peer from context doesn't have the same ID as the peerID displayname")
                return
            }
            let peer = self.saveToKnownPeers(receivedPeer, peerID)
            try invitationHandler(self.delegate!.answerInvitation(didReceiveInvitationFromPeer: peer), self.session)
        } catch {
            os_log("[FRAMEWORK CONNECTIVITY] Error when trying to decode Peer object from invitation context: %@", type: .error, error.localizedDescription)
            return
        }
    }
}

// This extension contains all functions coming from MCNearbyServiceBrowserDelegate.
extension MultipeerAdapter: MCNearbyServiceBrowserDelegate {
    
    // The browsing peer found a peer nearby.
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let jsonEncodedPeer = info?["jsonEncodedPeer"]?.data(using: .utf8) else {
            os_log("[FRAMEWORK CONNECTIVITY] Could not JSON decode Peer from discovery info", type: .error)
            return
        }
        do {
            let receivedPeer = try JSONDecoder().decode(Peer.self, from: jsonEncodedPeer)
            let peer = self.saveToKnownPeers(receivedPeer, peerID)
            self.delegate?.browser(foundPeer: peer)
        } catch {
            os_log("[FRAMEWORK CONNECTIVITY] Error when trying to decode Peer object from discovery info: %@", type: .error, error.localizedDescription)
        }
    }
    
    // The browsing peer lost a peer nearby.
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let peer = self.knownPeers[peerID.displayName]?.0 else {
            os_log("[FRAMEWORK CONNECTIVITY] Peer associated with MCPeerID %@ not found", type: .error, peerID)
            return
        }
        self.delegate?.browser(lostPeer: peer)
    }
}
