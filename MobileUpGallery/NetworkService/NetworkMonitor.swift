import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = false
    private(set) var connectionType: NWInterface.InterfaceType = .other
    
    var statusChangeHandler: ((Bool) -> Void)?
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            self.isConnected = path.status == .satisfied
            self.connectionType = path.availableInterfaces.filter { path.usesInterfaceType($0.type) }.first?.type ?? .other
            
            if self.isConnected {
                print("Connected to the Internet via \(self.connectionType)")
            } else {
                print("No Internet Connection")
            }
            DispatchQueue.main.async {
                self.statusChangeHandler?(self.isConnected)
            }
        }
        monitor.start(queue: queue)
    }
}
