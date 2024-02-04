//
//  WatchConnectivityManager.swift
//  Personal Business Card
//
//  Created by Alexander Lins on 2024-02-03.
//

import SwiftUI
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // WCSessionDelegate method for session activation
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Implement as needed
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Required for iOS
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Required for iOS. Reactivate the session.
        session.activate()
    }
    #endif

    func sendImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try imageData.write(to: fileURL)
            WCSession.default.transferFile(fileURL, metadata: nil)
        } catch {
            print("Error saving image: \(error.localizedDescription)")
        }
    }
}
