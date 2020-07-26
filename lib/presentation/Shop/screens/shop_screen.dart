import 'dart:async';
import 'dart:io';

import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/buy_diamond_key_button.dart';
import 'package:find_the_treasure/widgets_common/custom_raised_button.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// App Store and Google Play consumable IDS
const String _diamond50 = 'diamond_50';
const String _diamond150 = 'diamond_150';
const String _diamond300 = 'diamond_300';
const String _diamond500 = 'diamond_500';
String _currentPurchase;

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // IAP Plugin Interface
  final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  // Updates to purchases
  StreamSubscription<List<PurchaseDetails>> _subscription;

  // Products for sale
  List<ProductDetails> _products = [];
  // Past purchases
  List<PurchaseDetails> _purchases = [];
  // Is the API available on the device
  bool _isAvailable = false;
  // Diasble button if purchase pending
  bool _isPurchasePending = false;

  // Consumable credits the user can buy
  int _diamonds = 0;
  int _keys = 0;

  @override
  void initState() {
    _initialise();
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    _isPurchasePending = false;
    super.dispose();
  }

  void _initialise() async {
    // Check availilbility of In App Purchases

    _isAvailable = await _iap.isAvailable();
    FlutterInappPurchase.instance.clearTransactionIOS();
    if (_isAvailable) {
      List<Future> futures = [_getProducts(), _getPastPurchases()];
      await Future.wait(futures);
      _verifyPurchase();

      // Listen to new purchases
      _subscription = _iap.purchaseUpdatedStream.listen(
        (purchaseDetails) {
          setState(
            () {
              _purchases.addAll(purchaseDetails);
              _verifyPurchase();
            },
          );
        },
      );
    } else if (!_isAvailable) {
      print('not');
      setState(() {});
    }
  }

  // Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids =
        Set.from([_diamond50, _diamond150, _diamond300, _diamond500]);
    try {
      ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      if (response.notFoundIDs.isEmpty)
        setState(() {
          _products = response.productDetails;
          _products.sort((a, b) => a.title.length.compareTo(b.title.length));
        });
    } catch (e) {
      PlatformAlertDialog(
              title: 'Error', content: e.toString(), defaultActionText: 'OK')
          .show(context);
    }
  }

  // Gets past purchases and consume/complete purchase
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.completePurchase(
          purchase,
        );
      } else
        _iap.consumePurchase(
          purchase,
        );
    }

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  // Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere(
      (purchase) => purchase.productID == productID,
      orElse: () => null,
    );
  }

  void _verifyPurchase() async {
    DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    UserData _userData = Provider.of<UserData>(context, listen: false);

    PurchaseDetails _purchase = _hasPurchased(_currentPurchase);
    print('productID: ${_purchase?.productID}');
    print(_purchases);
    if (_purchase != null && _purchase.status == PurchaseStatus.purchased) {
      _displayDiamondAndKeys(_purchase);

      _isPurchasePending = true;

      final _updateUserData = UserData(
        displayName: _userData.displayName,
        email: _userData.email,
        locationsExplored: _userData.locationsExplored,
        photoURL: _userData.photoURL,
        uid: _userData.uid,
        points: _userData.points,
        isAdmin: _userData.isAdmin,
        userDiamondCount: _userData.userDiamondCount + _diamonds,
        userKeyCount: _userData.userKeyCount + _keys,
        seenIntro: _userData.seenIntro,
        
      );
      await _databaseService.updateUserData(userData: _updateUserData);
      final _didSelectOK = await PlatformAlertDialog(
              backgroundColor: Colors.brown,
              titleTextColor: Colors.white,
              contentTextColor: Colors.white,
              title: 'Jackpot!',
              content:
                  'The loot has been added to ye treasure chest. Happy adventures.',
              image: Image.asset('images/ic_thnx.png'),
              defaultActionText: 'Sweet')
          .show(context);
      if (_didSelectOK) {
        _iap.completePurchase(_purchase);
        setState(() {
          _isPurchasePending = false;
          _purchases = [];
        });
      }
    } else if (_purchase != null &&
        _purchase.status == PurchaseStatus.pending) {
      _getPastPurchases();
      print('pending');
      setState(() {
        _isPurchasePending = true;
      });
    } else if (_purchase != null && _purchase.pendingCompletePurchase) {
      print('pendingComplete');

      _iap.completePurchase(_purchase);
      _isPurchasePending = false;

      setState(() {
        _purchases = [];
      });
    } else
      setState(() {
        _isPurchasePending = false;
      });
  }

  void _displayDiamondAndKeys(PurchaseDetails purchase) {
    switch (purchase.productID) {
      case _diamond50:
        _diamonds = 50;
        _keys = 0;
        break;
      case _diamond150:
        _diamonds = 150;
        _keys = 1;
        break;
      case _diamond300:
        _diamonds = 300;
        _keys = 3;
        break;
      case _diamond500:
        _diamonds = 500;
        _keys = 5;
        break;
    }
  }

  void _buyProduct(ProductDetails productDetails) async {
    _isPurchasePending = true;
//TODO: change to sandboxTesting: false on final release
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails, sandboxTesting: true);

    // await FlutterInappPurchase.instance.clearTransactionIOS();

    try {
      await _iap.buyConsumable(
        purchaseParam: purchaseParam,
      );
      await _getPastPurchases();
    } catch (e) {
      _isPurchasePending = false;
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserData _userData = Provider.of<UserData>(context);
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: _isAvailable && ConnectivityService.checkNetwork(context)
            ? null
            : Text('Shop Loading...'),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          DiamondAndKeyContainer(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            numberOfDiamonds: _userData.userDiamondCount,
            numberOfKeys: _userData.userKeyCount,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: AssetImage(
              "images/background_shop.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.brown.shade300,
              size: 40,
            ),
            tooltip: 'Store questions',
            onPressed: () async {
              final _didSelectOK = await PlatformAlertDialog(
                      backgroundColor: Colors.brown,
                      titleTextColor: Colors.white,
                      contentTextColor: Colors.white,
                      title: 'Welcome to The Shop',
                      content:
                          'Stock ye treasure chest with diamonds and keys. Use \'em to unlock quests and ye can also trade \'em for hints',
                      image: Image.asset('images/ic_thnx.png'),
                      defaultActionText: 'OK')
                  .show(context);
              if (_didSelectOK) {}
            },
          ),
          const SizedBox(
            height: 10,
          ),
          if (_isAvailable && ConnectivityService.checkNetwork(context))
            // Display products from store
            for (var prod in _products)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: BuyDiamondOrKeyButton(
                  numberOfDiamonds: numberOfDiamonds(prod.price),
                  diamondCost: prod.price,
                  bonusKey: numberOfKeys(prod.price),
                  isPurchasePending: _isPurchasePending,
                  onPressed: () {
                    _buyProduct(prod);
                    _currentPurchase = prod.id;
                  },
                ),
              )
          else
            Column(
              children: <Widget>[
                StoreLoadingButton(),
                StoreLoadingButton(),
                StoreLoadingButton(),
                StoreLoadingButton(),
              ],
            )
        ]),
      ),
    );
  }

  String numberOfDiamonds(String productPrice) {
    String _numberOfDiamonds;
    switch (productPrice) {
      case '\$4.99':
        _numberOfDiamonds = '50';
        break;
      case '\$9.99':
        _numberOfDiamonds = '150';
        break;
      case '\$19.99':
        _numberOfDiamonds = '300';
        break;
      case '\$39.99':
        _numberOfDiamonds = '500';
        break;
      default:
        _numberOfDiamonds = '50';
    }
    return _numberOfDiamonds;
  }

  String numberOfKeys(String productPrice) {
    String _numberOfKeys;
    switch (productPrice) {
      case '\$4.99':
        _numberOfKeys = '0';
        break;
      case '\$9.99':
        _numberOfKeys = '1';
        break;
      case '\$19.99':
        _numberOfKeys = '3';
        break;
      case '\$39.99':
        _numberOfKeys = '5';
        break;
      default:
        _numberOfKeys = 'err';
    }
    return _numberOfKeys;
  }
}

class StoreLoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Shimmer.fromColors(
          period: Duration(milliseconds: 750),
          baseColor: Colors.grey.shade300,
          // direction: ShimmerDirection.btt,
          highlightColor: Colors.white,
          child: CustomRaisedButton(
            color: Colors.white,
            onPressed: () {},
            padding: MediaQuery.of(context).size.height / 30,
          ),
        ),
      ),
    );
  }
}
