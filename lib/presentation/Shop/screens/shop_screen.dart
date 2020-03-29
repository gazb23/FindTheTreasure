
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/widgets_common/buy_diamond_key_button.dart';

import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

final String testID = 'diamonds_test';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // // IAP Plugin Interface
  // InAppPurchaseConnection _appPurchaseConnection =
  //     InAppPurchaseConnection.instance;

  // // Is the API available on the device
  // bool _available = true;

  // // Products for sale
  // List<ProductDetails> _products = [];

  // // Past purchases
  // List<PurchaseDetails> _purchases = [];

  // // Updates to purchases
  // StreamSubscription _subscription;

  // // Consumable cresits the user can buy
  // int _credits = 0;

  // @override
  // void initState() {
  //   _initialise();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _subscription.cancel();
  //   super.dispose();
  // }

  // void _initialise() async {
  //   // Check availilbility of In App Purchases
  //   _available = await _appPurchaseConnection.isAvailable();

  //   if (_available) {
  //     List<Future> futures = [_getProducts(), _getPastPurchases()];
  //     await Future.wait(futures);

  //     _verifyPurchase();

  //     // Listen to new purchases
  //     _subscription = _appPurchaseConnection.purchaseUpdatedStream
  //         .listen((data) => setState(() {
  //               print('NEW PURCHASE');
  //               _purchases.addAll(data);
  //             }));
  //   }
  // }

  // // Validate purchase

  // // Get all products available for sale
  // Future<void> _getProducts() async {
  //   Set<String> ids = Set.from([testID]);
  //   ProductDetailsResponse response =
  //       await _appPurchaseConnection.queryProductDetails(ids);
  //   setState(() {
  //     _products = response.productDetails;
  //   });
  // }

  // // Returns purchase of specific product ID
  // PurchaseDetails _hasPurchased(String productID) {
  //   return _purchases.firstWhere((purchase) => purchase.productID == productID,
  //       orElse: () => null);
  // }

  // void _verifyPurchase() {
  //   PurchaseDetails purchase = _hasPurchased(testID);

  //   if (purchase != null && purchase.status == PurchaseStatus.purchased) {
  //     _credits = 10;
  //   }
  // }

  // Future<void> _getPastPurchases() async {}

  // void _buyProduct(ProductDetails productDetails) {}

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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                  'These magical gems can be traded for quests and hints to help you on your quests. They also help others in need as monies raised go to the Leukaemia Foundation.' ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    
                  ),),
            ),
         BuyDiamondOrKeyButton(
           numberOfDiamonds: '10',
           diamondCost: '4.99',
           textSize: 20,
         ),
           BuyDiamondOrKeyButton(
           numberOfDiamonds: '25',
           diamondCost: '9.99',
           textSize: 20,
         ),
           BuyDiamondOrKeyButton(
           numberOfDiamonds: '50',
           diamondCost: '19.99',
           textSize: 20,
         ),
           BuyDiamondOrKeyButton(
           numberOfDiamonds: '100',
           diamondCost: '39.99',
           textSize: 20,
         ),
          ]),
        ),
      ),
    );
  }
}
