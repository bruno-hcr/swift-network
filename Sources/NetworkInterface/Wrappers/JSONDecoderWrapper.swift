import Foundation

public protocol JSONDecoderProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: JSONDecoderProtocol {}
