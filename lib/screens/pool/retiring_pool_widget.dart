import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/theme_data.dart';

class RetiringPoolWidget extends StatelessWidget {
  final num? retiredEpoch;

  const RetiringPoolWidget({Key? key, this.retiredEpoch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
              child: Row(children: const [
                Icon(
                  Icons.warning,
                  color: Styles.DANGER_COLOR,
                  size: 24.0,
                ),
                SizedBox(width: 8),
                Text("Retiring Pool", style: TextStyle(fontSize: 18.0))
              ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
              child: Text(
                "This pool is retiring in epoch $retiredEpoch!\nDelegate to another pool to avoid missing out on rewards!",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color),
              ))
        ]));
  }
}
