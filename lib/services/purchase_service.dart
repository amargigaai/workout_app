import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../config/constants.dart';

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _isPremium = false;

  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;
  bool get isPremium => _isPremium;

  /// Callback when purchase status changes
  Function(bool isPremium)? onPurchaseUpdated;

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (_) {},
    );

    // Load products
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    const ids = {
      AppConstants.monthlySubscriptionId,
      AppConstants.annualSubscriptionId,
    };

    final response = await _iap.queryProductDetails(ids);
    _products = response.productDetails;
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _isPremium = true;
        onPurchaseUpdated?.call(true);

        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle error
      }
    }
  }

  /// Buy a subscription
  Future<bool> buySubscription(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
  }
}
