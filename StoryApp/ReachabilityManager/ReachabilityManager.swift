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
protocol ReachabilityChanged {
    func ConnectivityChanged(notification: Notification)
}
protocol Reachable: class, ReachabilityChanged {
    func startMonitoring()
    func stopMonitoring()
    func IsInternetAvailalbe() -> Bool
}
class ReachabilityManager: Reachable {
    private var observers: [AnyObject] = []
    private let reachability: Reachability?
    static let sharedManager = ReachabilityManager()
    private init() {
        reachability = try? Reachability()
    }
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(ConnectivityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
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
    func IsInternetAvailalbe() -> Bool {
        switch reachability?.connection {
        case .wifi, .cellular:
            return true
        default:
            return false
        }
    }
    @objc func ConnectivityChanged(notification: Notification) {
        if let reachebility = notification.object as? Reachability {
            for eachObserver in observers {
                eachObserver.ConnectivityChanged(notification: notification)
            }
            switch reachebility.connection {
            case .unavailable:
                print("internet unavailable")
            case .cellular:
                print("internet cellular")
            case .wifi:
                print("internet wifi")
            default:
                break
            }
        }
    }
    func addObserver(observer: ReachabilityChanged & AnyObject) {
        self.observers.append(observer)
    }
}
