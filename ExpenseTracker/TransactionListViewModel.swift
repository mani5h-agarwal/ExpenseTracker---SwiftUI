import Foundation
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

@MainActor
final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

    init() {
        Task {
            await getTransactions()
        }
    }

    func getTransactions() async {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }

            let decodedTransactions = try JSONDecoder().decode([Transaction].self, from: data)
            self.transactions = decodedTransactions
        } catch {
            print("Error fetching transactions:", error.localizedDescription)
        }
    }
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        let groupTransactions = TransactionGroup(grouping: transactions){ $0.month }
        
        return groupTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        guard !transactions.isEmpty else { return [] }
        let today = "02/17/2022".dateParsed ()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        for date in stride(from: dateInterval.start, through: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter{ $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce (0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
        }
        return cumulativeSum
    }

}
