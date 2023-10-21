import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:pegasus_tool/models/ecosystem_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/repository/saturation_repository.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:timeago/timeago.dart' as timeago;

final _display = createDisplay(length: 111, decimal: 0);

final _display2Decimal = createDisplay(length: 111, decimal: 2);

String format(value) {
  if (value == null || value == "") {
    return "";
  }
  dynamic numValue;
  if (value is String) {
    numValue = int.parse(value);
  } else {
    numValue = value;
  }
  if (numValue < 1000) {
    return _display2Decimal(numValue);
  } else {
    return _display(numValue);
  }
}

String getEnvironment() {
  return "Mainnet";
}

IconData getIcon(pool, tear) {
  switch (tear) {
    case 3:
      return Icons.cancel;
    case 2:
      return Icons.warning;
    default:
      return Icons.check_circle;
  }
}

Color getColorForTear(tear) {
  switch (tear) {
    case 3:
      return Styles.DANGER_COLOR;
    case 2:
      return Styles.WARNING_COLOR;
    default:
      return Styles.SUCCESS_COLOR2;
  }
}

int feeTear(StakePool pool) {
  if (pool.fm! >= 12) {
    return 3;
  } else if (pool.fm! >= 8) {
    return 2;
  } else {
    return 1;
  }
}

int performanceTear(pool) {
  var performance = 1.0; //pool['performance']
  if (performance < 0.7) {
    return 3;
  } else if (performance < 0.8) {
    return 2;
  } else {
    return 1;
  }
}

bool isSaturated(dynamic pool) {
  return pool['s'] >= 1.0;
}

int stakeTear(StakePool pool) {
  num saturationLevel = GetIt.I<SaturationRepository>().saturationLevel;

  if (pool.ls == null) {
    return 1;
  }
  if (pool.ls! > saturationLevel) {
    return 3;
  } else if (pool.ls! > saturationLevel * 0.9) {
    return 2;
  } else {
    return 1;
  }
}

int stakeTearForStake(num? stake) {
  num saturationLevel = GetIt.I<SaturationRepository>().saturationLevel;

  if (stake == null) {
    return 1;
  }
  if (stake > saturationLevel) {
    return 3;
  } else if (stake > saturationLevel * 0.9) {
    return 2;
  } else {
    return 1;
  }
}

double poolSaturation(num liveStake) {
  return liveStake / GetIt.I<SaturationRepository>().saturationLevel.toDouble();
}

String formattedPerformance(dynamic pool) {
  var performance = 1.0; //pool['performance']
  return "${(performance * 100).toStringAsFixed(0)}%";
}

String formattedSaturation(dynamic pool) {
  return (pool['s'] * 100).toStringAsFixed(0) + "%";
}

String formattedRelativeStake(StakePool pool) {
  return "${(pool.s)!.toStringAsFixed(2)}%";
}

String formattedVariableFee(StakePool pool) {
  return "${(pool.fm)!.toStringAsFixed(2)}%";
}

String lifetimeROS(StakePool pool) {
  if (pool.lros == null) {
    return "0%";
  }
  return "${(pool.lros! * 100).toStringAsFixed(2)}%";
}

num? getAssignedBlocks(StakePool poolSummary, num? poolActiveStake,
    Ecosystem ecosystem, num currentEpoch) {
  if (poolActiveStake == null) {
    return null;
  }
  var totalActiveStake = ecosystem.totalStaked!;
  var decentralizationParam = ecosystem.decentralizationLevel! / 100.0;
  if (poolSummary.z != null && poolSummary.ez == currentEpoch) {
    return poolSummary.z!;
  } else {
    return poolActiveStake.toDouble() /
        totalActiveStake *
        21600 *
        decentralizationParam;
  }
}

String getAssignedBlocksFormatted(StakePool poolSummary, num? poolActiveStake,
    Ecosystem ecosystem, num currentEpoch) {
  if (poolSummary.z != null && poolSummary.ez! == currentEpoch) {
    return poolSummary.z.toString();
  } else if (poolActiveStake != null) {
    num? assignedBlocks = getAssignedBlocks(
        poolSummary, poolActiveStake, ecosystem, currentEpoch);
    if (assignedBlocks != null) {
      return assignedBlocks.toStringAsFixed(1);
    }
  }
  return "???";
}

