import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // NEW: untuk format rupiah

void main() {
  runApp(MyApp());
}

/// Judul aplikasi: MyMoney Wallet
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMoney Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

/// Helper: format rupiah (Rp 100000 → Rp 100.000)
String formatRupiah(double value) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(value);
}

/// Model sederhana untuk transaksi
class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome; // true = pemasukan, false = pengeluaran
  final String category; // NEW: kategori

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category, // NEW
  });
}

/// Halaman utama dengan BottomNavigationBar 5 layar
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Transaction> _transactions = [];

  // Contoh nilai batas anggaran bulanan (bisa kamu ubah)
  final double _monthlyBudgetLimit = 3000000;

  void _addTransaction(Transaction tx) {
    setState(() {
      _transactions.add(tx);
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  double get _totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _balance => _totalIncome - _totalExpense;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        balance: _balance,
        income: _totalIncome,
        expense: _totalExpense,
      ),
      TransactionsScreen(
        transactions: _transactions,
        onDelete: _deleteTransaction, // NEW
      ),
      AddTransactionScreen(onAddTransaction: _addTransaction),
      BudgetScreen(
        totalExpense: _totalExpense,
        budgetLimit: _monthlyBudgetLimit,
      ),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('MyMoney Wallet'),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Anggaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

/// =============== 1. DASHBOARD SCREEN =================

class DashboardScreen extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const DashboardScreen({
    Key? key,
    required this.balance,
    required this.income,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Saldo Saat Ini',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formatRupiah(balance), // pakai format rupiah
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.arrow_downward, color: Colors.green),
                        const SizedBox(height: 8),
                        Text('Pemasukan'),
                        const SizedBox(height: 4),
                        Text(
                          formatRupiah(income),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.arrow_upward, color: Colors.red),
                        const SizedBox(height: 8),
                        Text('Pengeluaran'),
                        const SizedBox(height: 4),
                        Text(
                          formatRupiah(expense),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Ringkasan Keuangan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola pemasukan dan pengeluaranmu langsung dari aplikasi ini.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// =============== 2. TRANSACTIONS SCREEN =================

class TransactionsScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(int) onDelete; // NEW

  const TransactionsScreen({
    Key? key,
    required this.transactions,
    required this.onDelete, // NEW
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text('Belum ada transaksi. Tambahkan dari menu "Tambah".'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: tx.isIncome ? Colors.green : Colors.red,
              child: Icon(
                tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
            title: Text(tx.title),
            subtitle: Text(
              '${tx.category} • ${tx.date.day}/${tx.date.month}/${tx.date.year}',
            ), // NEW: tampilkan kategori
            trailing: Text(
              (tx.isIncome ? '+ ' : '- ') + formatRupiah(tx.amount),
              style: TextStyle(
                color: tx.isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onLongPress: () async {
              // NEW: dialog konfirmasi hapus
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Hapus Transaksi'),
                    content:
                        Text('Yakin ingin menghapus transaksi "${tx.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                onDelete(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transaksi dihapus')),
                );
              }
            },
          ),
        );
      },
    );
  }
}

/// =============== 3. ADD TRANSACTION SCREEN =================

class AddTransactionScreen extends StatefulWidget {
  final Function(Transaction) onAddTransaction;

  const AddTransactionScreen({
    Key? key,
    required this.onAddTransaction,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = false;
  String _selectedCategory = 'Lainnya';

  final List<String> _categories = [
    'Makan & Minum',
    'Transport',
    'Belanja',
    'Tagihan',
    'Gaji',
    'Freelance',
    'Lainnya',
  ];

  void _submit() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul dan jumlah harus diisi dengan benar')),
      );
      return;
    }

    final tx = Transaction(
      title: title,
      amount: amount,
      date: DateTime.now(),
      isIncome: _isIncome,
      category: _selectedCategory, // NEW
    );

    widget.onAddTransaction(tx);

    _titleController.clear();
    _amountController.clear();
    setState(() {
      _isIncome = false;
      _selectedCategory = 'Lainnya';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaksi berhasil ditambahkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Transaksi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Jumlah (Rp)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Text('Kategori'),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Jenis: '),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Pengeluaran'),
                  selected: !_isIncome,
                  onSelected: (selected) {
                    setState(() {
                      _isIncome = false;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Pemasukan'),
                  selected: _isIncome,
                  onSelected: (selected) {
                    setState(() {
                      _isIncome = true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(Icons.save),
                label: Text('Simpan Transaksi'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// =============== 4. BUDGET SCREEN =================

class BudgetScreen extends StatelessWidget {
  final double totalExpense;
  final double budgetLimit;

  const BudgetScreen({
    Key? key,
    required this.totalExpense,
    required this.budgetLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usedPercent =
        budgetLimit == 0 ? 0.0 : (totalExpense / budgetLimit).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Anggaran Bulanan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Total Batas Anggaran:'),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(budgetLimit),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Total Pengeluaran Saat Ini:'),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(totalExpense),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: usedPercent,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Terpakai: ${(usedPercent * 100).toStringAsFixed(1)}%',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    usedPercent >= 1
                        ? '⚠️ Anggaran sudah habis, hati-hati pengeluaranmu!'
                        : 'Masih dalam batas aman, tetap bijak mengelola uang ya.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =============== 5. PROFILE SCREEN =================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Di sini kamu bisa hubungkan ke data user (login, dsb.)
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 12),
          Text(
            'Ridho',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('user@email.com'),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Pengaturan'),
            subtitle: Text('Atur preferensi aplikasi'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Keamanan'),
            subtitle: Text('Atur PIN / Password'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang Aplikasi'),
            subtitle: Text('Versi 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
