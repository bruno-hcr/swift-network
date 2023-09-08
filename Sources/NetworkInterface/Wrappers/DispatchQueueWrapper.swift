import Foundation

public protocol DispatchQueueProtocol {
    func async(
        group: DispatchGroup?,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @convention(block) () -> Void
    )
}

extension DispatchQueueProtocol {
    public func async(
        group: DispatchGroup? = nil,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping @convention(block) () -> Void
    ) {
        async(group: group, qos: qos, flags: flags, execute: work)
    }
}

extension DispatchQueue: DispatchQueueProtocol {}
