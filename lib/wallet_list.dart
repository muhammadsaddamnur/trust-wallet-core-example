import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_explore/wallet_detail.dart';

class WalletList extends StatefulWidget {
  const WalletList({Key? key}) : super(key: key);

  @override
  _WalletListState createState() => _WalletListState();
}

class _WalletListState extends State<WalletList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('B'),
              ),
              title: const Text('Bitcoin'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletDetail(
                      walletDetailParams: WalletDetailParams(
                        title: 'Bitcoin',
                        twCoinType: TWCoinType.TWCoinTypeBitcoin,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('E'),
              ),
              title: const Text('Ethereum'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletDetail(
                      walletDetailParams: WalletDetailParams(
                        title: 'Ethereum',
                        twCoinType: TWCoinType.TWCoinTypeEthereum,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('S'),
              ),
              title: const Text('Solana'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletDetail(
                      walletDetailParams: WalletDetailParams(
                        title: 'Solana',
                        twCoinType: TWCoinType.TWCoinTypeSolana,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('D'),
              ),
              title: const Text('Doge'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletDetail(
                      walletDetailParams: WalletDetailParams(
                        title: 'Doge',
                        twCoinType: TWCoinType.TWCoinTypeDogecoin,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
