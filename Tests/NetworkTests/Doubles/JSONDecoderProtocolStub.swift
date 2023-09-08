import Foundation
import NetworkInterface

final class JSONDecoderProtocolStub: JSONDecoderProtocol {

    private(set) var decodeCalled = false
    private(set) var decodeDataPassed: Data?
    var decodeToBeReturned: Any?

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        decodeCalled = true
        decodeDataPassed = data
        if let object = decodeToBeReturned as? T {
            return object
        } else {
            throw NetworkServiceMocks.FailedToDecodeMock()
        }
    }
}
