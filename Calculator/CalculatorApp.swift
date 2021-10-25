//
//  CalculatorApp.swift
//  Calculator
//
//  Created by anjt on 2021/9/27.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(GlobalEnvironment())
        }
    }
}
