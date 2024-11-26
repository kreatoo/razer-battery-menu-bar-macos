//
//  razer_battery_menu_barApp.swift
//  razer-battery-menu-bar
//
//  Created by Alex Perathoner on 26/11/24.
//

import SwiftUI

@main
struct razer_battery_menu_barApp: App {
    @StateObject private var batteryMonitor = BatteryMonitor()
    
    func getIcon(_ batteryLevel: Int) -> String {
        switch batteryLevel {
        case 91...100:
            return "battery.100percent"
        case 71...90:
            return "battery.75percent"
        case 46...70:
            return "battery.50percent"
        case 21...45:
            return "battery.25percent"
        default:
            return "battery.0percent"
        }
    }
    
    var body: some Scene {
        MenuBarExtra {
            Text("\(batteryMonitor.batteryLevel)%")
            Text(batteryMonitor.isCharging ? "Charging" : "Discharging")
            Button("Update") {
                batteryMonitor.updateBatteryLevel()
            }
            Divider()
            Text("By Alex Pera")
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .onAppear {
                batteryMonitor.updateBatteryLevel()
            }
        } label: {
            
            let renderer = ImageRenderer(content:
                HStack {
                    Image(nsImage: NSImage(named: "Image")!).colorScheme(.dark)
                    Image(systemName: getIcon(batteryMonitor.batteryLevel)).padding(.leading, -10).colorScheme(.dark)
                }
            )
            Image(nsImage: renderer.nsImage!)
        }
    }
}
