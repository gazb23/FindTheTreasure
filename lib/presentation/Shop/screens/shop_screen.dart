import 'dart:async';
import 'dart:io';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/buy_diamond_key_button.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

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
    _subscription.cancel();
    super.dispose();
  }

  void _initialise() async {
    // Check availilbility of In App Purchases
    _isAvailable = await _iap.isAvailable();

    if (_isAvailable) {
      List<Future> futures = [_getProducts(), _getPastPurchases()];
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
    Set<String> ids =
        Set.from([_diamond50, _diamond150, _diamond300, _diamond500]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
      _products.sort((a, b) => a.title.length.compareTo(b.title.length));
    });
  }

  // Gets past purchases (May not need)
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      else InAppPurchaseConnection.instance.consumePurchase(purchase);
    }

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  // Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
        
       return _purchases.firstWhere(
        (purchase) => purchase.productID == productID,
        orElse: () => null,);
    
  }
 
  
   
   
      
      
  

  void _verifyPurchase() async {
    DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    UserData _userData = Provider.of<UserData>(context, listen: false);

  PurchaseDetails _purchase = _hasPurchased(_currentPurchase); 
    if (_purchase != null && _purchase.status == PurchaseStatus.purchased) {
  
      _isPurchasePending = true;
      _getCorrect(_purchase);

      final _updateUserData = UserData(
          displayName: _userData.displayName,
          email: _userData.email,
          photoURL: _userData.photoURL,
          uid: _userData.uid,
          userDiamondCount: _userData.userDiamondCount + _diamonds,
          userKeyCount: _userData.userKeyCount + _keys);

      final _didSelectOK = await PlatformAlertDialog(
              title: 'Jackpot!',
              content:
                  'I\'ll add the loot to ye treasure chest. Happy adventures.',
              image: Image.asset('images/ic_thnx.png'),
              defaultActionText: 'Add Loot')
          .show(context);
      if (_didSelectOK) {
        _databaseService.updateUserDiamondAndKey(userData: _updateUserData);
        _isPurchasePending = false;
      }
    } else if (_purchase != null && _purchase.status == PurchaseStatus.pending) {
      _isPurchasePending = true;
      PlatformAlertDialog(
              title: 'Purchase Pending',
              content:
                  'Your order is being processed, you\'ll recieve an order update very soon.',
              image: Image.asset('images/ic_credit_card.png'),
              defaultActionText: 'OK')
          .show(context);
    } else if (_purchase != null && _purchase.status == PurchaseStatus.error) {
      _isPurchasePending = true;
      PlatformAlertDialog(
              title: 'Shiver Me Timbers!',
              content:
                  'There has been an error whilst processing your payment. Please try again.',
              image: Image.asset('images/ic_owl_wrong.png'),
              defaultActionText: 'OK')
          .show(context);
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
      case _diamond500:
        _diamonds = 500;
        _keys = 5;
        break;
    }
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
                fit: BoxFit.cover,
              ),
            ),
            child: _isAvailable
                ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    //  Image.asset(),
                    SizedBox(
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
                                title: 'Welcome to The Shop',
                                content:
                                    'Stock ye treasure chest with diamonds and keys. Use \'em to unlock quests and ye can also trade \'em for hints!',
                                image: Image.asset('images/ic_thnx.png'),
                                defaultActionText: 'OK')
                            .show(context);
                        if (_didSelectOK) {}
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var prod in _products)
                      BuyDiamondOrKeyButton(
                        numberOfDiamonds: numberOfDiamonds(prod.price),
                        diamondCost: prod.price,
                        bonusKey: numberOfKeys(prod.price),
                        onPressed: () {
                          _buyProduct(prod);
                          _currentPurchase = prod.id;
                         
                        
                        } ,
                        isPending: _isPurchasePending,
                      ),

                    // BuyTreasureChest()
                  ])
                : Center(
                    child: Container(
                    color: Colors.white.withOpacity(0.5),
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Loading Store...'),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          'images/compass.gif',
                          height: 200,
                        )
                      ],
                    ),
                  ))),
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
        _numberOfKeys = '1';
        break;
      case '\$9.99':
        _numberOfKeys = '2';
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
