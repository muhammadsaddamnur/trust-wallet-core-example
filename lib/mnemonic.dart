import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:provider/provider.dart';
import 'package:trust_wallet_core_explore/core/core_provider.dart';
import 'package:trust_wallet_core_explore/wallet_list.dart';

class Mnemonic extends StatefulWidget {
  const Mnemonic({Key? key}) : super(key: key);

  @override
  _MnemonicState createState() => _MnemonicState();
}

class _MnemonicState extends State<Mnemonic> {
  List mnemonicList = [];

  void Function()? generateMnemonic() {
    CoreProvider provider = Provider.of<CoreProvider>(context, listen: false);
    provider.initWallet();

    mnemonicList = provider.wallet.mnemonic().split(' ');
    setState(() {});
  }

  @override
  void initState() {
    FlutterTrustWalletCore.init();
    Future.microtask(() => generateMnemonic());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Secreat Recovery Pharse',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: mnemonicList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 0.1,
                    childAspectRatio: 6),
                itemBuilder: (context, index) {
                  return Center(
                    child: Text('${(index + 1)}. ${mnemonicList[index]}'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: generateMnemonic,
                child: const Text('Generate'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletList(),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
