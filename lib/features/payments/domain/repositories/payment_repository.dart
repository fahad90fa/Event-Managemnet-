import '../../domain/entities/payment_entities.dart';

abstract class PaymentRepository {
  Future<List<PaymentGateway>> getGateways();
  Future<List<PaymentAccount>> getAccounts(String weddingId);
  Future<PaymentTransaction> initiatePayment(String gatewayCode, double amount,
      String currency, Map<String, dynamic> params);
  Future<List<PaymentTransaction>> getTransactions(String weddingId);
  Future<Map<String, dynamic>> getPaymentSummary(String weddingId);
  Future<List<VendorPaymentMilestone>> getVendorMilestones(String weddingId);
  Future<void> payMilestone(String milestoneId);
}
