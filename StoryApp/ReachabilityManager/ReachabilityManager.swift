//
//  ReachabilityManager.swift
//  StoryApp
//
//  Created by shivang on 30/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//
import Reachability
import Foundation
import UIKit

protocol Reachable {
    func startMonitoring()
    func stopMonitoring()
    func reachabilityChanged(note: NSNotification)
}

class ReachabilityManager: Reachable {
    private let reachability: Reachability?
    static let sharedManager = ReachabilityManager()
    private init() {
        reachability = try? Reachability()
    }
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
    }
    func stopMonitoring() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    @objc func reachabilityChanged(note: NSNotification) {
        if let reachability = note.object as? Reachability {
            switch reachability.connection {
            case .unavailable:
                print("network unavailable")
            case .wifi:
                print("wifi connected")
            case .cellular:
                print("cellular connected")
            case .none:
                print("none network")
            }
        }
    }
}
