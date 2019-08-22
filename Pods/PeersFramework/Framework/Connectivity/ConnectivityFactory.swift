import Foundation

internal class ConnectivityFactory : NSObject {
    
    private override init() {}
    
    // Creates an instance of Multipeer adapter extending the Connectivity Protocol.
    static func makeConnectivity(peer: Peer) -> Connectivity {
        return MultipeerAdapter(peer: peer)
    }
}
