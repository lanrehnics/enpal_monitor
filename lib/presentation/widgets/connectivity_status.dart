import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';


class ConnectivityStatus extends StatelessWidget {
  final Stream<List<ConnectivityResult>>? connectivityStream;

  const ConnectivityStatus({super.key, this.connectivityStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: connectivityStream ?? Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final mc = MediaQuery.of(context);
        if (snapshot.hasData && (snapshot.data ?? []).contains(ConnectivityResult.none)) {
          return Container(
            color: Colors.red,
            padding: EdgeInsets.only(bottom: 6, top: mc.padding.top + 6),
            child: const Row(
              children: <Widget>[
                Spacer(),
                Text('Unable to Connect', style: TextStyle(color: Colors.white)),
                Spacer(),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

