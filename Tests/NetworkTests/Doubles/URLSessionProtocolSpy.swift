import Foundation
import NetworkInterface

final class URLSessionProtocolStub: URLSessionProtocol {

    private(set) var dataTaskCalledCount = 0
    var dataTaskCalled: Bool { dataTaskCalledCount > 0 }
    private(set) var dataTaskRequestPassed: URLRequest?
    var dataTaskToBeReturned: (data: Data?, response: URLResponse?, error: Error?)?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTaskCalledCount += 1
        dataTaskRequestPassed = request
        completionHandler(
            dataTaskToBeReturned?.data,
            dataTaskToBeReturned?.response,
            dataTaskToBeReturned?.error
        )
    }
}
