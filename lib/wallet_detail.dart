import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:provider/provider.dart';
import 'package:trust_wallet_core_explore/core/core_provider.dart';
import 'package:convert/convert.dart';
import 'package:trust_wallet_core_explore/wallet_detail_transaction.dart';

class WalletDetailParams {
  final String title;
  final int twCoinType;
  const WalletDetailParams(
      {Key? key, required this.title, required this.twCoinType});
}

class WalletDetail extends StatefulWidget {
  final WalletDetailParams walletDetailParams;
  const WalletDetail({Key? key, required this.walletDetailParams})
      : super(key: key);

  @override
  _WalletDetailState createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  PrivateKey? privateKey;

  void Function()? getPrivateKey() {
    CoreProvider provider = Provider.of<CoreProvider>(context, listen: false);
    privateKey =
        provider.wallet.getKeyForCoin(widget.walletDetailParams.twCoinType);
    // provider.wallet.getKey(widget.twCoinType, "m/84'/0'/0'/0/0");

    setState(() {});
  }

  @override
  void initState() {
    Future.microtask(() => getPrivateKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CoreProvider provider = Provider.of<CoreProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.walletDetailParams.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WalletDetailTransaction(
                          walletDetailParams: widget.walletDetailParams)));
            },
            icon: const Icon(Icons.monetization_on),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                '=Mnemonic=\n' + provider.wallet.mnemonic().toString(),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                '=Address=\n' +
                    provider.wallet
                        .getAddressForCoin(widget.walletDetailParams.twCoinType)
                        .toString(),
                textAlign: TextAlign.center,
              ),
            ),
            if (privateKey != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  '=Private Key=\n' + hex.encode(privateKey!.data()),
                  textAlign: TextAlign.center,
                ),
              ),
            if (privateKey != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  '=Public Key=\n' +
                      hex.encode(
                          privateKey!.getPublicKeySecp256k1(true).data()),
                  textAlign: TextAlign.center,
                ),
              ),
            ethWidget()
          ],
        ),
      ),
    );
  }

  Widget ethWidget() {
    CoreProvider provider = Provider.of<CoreProvider>(context, listen: false);
    return privateKey == null
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  '=Seed=\n' + hex.encode(provider.wallet.seed()).toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  '=Keystore=\n' +
                      StoredKey.importPrivateKey(privateKey!.data(), "", "123",
                              widget.walletDetailParams.twCoinType)!
                          .exportJson()
                          .toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  '=PublicKeySecp256k1=\n' +
                      AnyAddress.createWithPublicKey(
                              privateKey!.getPublicKeySecp256k1(true), 0)
                          .description()
                          .toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
  }
}
