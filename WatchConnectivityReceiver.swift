import WatchConnectivity
import SwiftUI

class WatchConnectivityReceiver: NSObject, WCSessionDelegate, ObservableObject {
    
    static let shared = WatchConnectivityReceiver()
    @Published var receivedImage: UIImage?

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        //Here we get the image from the other file.
        let fileURL = file.fileURL
        if let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            DispatchQueue.main.async {
                self.receivedImage = image
                print(self.receivedImage)
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
                // Handle the error appropriately in your app.
                print("WCSession activation failed with error: \(error.localizedDescription)")
                return
            }
            
            switch activationState {
            case .activated:
                print("WCSession is activated.")
            case .inactive:
                print("WCSession is inactive.")
            case .notActivated:
                print("WCSession is not activated.")
            @unknown default:
                print("Unknown WCSession activation state.")
            }
    }
}

