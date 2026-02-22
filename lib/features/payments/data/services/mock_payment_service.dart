import '../../domain/entities/payment_entities.dart';
import '../../domain/repositories/payment_repository.dart';

class MockPaymentService implements PaymentRepository {
  final List<PaymentTransaction> _transactions = [];
  final List<VendorPaymentMilestone> _milestones = [
    VendorPaymentMilestone(
      id: 'm-1',
      vendorId: 'v-1',
      vendorName: 'Royal Marquee',
      title: 'Booking Advance',
      amount: 400000,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: MilestoneStatus.paid,
    ),
    VendorPaymentMilestone(
      id: 'm-2',
      vendorId: 'v-1',
      vendorName: 'Royal Marquee',
      title: 'Post-Event Balance',
      amount: 600000,
      dueDate: DateTime.now().add(const Duration(days: 60)),
      status: MilestoneStatus.pending,
    ),
    VendorPaymentMilestone(
      id: 'm-3',
      vendorId: 'v-2',
      vendorName: 'Signature Catering',
      title: 'Tasting/Lock-in',
      amount: 150000,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      status: MilestoneStatus.overdue,
    ),
  ];

  MockPaymentService() {
    _transactions.addAll([
      PaymentTransaction(
        id: 'tx-1',
        weddingProjectId: 'wedding-1',
        transactionType: TransactionType.deposit,
        amount: 50000,
        status: TransactionStatus.completed,
        initiatedAt: DateTime.now().subtract(const Duration(days: 30)),
        completedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      PaymentTransaction(
        id: 'tx-2',
        weddingProjectId: 'wedding-1',
        transactionType: TransactionType.advancePayment,
        amount: 150000,
        status: TransactionStatus.pending,
        initiatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  @override
  Future<List<PaymentGateway>> getGateways() async {
    return [
      const PaymentGateway(
        id: 'g-1',
        gatewayName: 'JazzCash',
        gatewayCode: 'jazzcash',
        supportedCurrencies: ['PKR'],
        processingFeePercentage: 1.5,
      ),
      const PaymentGateway(
        id: 'g-2',
        gatewayName: 'Easypaisa',
        gatewayCode: 'easypaisa',
        supportedCurrencies: ['PKR'],
        processingFeePercentage: 1.2,
      ),
      const PaymentGateway(
        id: 'g-3',
        gatewayName: 'Bank Transfer',
        gatewayCode: 'bank_transfer',
        supportedCurrencies: ['PKR', 'USD'],
      ),
    ];
  }

  @override
  Future<List<PaymentAccount>> getAccounts(String weddingId) async {
    return [
      PaymentAccount(
        id: 'acc-1',
        weddingProjectId: weddingId,
        accountType: AccountType.jazzcashWallet,
        accountHolderName: 'Ahmed Khan',
        accountDetails: const {'mobile': '03001234567'},
        isPrimary: true,
        isVerified: true,
      ),
    ];
  }

  @override
  Future<PaymentTransaction> initiatePayment(String gatewayCode, double amount,
      String currency, Map<String, dynamic> params) async {
    await Future.delayed(const Duration(seconds: 1));
    final tx = PaymentTransaction(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      weddingProjectId: 'wedding-1',
      transactionType: TransactionType.advancePayment,
      amount: amount,
      currency: currency,
      status: TransactionStatus.processing,
      initiatedAt: DateTime.now(),
    );
    _transactions.add(tx);
    return tx;
  }

  @override
  Future<List<PaymentTransaction>> getTransactions(String weddingId) async {
    return _transactions.where((t) => t.weddingProjectId == weddingId).toList();
  }

  @override
  Future<Map<String, dynamic>> getPaymentSummary(String weddingId) async {
    double totalPaid = _milestones
        .where((m) => m.status == MilestoneStatus.paid)
        .fold(0, (sum, m) => sum + m.amount);
    double totalPending = _milestones
        .where((m) => m.status != MilestoneStatus.paid)
        .fold(0, (sum, m) => sum + m.amount);

    return {
      'total_budget': 1500000.0,
      'total_paid': totalPaid,
      'total_pending': totalPending,
      'currency': 'PKR',
    };
  }

  @override
  Future<List<VendorPaymentMilestone>> getVendorMilestones(
      String weddingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _milestones;
  }

  @override
  Future<void> payMilestone(String milestoneId) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _milestones.indexWhere((m) => m.id == milestoneId);
    if (index != -1) {
      final old = _milestones[index];
      _milestones[index] = VendorPaymentMilestone(
        id: old.id,
        vendorId: old.vendorId,
        vendorName: old.vendorName,
        title: old.title,
        amount: old.amount,
        dueDate: old.dueDate,
        status: MilestoneStatus.paid,
        receiptUrl: 'https://example.com/receipt-${old.id}.pdf',
      );
    }
  }
}
