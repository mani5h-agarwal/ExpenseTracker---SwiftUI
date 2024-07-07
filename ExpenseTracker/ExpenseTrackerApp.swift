//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Manish Agarwal on 06/07/24.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    
    @StateObject var transactionListVM = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
