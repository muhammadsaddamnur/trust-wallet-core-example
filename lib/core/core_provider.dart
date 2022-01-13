import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';

class CoreProvider extends ChangeNotifier {
  HDWallet? _wallet;

  HDWallet get wallet => _wallet!;

  void initWallet() {
    if (_wallet != null) _wallet!.delete();
    _wallet = HDWallet();
    notifyListeners();
  }

  void importWallet(String mnemonic) {
    _wallet = HDWallet.createWithMnemonic(mnemonic);
    notifyListeners();
  }
}
