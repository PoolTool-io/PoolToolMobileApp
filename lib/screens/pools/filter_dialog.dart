import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/theme_data.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog(
      {Key? key,
      this.hideSaturated,
      this.hideExpensive,
      this.hideUnknown,
      this.hideBlockless,
      this.hideNotFromItn,
      this.hideDisconnected,
      this.hidePoolGroups,
      required this.onFilterChanged,
      this.hideRetiring,
      this.hideRetired})
      : super(key: key);

  final void Function(
      bool? hideUnknown,
      bool? hideExpensive,
      bool? hideSaturated,
      bool? hideBlockless,
      bool? hideNotFromItn,
      bool? hideDisconnected,
      bool? hidePoolGroups,
      bool? hideRetiring,
      bool? hideRetired) onFilterChanged;

  final bool? hideSaturated;
  final bool? hideExpensive;
  final bool? hideBlockless;
  final bool? hideNotFromItn;
  final bool? hideDisconnected;
  final bool? hideUnknown;
  final bool? hidePoolGroups;
  final bool? hideRetiring;
  final bool? hideRetired;

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  bool? hideSaturated;
  bool? hideExpensive;
  bool? hideUnknown;
  bool? hideBlockless;
  bool? hideNotFromItn;
  bool? hideDisconnected;
  bool? hidePoolGroups;
  bool? hideNotChatReady;
  bool? hideRetiring;
  bool? hideRetired;

  @override
  void initState() {
    hideSaturated = widget.hideSaturated;
    hideExpensive = widget.hideExpensive;
    hideUnknown = widget.hideUnknown;
    hideBlockless = widget.hideBlockless;
    hideNotFromItn = widget.hideNotFromItn;
    hideDisconnected = widget.hideDisconnected;
    hidePoolGroups = widget.hidePoolGroups;
    hideRetiring = widget.hideRetiring;
    hideRetired = widget.hideRetired;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, top: 16.0, right: 0.0, bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.filter_list,
                          size: 24.0,
                          semanticLabel: 'Filter',
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Filter',
                          style: TextStyle(
                              fontSize: 21.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      ]),
                  const SizedBox(height: 10),
                  checkBoxListTile(
                    title: "Pool clusters",
                    subtitle: "Promote decentralisation and hide pool clusters",
                    value: hidePoolGroups,
                    onChanged: (newValue) {
                      setState(() {
                        hidePoolGroups = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "Disconnected",
                    subtitle: "Hide pools without online relays",
                    value: hideDisconnected,
                    onChanged: (newValue) {
                      setState(() {
                        hideDisconnected = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "High fees",
                    subtitle: "Hide pools with over 8% variable fee",
                    value: hideExpensive,
                    onChanged: (newValue) {
                      setState(() {
                        hideExpensive = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "Saturated",
                    subtitle: "Hide saturated pools",
                    value: hideSaturated,
                    onChanged: (newValue) {
                      setState(() {
                        hideSaturated = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "Blockless",
                    subtitle: "Hide pools that have not created a block yet",
                    value: hideBlockless,
                    onChanged: (newValue) {
                      setState(() {
                        hideBlockless = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "Not from ITN",
                    subtitle: "Hide pools that are not ITN verified",
                    value: hideNotFromItn,
                    onChanged: (newValue) {
                      setState(() {
                        hideNotFromItn = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "Retiring",
                    subtitle: "Hide pools that are scheduled to retire",
                    value: hideRetiring,
                    onChanged: (newValue) {
                      setState(() {
                        hideRetiring = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "Retired",
                    subtitle: "Hide pools that are already retired",
                    value: hideRetired,
                    onChanged: (newValue) {
                      setState(() {
                        hideRetired = newValue;
                      });
                    },
                  ),
                  checkBoxListTile(
                    title: "Unknown",
                    subtitle: "Hide pools with unknown ticker",
                    value: hideUnknown,
                    onChanged: (newValue) {
                      setState(() {
                        hideUnknown = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ButtonTheme(
                      minWidth: 200,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                  color: Styles.ICON_INSIDE_COLOR)),
                          onPressed: () {
                            widget.onFilterChanged(
                                hideUnknown,
                                hideExpensive,
                                hideSaturated,
                                hideBlockless,
                                hideNotFromItn,
                                hideDisconnected,
                                hidePoolGroups,
                                hideRetiring,
                                hideRetired);
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'))),
                ],
              ))),
    );
  }

  Widget checkBoxListTile(
      {required void Function(bool?)? onChanged,
      String? title,
      String? subtitle,
      required value}) {
    return CheckboxListTile(
        title: Text(title ?? "",
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle ?? "",
          style:
              TextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
        ),
        activeColor: Theme.of(context).colorScheme.secondary,
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading);
  }
}
