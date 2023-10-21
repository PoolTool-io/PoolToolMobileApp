import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget? target;
  final Function? action;
  final Widget? trailing;

  const DrawerItem(
      {Key? key,
      required this.label,
      required this.icon,
      this.target,
      this.action,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
          child: ListTile(
            leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
            title: Text(label),
            trailing: trailing,
          )),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => {
                        if (action != null)
                          {action!()}
                        else if (target != null)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => target!))
                          }
                      })))
    ]);
  }
}
