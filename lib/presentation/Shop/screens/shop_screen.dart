import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/audio_player.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/buy_diamond_key_button.dart';
import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
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
  AudioPlayerService audioPlayer = AudioPlayerService();
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
  // int _keys = 0;

  AudioPlayerService audioplayer;

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
    audioPlayer.disposePlayer();
    super.dispose();
  }

  void _initialise() async {
    // Check availilbility of In App Purchases
    audioPlayer = AudioPlayerService();
    _isAvailable = await _iap.isAvailable();
    // FlutterInappPurchase.instance.clearTransactionIOS();

    if (_isAvailable) {
      await FlutterInappPurchase.instance.clearTransactionIOS();
      await _getProducts();
      // // Listen to new purchases
      _subscription = _iap.purchaseUpdatedStream.listen(
        (purchaseDetails) {
          setState(
            () {
              _purchases.addAll(purchaseDetails);
              Platform.isIOS
                  ? _getPastPurchases(purchaseDetails)
                  : _verifyPurchase();
            },
          );
        },
      );
    } else if (!_isAvailable) {
      _isAvailable = await _iap.isAvailable();

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

          _products?.sort((a, b) => a.title.length.compareTo(b.title.length));
        });
    } catch (e) {
      PlatformAlertDialog(
              title: 'Error', content: e.toString(), defaultActionText: 'OK')
          .show(context);
    }
  }

  // Gets past purchases and consume/complete purchase
  Future<void> _getPastPurchases(List<PurchaseDetails> pastPurchases) async {
    log('past purchaes ');

    for (PurchaseDetails purchase in pastPurchases) {
      _purchases = [];

      _purchases.add(purchase);

      _verifyPurchase();
    }
  }

  // Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere(
      (purchase) => purchase.productID == productID,
      orElse: () => null,
    );
  }

  void _verifyPurchase() async {
    log('veryifyPurchase ');
    DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    UserData _userData = Provider.of<UserData>(context, listen: false);

    PurchaseDetails _purchase = _hasPurchased(_currentPurchase);
    log('productID: ${_purchase?.productID}');
    log('purchase length: ${_purchases.length}');
    if (_purchase != null && _purchase.status == PurchaseStatus.purchased) {
      log('Product purchased');
      _displayDiamonds(_purchase);

      await _iap.completePurchase(_purchase);
      final _updateUserData = UserData(
        displayName: _userData.displayName,
        email: _userData.email,
        locationsExplored: _userData.locationsExplored,
        photoURL: _userData.photoURL,
        uid: _userData.uid,
        points: _userData.points,
        isAdmin: _userData.isAdmin,
        userDiamondCount: _userData.userDiamondCount + _diamonds,
        // userKeyCount: _userData.userKeyCount + _keys,
        seenIntro: _userData.seenIntro,
      );

      _databaseService.updateUserData(userData: _updateUserData);
      final _didSelectOK = await PlatformAlertDialog(
              backgroundColor: Colors.brown,
              titleTextColor: Platform.isIOS ? Colors.black87 : Colors.white,
              contentTextColor: Platform.isIOS ? Colors.black87 : Colors.white,
              title: 'Jackpot!',
              content: 'The loot has been added to ye treasure chest.',
              image: Image.asset('images/ic_thnx.png'),
              defaultActionText: 'Sweet')
          .show(context);
      if (_didSelectOK) {
        audioPlayer.playSound(path: 'location_discovered.mp3');

        _isPurchasePending = false;
        _purchases = [];
      }
    } else if (_purchase != null &&
        _purchase.status == PurchaseStatus.pending) {
      log('Purchase pending');

      _isPurchasePending = true;
    } else if (_purchase != null && _purchase.pendingCompletePurchase) {
      FlutterInappPurchase.instance.clearTransactionIOS();
      log('Purchase pendingCompletePurchase');
      // _iap.completePurchase(_purchase);

      setState(() {
        _isPurchasePending = false;
        _purchases = [];
      });
    } else if (_purchase != null && _purchase.status == PurchaseStatus.error) {
      print('Purchase ERROR ');
      _iap.completePurchase(_purchase);
      _isPurchasePending = false;

      _purchases = [];
    } else
      setState(() {
        _isPurchasePending = false;
      });
  }

  void _displayDiamonds(PurchaseDetails purchase) {
    switch (purchase.productID) {
      case _diamond50:
        _diamonds = 50;
        // _keys = 0;
        break;
      case _diamond150:
        _diamonds = 150;
        // _keys = 1;
        break;
      case _diamond300:
        _diamonds = 300;
        // _keys = 3;
        break;
      case _diamond500:
        _diamonds = 500;
        // _keys = 5;
        break;
    }
  }

  void _buyProduct(ProductDetails productDetails) async {
    FlutterInappPurchase.instance.clearTransactionIOS();
    log('Buy Product ');
    setState(() {
      _isPurchasePending = true;
    });

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    try {
      await _iap.buyConsumable(
        purchaseParam: purchaseParam,
      );
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
          backgroundColor: Colors.brown,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            DiamondAndKeyContainer(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              numberOfDiamonds: _userData?.userDiamondCount,
              // numberOfKeys: _userData?.userKeyCount,
              diamondHeight: 30,
              // skullKeyHeight: 33,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              diamondSpinning: true,
              showShop: false,
            ),
            SizedBox(width: 15)
          ]),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: const AssetImage(
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
                      titleTextColor:
                          Platform.isIOS ? Colors.black87 : Colors.white,
                      contentTextColor:
                          Platform.isIOS ? Colors.black87 : Colors.white,
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
          if (_isAvailable &&
              ConnectivityService.checkNetwork(context, listen: true))
            // Display products from store

            for (var prod in _products)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: BuyDiamondOrKeyButton(
                  numberOfDiamonds: numberOfDiamonds(prod.id),
                  diamondCost: prod.price,
                  // bonusKey: numberOfKeys(prod.id),
                  isPurchasePending: _isPurchasePending,
                  onPressed: () {
                    _buyProduct(prod);
                    _currentPurchase = prod.id;
                  },
                ),
              )
          else
            !_isPurchasePending
                ? Column(
                    children: <Widget>[
                      StoreLoadingButton(),
                      StoreLoadingButton(),
                      StoreLoadingButton(),
                      StoreLoadingButton(),
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                        child: CustomCircularProgressIndicator(
                      color: Colors.white,
                    )),
                  )
        ]),
      ),
    );
  }

  String numberOfDiamonds(String productId) {
    String _numberOfDiamonds;
    switch (productId) {
      case _diamond50:
        _numberOfDiamonds = '50';
        break;
      case _diamond150:
        _numberOfDiamonds = '150';
        break;
      case _diamond300:
        _numberOfDiamonds = '300';
        break;
      case _diamond500:
        _numberOfDiamonds = '500';
        break;
      default:
        _numberOfDiamonds = '50';
    }
    return _numberOfDiamonds;
  }

  // String numberOfKeys(String productId) {
  //   String _numberOfKeys;
  //   switch (productId) {
  //     case _diamond50:
  //       _numberOfKeys = '0';
  //       break;
  //     case _diamond150:
  //       _numberOfKeys = '1';
  //       break;
  //     case _diamond300:
  //       _numberOfKeys = '3';
  //       break;
  //     case _diamond500:
  //       _numberOfKeys = '5';
  //       break;
  //     default:
  //       _numberOfKeys = '0';
  //   }
  //   return _numberOfKeys;
  // }
}

class StoreLoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Shimmer.fromColors(
          period: const Duration(milliseconds: 750),
          baseColor: Colors.grey.shade300.withOpacity(0.5),
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