String getExpectedBlocksFormatted(StakePool poolSummary, num? poolActiveStake,
    Ecosystem ecosystem, num currentEpoch) {
  if (poolActiveStake == null) {
    return "???";
  }
  var totalActiveStake = ecosystem.totalStaked!;
  var decentralizationParam = ecosystem.decentralizationLevel! / 100.0;
  var expectedBlocks =
      21600 * decentralizationParam * poolActiveStake / totalActiveStake;
  return expectedBlocks.toStringAsFixed(0);
}

num getEpochBlocs(StakePool poolSummary, num currentEpoch) {
  if (currentEpoch == poolSummary.eb && poolSummary.b != null) {
    return poolSummary.b!;
  } else {
    return 0;
  }
}

void showErrorToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Styles.DANGER_COLOR,
      textColor: Styles.ICON_INSIDE_COLOR,
      fontSize: 16.0);
}

void showSuccessToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Styles.SUCCESS_TOST_BACKGROUND,
      textColor: Styles.ICON_INSIDE_COLOR,
      fontSize: 16.0);
}

String formatToMillionsOfAda(num? lovelaces) {
  if (lovelaces == null) {
    return "₳0";
  }
  return NumberFormat.compactCurrency(
    decimalDigits: 1,
    symbol: '₳',
  ).format(lovelaces / 1000000);
}

String truncateId(String id) {
  return id.substring(0, 4);
}

String formatLovelaces(num? lovelaces) {
  if (lovelaces == null) {
    return "0";
  }
  var ada = lovelaces / 1000000;
  if (lovelaces == 0) {
    return "0";
  } else if (ada < 10) {
    return ada.toStringAsFixed(2).toString();
  } else if (ada < 10000) {
    return format(ada);
  } else if (ada < 1000000) {
    return "${format(ada / 1000)}K";
  } else if (ada < 1000000000) {
    return "${format(ada / 1000000)}M";
  } else {
    return "${format(ada / 1000000000)}B";
  }
}

String timestampToTime(num timestamp) {
  var format = DateFormat('HH:mm:ss');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp as int);
  return format.format(date);
}

String timestampToDateTime(num timestamp) {
  var format = DateFormat('HH:mm:ss dd/MM/yy');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
  return format.format(date);
}

String formatTimestampAgo(num? timestamp) {
  if (timestamp == null) {
    return "";
  }
  var elapsed = DateTime.now().millisecondsSinceEpoch - timestamp;
  final num seconds = elapsed / 1000;
  final num minutes = seconds / 60;
  final num hours = minutes / 60;
  final num days = hours / 24;
  final num months = days / 30;
  final num years = days / 365;

  String result;
  if (seconds < 60) {
    result = "${seconds.round()}s ago";
  } else if (minutes < 59) {
    result = "${minutes.round()}m ago";
  } else if (hours < 23) {
    result = "${hours.round()}h ago";
  } else if (days < 30) {
    result = "${days.round()}d ago";
  } else if (days < 365) {
    result = "${months.round()}month ago";
  } else {
    result = "${years.round()}year ago";
  }

  return result;
}

bool isLandscape(context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

String Function(num?)? measureFormatter =
    (value) => NumberFormat.compactCurrency(
          decimalDigits: 0,
          symbol:
              '₳', // if you want to add currency symbol then pass that in this else leave it empty.
        ).format(value);

void showInfoDialog(BuildContext context, String title, String text) {
  showInfoDialogWithCallback(context, title, text, null);
}

void showInfoDialogWithCallback(
    BuildContext context, String title, String text, Function? onDismiss) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            content: Text(text),
            backgroundColor: Theme.of(context).cardColor,
            actions: <Widget>[
              TextButton(
                child: Text('Got it!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onDismiss != null) {
                    onDismiss();
                  }
                },
              )
            ],
          ));
}

String timeUntil(DateTime date) {
  return timeago
      .format(date, locale: 'en', allowFromNow: true)
      .replaceAll(" from now", "");
}

String getPoolName(String poolId, StakePool? poolSummary) {
  if (poolSummary == null) {
    return poolId;
  } else {
    var name = "";
    if (poolSummary.t == null || poolSummary.t == "") {
      name += poolSummary.id!;
    } else {
      name += "[${poolSummary.t}] ${poolSummary.n}";
    }
    return name;
  }
}
