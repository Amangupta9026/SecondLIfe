import 'package:flutter/material.dart';
import '../../api/api_services.dart';
import '../../global/color.dart';

import '../../api/api_constant.dart';
import '../../sharedpreference/sharedpreference.dart';
import 'recharge_screen.dart';
import 'transaction_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String walletAmount = "0.0";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      String amount = await APIServices.getWalletAmount(
              SharedPreference.getValue(PrefConstants.MERA_USER_ID)) ??
          "0.0";
      setState(() {
        walletAmount = amount;
        SharedPreference.setValue(PrefConstants.WALLET_AMOUNT, walletAmount);
      });
    });
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorGradient1,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: colorBlack)),
          bottom: TabBar(
            padding: const EdgeInsets.only(left: 40, right: 40),
            controller: _tabController,
            tabs: const [
              Tab(
                  icon: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("Recharge", style: TextStyle(color: colorBlack)),
              )),
              Tab(
                  icon: FittedBox(
                fit: BoxFit.fitWidth,
                child:
                    Text("Transactions", style: TextStyle(color: colorBlack)),
              )),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹ $walletAmount /-",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBlack),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Current Balance",
                    style: TextStyle(fontSize: 12, color: colorBlack),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [colorGradient1, colorGradient2],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: const [
                RechargeScreen(),
                TransactionScreen(),
              ],
            ),
          ),
        ));
  }
}
