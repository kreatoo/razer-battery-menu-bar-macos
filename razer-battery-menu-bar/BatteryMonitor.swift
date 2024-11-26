//
//  BatteryMonitor.swift
//  razer-battery-menu-bar
//
//  Created by Alex Perathoner on 26/11/24.
//

import Foundation
import UserNotifications
import Cocoa

class BatteryMonitor: ObservableObject {
    @Published var batteryLevel: Int = 100
    @Published var errorMessage = ""
    @Published var isCharging: Bool = false
    @Published var sentNotification: Bool = false

    private var timer: Timer?

    init() {
        startMonitoringBattery()
        requestNotificationAuthorization()
    }

    func startMonitoringBattery() {
        timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { _ in
            self.updateBatteryLevel()
        }
        updateBatteryLevel()
    }

    func updateBatteryLevel() {
        let level = get_battery_level()
        DispatchQueue.main.async {
            if level != -1 {
                self.batteryLevel = Int(level)
                if level < 20 && !self.sentNotification {
                    self.sendLowBatteryNotification()
                }
                self.errorMessage = ""
            } else {
                self.errorMessage = "Could not get battery level"
            }

            let is_charging = is_charging()
            if is_charging != -1 {
                self.isCharging = (is_charging != 0)
                if self.sentNotification && self.isCharging {
                    self.sentNotification = false
                }
            } else {
                self.errorMessage += " Could not get charging status"
            }
        }
    }

    func sendLowBatteryNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Battery is low"
        content.subtitle = "Razer Mouse battery is under 20%"
        content.sound = UNNotificationSound.defaultCritical
        content.interruptionLevel = .critical

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
        self.sentNotification = true
    }

    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        center.requestAuthorization(options: options) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    NSApplication.shared.registerForRemoteNotifications()
                    print("Registered for remote notifications")
                }
            } else {
                print("Notification authorization denied")
            }
        }
    }
}
