import Foundation

internal protocol ConnectivityDelegate: AnyObject {
    
    // A peer wants to connect to us.
    func answerInvitation(didReceiveInvitationFromPeer peer: Peer) throws -> Bool
    
    // When browsing, a peer nearby was found.
    func browser(foundPeer peer: Peer)
    
    // A nearby peer is no longer available.
    func browser(lostPeer peer: Peer)
    
    // The connection state with a peer changed.
    func session(_ peer: Peer, didChange state: SessionState)
    
    // A peer sent us data.
    func session(didReceive data: Data, fromPeer peer: Peer)
    
    // A peer sent us a byte stream of data.
    func session(didReceive stream: InputStream, withName streamName: String, fromPeer peer: Peer)
    
    // A peer started sending us a resource.
    func session(didStartReceivingResourceWithName resourceName: String, fromPeer peer: Peer, with progress: Progress)
    
    // A peer stopped sending us a resource.
    func session(didFinishReceivingResourceWithName resourceName: String, fromPeer peer: Peer, at localURL: URL?, withError error: Error?)
}

// Empty 'default' implementations ito avoid empty blocks in
// player and host framework for functions only needed by one of those.
extension ConnectivityDelegate {
	func answerInvitation(didReceiveInvitationFromPeer peer: Peer) -> Bool {
        return false
    }
    
    func browser(foundPeer peer: Peer) {}
    
    func browser(lostPeer peer: Peer) {}
}
