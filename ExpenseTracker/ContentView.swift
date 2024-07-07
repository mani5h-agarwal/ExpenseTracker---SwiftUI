//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Manish Agarwal on 06/07/24.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 24){
                    Text("OverView")
                        .font(.title2)
                        .bold()
                    
                    let data = transactionListVM.accumulateTransactions()
                    if !data.isEmpty{
                        let totalExpenses = data.last?.1 ?? 0
                        CardView{
                            VStack(alignment: .leading){
                                ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title, format: "$ %.2f")
                                LineChart()
                            }
                            .background()
                        }
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: .background, foregroundColor: ColorGradient(.icon.opacity(0.4), .icon)))
                        .frame(height: 300)
                    }
                    
                    
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.icon, .primary)
                }
            }
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
        .environmentObject(TransactionListViewModel())
}
