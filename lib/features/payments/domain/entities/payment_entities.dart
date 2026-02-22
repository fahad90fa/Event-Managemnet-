import 'package:equatable/equatable.dart';

class PaymentGateway extends Equatable {
  final String id;
  final String gatewayName;
  final String gatewayCode;
  final List<String> supportedCurrencies;
  final bool isActive;
  final double processingFeePercentage;
  final String? logoUrl;

  const PaymentGateway({
    required this.id,
    required this.gatewayName,
    required this.gatewayCode,
    required this.supportedCurrencies,
    this.isActive = true,
    this.processingFeePercentage = 0,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        gatewayName,
        gatewayCode,
        supportedCurrencies,
        isActive,
        processingFeePercentage,
        logoUrl
      ];
}

enum AccountType { jazzcashWallet, easypaisaWallet, bankAccount, creditCard }

class PaymentAccount extends Equatable {
  final String id;
  final String weddingProjectId;
  final AccountType accountType;
  final String accountHolderName;
  final Map<String, dynamic> accountDetails;
  final bool isPrimary;
  final bool isVerified;

  const PaymentAccount({
    required this.id,
    required this.weddingProjectId,
    required this.accountType,
    required this.accountHolderName,
    required this.accountDetails,
    this.isPrimary = false,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        weddingProjectId,
        accountType,
        accountHolderName,
        accountDetails,
        isPrimary,
        isVerified
      ];
}

enum TransactionType {
  deposit,
  advancePayment,
  finalPayment,
  refund,
  salamiGift
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  disputed
}

class PaymentTransaction extends Equatable {
  final String id;
  final String weddingProjectId;
  final String? paymentId;
  final TransactionType transactionType;
  final double amount;
  final String currency;
  final String? gatewayTransactionId;
  final TransactionStatus status;
  final DateTime initiatedAt;
  final DateTime? completedAt;
  final String? receiptUrl;

  const PaymentTransaction({
    required this.id,
    required this.weddingProjectId,
    this.paymentId,
    required this.transactionType,
    required this.amount,
    this.currency = 'PKR',
    this.gatewayTransactionId,
    this.status = TransactionStatus.pending,
    required this.initiatedAt,
    this.completedAt,
    this.receiptUrl,
  });

  @override
  List<Object?> get props => [
        id,
        weddingProjectId,
        paymentId,
        transactionType,
        amount,
        currency,
        gatewayTransactionId,
        status,
        initiatedAt,
        completedAt,
        receiptUrl
      ];
}

enum MilestoneStatus { pending, paid, overdue }

class VendorPaymentMilestone extends Equatable {
  final String id;
  final String vendorId;
  final String vendorName;
  final String title;
  final double amount;
  final DateTime dueDate;
  final MilestoneStatus status;
  final String? receiptUrl;

  const VendorPaymentMilestone({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.receiptUrl,
  });

  @override
  List<Object?> get props =>
      [id, vendorId, vendorName, title, amount, dueDate, status, receiptUrl];
}
