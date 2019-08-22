import Foundation

// Errors occuring in Connectivity (the MC Wrapper).
enum ConnectivityError: Error {
    case peerNotFound
    case encoding
    case decoding
}
