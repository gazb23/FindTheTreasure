import 'dart:async';

import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/buy_diamond_key_button.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';

import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

const String _diamond50 = 'diamond_50';
const String _diamond150 = 'diamond_150';
const String _diamond300 = 'diamond_300';

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
    _subscription.cancel();
    super.dispose();
  }

  void _initialise() async {
    // Check availilbility of In App Purchases
    _isAvailable = await _iap.isAvailable();

    if (_isAvailable) {
      List<Future> futures = [_getProducts()];
      await Future.wait(futures);
      _verifyPurchase();

      // Listen to new purchases
      _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
            _purchases.addAll(data);

            _verifyPurchase();
          }));
    }
  }

  // Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from([_diamond50, _diamond150, _diamond300]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
    });
  }

  // Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(List<String> productID) {
    return _purchases.firstWhere(
        (purchase) => productID.any((prod) => prod == purchase.productID),
        orElse: () => null);

  }

  void _verifyPurchase() async {
    DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    UserData _userData = Provider.of<UserData>(context, listen: false);
    // Logic for 50 diamonds

    PurchaseDetails purchase =
        _hasPurchased([_diamond50, _diamond150, _diamond300]);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      _isPurchasePending = true;
      _getCorrect(purchase);

      final _updateUserData = UserData(
          displayName: _userData.displayName,
          email: _userData.email,
          photoURL: _userData.photoURL,
          uid: _userData.uid,
          userDiamondCount: _userData.userDiamondCount + _diamonds,
          userKeyCount: _userData.userKeyCount + _keys);

      final _didSelectOK = await PlatformAlertDialog(
              title: 'Purchase Successful',
              content: 'Your purchase has been added to your treasure chest.',
              image: Image.asset('images/ic_thnx.png'),
              defaultActionText: 'OK')
          .show(context);
      if (_didSelectOK) {
        _databaseService.updateUserDiamondAndKey(userData: _updateUserData);
        _isPurchasePending = false;
      } else {
        if (purchase != null && purchase.status == PurchaseStatus.pending) {
          _isPurchasePending = true;
          PlatformAlertDialog(
                  title: 'Pending',
                  content: 'Your order is pending',
                  image: Image.asset('images/ic_thnx.png'),
                  defaultActionText: 'OK')
              .show(context);
        }
      }
    }
  }
  void _getCorrect(PurchaseDetails purchase) {
    switch (purchase.productID) {
        case _diamond50:
          _diamonds = 50;
          _keys = 1;
          break;
          case _diamond150:
          _diamonds = 150;
          _keys = 2;
          break;
          case _diamond300:
          _diamonds = 300;
          _keys = 3;
          break;
       
      }
     setState(() {
       
     });
  }
  void _buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _iap.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          iconTheme: IconThemeData(color: Colors.black87),
          actions: <Widget>[
            Consumer<UserData>(
              builder: (_, _userData, __) => DiamondAndKeyContainer(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                numberOfDiamonds: _userData.userDiamondCount,
                numberOfKeys: _userData.userKeyCount,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "images/background_shop.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              //  Image.asset(),
              SizedBox(
                height: 20,
              ),
              for (var prod in _products)
                BuyDiamondOrKeyButton(
                  numberOfDiamonds: numberOfDiamonds(prod.price),
                  diamondCost: prod.price,
                  bonusKey: numberOfKeys(prod.price),
                  onPressed: () => _buyProduct(prod),
                  isPending: _isPurchasePending,
                ),

              // BuyTreasureChest()
            ])),
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
    }
    return _numberOfDiamonds;
  }

  String numberOfKeys(String productPrice) {
    String _numberOfKeys;
    switch (productPrice) {
      case '\$4.99':
        _numberOfKeys = '1';
        break;
      case '\$9.99':
        _numberOfKeys = '2';
        break;
      case '\$19.99':
        _numberOfKeys = '3';
        break;
    }
    return _numberOfKeys;
  }
}

class BuyTreasureChest extends StatelessWidget {
  const BuyTreasureChest({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: <Widget>[
            Image.asset(
              'images/chest.png',
              height: 40,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('? x', style: TextStyle(color: Colors.white, fontSize: 25)),
            SizedBox(width: 8),
            Image.asset(
              'images/2.0x/ic_diamond.png',
              height: 20,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('? x', style: TextStyle(color: Colors.white, fontSize: 25)),
            Image.asset(
              'images/skull_key_outline.png',
              height: 30,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade800),
          child: Text(
            '\$9.99',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ]),
      decoration: BoxDecoration(
          color: Colors.grey.shade800,
          border: Border.all(color: Colors.amberAccent, width: 2),
          borderRadius: BorderRadius.circular(35)),
    );
  }
}
