import Foundation
import NetworkInterface

final class DispatchQueueProtocolSpy: DispatchQueueProtocol {
    private(set) var syncCalledCount = 0
    var syncCalled: Bool { syncCalledCount > 0 }
    
    func sync(execute block: () -> Void) {
        syncCalledCount += 1
        block()
    }
    
    private(set) var asyncCalledCount = 0
    private(set) var asyncGroupPassed: DispatchGroup?
    private(set) var asyncQosPassed: DispatchQoS?
    private(set) var asyncFlagsPassed: DispatchWorkItemFlags = []
    var asyncCalled: Bool { syncCalledCount > 0 }
    
    func async(
        group: DispatchGroup? = nil,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping @convention(block) () -> Void
    ) {
        asyncCalledCount += 1
        asyncGroupPassed = group
        asyncQosPassed = qos
        asyncFlagsPassed = flags
        work()
    }
}
