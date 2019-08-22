import Foundation

public final class FrameworkFactory {
    
    private init() {}
    
    // Creates an instance of the HostFramework protocol.
    public static func createHostFramework(peer: Peer) -> HostFramework {
        return HostFrameworkImpl(peer: peer)
    }
    
    // Creates an instance of the PlayerFramework protocol.
    public static func createPlayerFramework(peer: Peer) -> PlayerFramework {
        return PlayerFrameworkImpl(peer: peer)
    }
}
