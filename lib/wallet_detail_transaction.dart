import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:provider/provider.dart';
import 'package:trust_wallet_core_explore/wallet_detail.dart';
import 'package:flutter_trust_wallet_core/protobuf/bitcoin.pb.dart' as Bitcoin;
import 'package:flutter_trust_wallet_core/protobuf/ethereum.pb.dart'
    as Ethereum;
import 'package:flutter_trust_wallet_core/protobuf/tron.pb.dart' as Tron;
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'core/core_provider.dart';

class WalletDetailTransaction extends StatefulWidget {
  final WalletDetailParams walletDetailParams;
  const WalletDetailTransaction({Key? key, required this.walletDetailParams})
      : super(key: key);

  @override
  _WalletDetailTransactionState createState() =>
      _WalletDetailTransactionState();
}

class _WalletDetailTransactionState extends State<WalletDetailTransaction> {
  PrivateKey? privateKey;
  var signingInput;
  var signingOutput;
  var signingOutputJson;

  String addressBtc = '';
  String toAddress = "tb1qks8l9haxjszn9r6yf2dm65ed3w6wmz85r379ms";
  String changeAddress = "mvcJcHN3ZhELVVhncfjARUMtfRELwhGXgL";

  void Function()? init() {
    CoreProvider provider = Provider.of<CoreProvider>(context, listen: false);
    privateKey =
        provider.wallet.getKeyForCoin(widget.walletDetailParams.twCoinType);
    addressBtc =
        provider.wallet.getAddressForCoin(widget.walletDetailParams.twCoinType);

    switch (widget.walletDetailParams.twCoinType) {
      case TWCoinType.TWCoinTypeBitcoin:
        bitcoinSigning();

        // signingOutput as Bitcoin.SigningOutput;
        break;
      case TWCoinType.TWCoinTypeEthereum:
        ethereumSigning();

        // signingOutput as Ethereum.SigningOutput;
        break;
      default:
        ethereumSigning();
    }

    setState(() {});
  }

  void bitcoinSigning() {
    signingInput = Bitcoin.SigningInput(
      amount: $fixnum.Int64.parseInt('37000'),
      hashType:
          BitcoinScript.hashTypeForCoin(widget.walletDetailParams.twCoinType),
      toAddress: toAddress,
      changeAddress: changeAddress,
      byteFee: $fixnum.Int64.parseInt('10'),
      coinType: widget.walletDetailParams.twCoinType,
      privateKey: [
        privateKey!.data().toList(),
      ],
      //token/bitcoinnya
      //
      utxo: [
        Bitcoin.UnspentTransaction(
          //amount yg dikembalikan
          amount: $fixnum.Int64.parseInt('20000'),
          outPoint: Bitcoin.OutPoint(
            // hash is latest utxo for sender, "txid" field from blockbook utxo api: https://github.com/trezor/blockbook/blob/master/docs/api.md#get-utxo
            hash: hex
                .decode(
                    '1b23757cdc023b3ac9f033522abb9f845815b65cce1e25411e8ad950899c0e71')
                .reversed
                .toList(),
            index: 0,
            sequence: 4294967295,
          ),
          script: BitcoinScript.lockScriptForAddress(
                  addressBtc, widget.walletDetailParams.twCoinType)
              .data()
              .toList(),
        ),
        // Bitcoin.UnspentTransaction(
        //   amount: $fixnum.Int64.parseInt('1000'),
        //   outPoint: Bitcoin.OutPoint(
        //     hash: hex
        //         .decode(
        //             '7611002ff116fad20ef12ad30010a07d5b25edf37209504dd42a6a4c5c27aa75')
        //         .reversed
        //         .toList(),
        //     index: 0,
        //     sequence: 4294967295,
        //   ),
        //   script: BitcoinScript.lockScriptForAddress(
        //           addressBtc, widget.walletDetailParams.twCoinType)
        //       .data()
        //       .toList(),
        // ),
      ],
    );
    signingOutput = AnySigner.sign(
        (signingInput as Bitcoin.SigningInput).writeToBuffer(),
        widget.walletDetailParams.twCoinType);
    signingOutputJson =
        Bitcoin.SigningOutput.fromBuffer(signingOutput).writeToJson();
    print((signingOutput));
    setState(() {});
  }

  void ethereumSigning() {
    signingInput = Ethereum.SigningInput(
      privateKey: privateKey!.data(),
      chainId: hex.decode("01"),
      gasPrice: hex.decode("d693a400"),
      gasLimit: hex.decode("5208"),
      toAddress: "0xC37054b3b48C3317082E7ba872d7753D13da4986",
      transaction: Ethereum.Transaction(
        transfer: Ethereum.Transaction_Transfer(
            amount: hex.decode("0348bca5a16000"), data: []),
      ),
    );
    // signingOutput = AnySigner.sign(
    //     (signingInput as Ethereum.SigningInput).writeToBuffer(),
    //     widget.walletDetailParams.twCoinType);

    signingOutput = AnySigner.sign(
        (signingInput as Ethereum.SigningInput).writeToBuffer(),
        widget.walletDetailParams.twCoinType);
    signingOutputJson =
        Ethereum.SigningOutput.fromBuffer(signingOutput).writeToJson();
    print(Ethereum.SigningOutput.fromBuffer(signingOutput).writeToJson());

    // signingOutput = Ethereum.SigningOutput.fromBuffer(AnySigner.sign(
    //         signingInput.writeToBuffer(), widget.walletDetailParams.twCoinType)
    //     .toList());

    //hasil txtid
    // print(Ethereum.SigningOutput.fromBuffer(signingOutput).encoded);
    // signingOutput = hex.encode(signingOutput);
    // print(signingOutput.writeToJson());
    print(hex.encode(privateKey!.data()));
    print(hex.encode(signingOutput));
    setState(() {});
  }

  @override
  void initState() {
    Future.microtask(() => init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.walletDetailParams.title} Transaction Signing'),
      ),
      body: ListView(
        children: [
          const SelectableText(
            '===Signing Input===',
            textAlign: TextAlign.center,
          ),
          SelectableText(
            signingInput.toString(),
          ),
          SizedBox(
            height: 10,
          ),
          const SelectableText(
            '===Signing Output===',
            textAlign: TextAlign.center,
          ),
          SelectableText(
            signingOutput.toString(),
          ),
          SizedBox(
            height: 10,
          ),
          const SelectableText(
            '===Signing Output JSON===',
            textAlign: TextAlign.center,
          ),
          if (signingOutputJson != null)
            SelectableText(
              signingOutputJson.toString(),
            ),
          // if (signingInput != null)
          //   SelectableText((signingInput).amount.toString())
        ],
      ),
    );
  }
}
