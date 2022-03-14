// Simple class

class BankAccount: CustomStringConvertible {
    var _name: String
    var _balance: Double
    
    static var getNumberOfBankAccounts = 0
    
    init(name: String, balance: Double) {
        self._name = name
        self._balance = balance
        BankAccount.getNumberOfBankAccounts += 1
    }
    
    func deposit(_ amount: Double) {
        self._balance += amount
    }
    
    func withdraw(_ amount: Double) {
        self._balance -= amount
    }
    
    var description: String {
        return "name: \(self._name), balance: \(self._balance)"
    }
}







var daveAccount = BankAccount(name: "Dave", balance: 100.00)
daveAccount._name
daveAccount._balance += 100
daveAccount._balance



daveAccount.deposit(50)
daveAccount._balance

daveAccount.withdraw(10)
daveAccount

var daveAccount2 = BankAccount(name: "Dave", balance: 180.00)
BankAccount.getNumberOfBankAccounts




// Subclass
class ATMBankAccount: BankAccount {
    var withdrawFee: Double
    
    override init(name: String, balance: Double) {
        self.withdrawFee = 2.0
        super.init(name: name, balance: balance)
    }
    
    init(name: String, balance: Double, withdrawFee: Double) {
        self.withdrawFee = withdrawFee
        super.init(name: name, balance: balance)
    }
    
    convenience init() {
        self.init(name: "Unknown", balance: 0, withdrawFee: 3.2)
    }
    
    override func withdraw(_ amount: Double) {
        super.withdraw(amount)
        self._balance -= self.withdrawFee
    }
}

var bobAccount = ATMBankAccount(name: "Bob", balance: 200.0, withdrawFee: 3.5)

bobAccount.deposit(90)
bobAccount.withdraw(70)



//var bobAccount = AtmBankAccount()
//bobAccount.deposit(100)
//bobAccount.withdraw(40)





