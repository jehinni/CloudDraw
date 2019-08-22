import Foundation

// The message contect defines whether the message should be
// handled by the framework or by the current game.
public enum MessageContext: String, Codable {
    case framework
    case game
}

public class MessageWrapper: NSObject, Codable {
    
    // Whether the message belongs to the Framwork or to the currently played game.
    let context: MessageContext
    
    // Type of data
    let type: String
    
    // Message payload
    var data: Data
    
    // Initializer cannot be generic, please use the build() function instead.
    private init(context: MessageContext, type: String, data: Data) {
        self.context = context
        self.type = type
        self.data = data
    }
    
    // Create a MessageWrapper instance that holds data of the given type.
    // The given data will be immediately encoded to Data.
    static func build<T>(context: MessageContext, type: String, data: T) throws -> MessageWrapper where T: Codable {
        let encodedData = try PropertyListEncoder().encode(data)
        return MessageWrapper(context: context, type: type, data: encodedData)
    }
    
    // Encode this instance of a MessageWrapper to Data, this is needed to send it
    // to a peer using Connectivity.
    func encode() throws -> Data {
        return try PropertyListEncoder().encode(self)
    }
    
    // Decode a MessageWrapper object from received Data by another peer through Connectivity.
    static func decode(_ data: Data) throws -> MessageWrapper {
        return try PropertyListDecoder().decode(MessageWrapper.self, from: data)
    }
    
    // Decode the data that is stored inside the MessageWrapper using
    // the type it had before encoding.
    public static func decodeData<T>(type: T.Type, data: Data) throws -> T where T: Codable {
        return try PropertyListDecoder().decode(type, from: data)
    }
}
