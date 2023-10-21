import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/theme_data.dart';

class LabelValueWidget extends StatefulWidget {
  final String label;
  final String? value;
  final Icon? valueIcon;
  final Color? valueColor;
  final TextAlign? textAlign;
  final double? valueFontSize;
  final double? labelFontSize;
  final FontWeight? valueFontWeight;
  final void Function()? onTapFunc;

  const LabelValueWidget(
      {super.key,
      required this.label,
      this.value,
      this.valueIcon,
      this.valueColor,
      this.textAlign,
      this.onTapFunc,
      this.valueFontSize,
      this.valueFontWeight,
      this.labelFontSize});

  @override
  State<StatefulWidget> createState() {
    return LabelValueWidgetState();
  }
}

class LabelValueWidgetState extends State<LabelValueWidget> {
  @override
  Widget build(BuildContext context) {
    Color labelColor;
    if (widget.onTapFunc != null) {
      labelColor = Theme.of(context).colorScheme.secondary;
    } else {
      labelColor = Styles.INACTIVE_COLOR;
    }

    Color? valueColor;
    if (widget.valueColor == null) {
      valueColor = Theme.of(context).textTheme.bodyLarge!.color;
    } else {
      valueColor = widget.valueColor;
    }
    return InkWell(
        onTap: widget.onTapFunc,
        child: Column(
            crossAxisAlignment: widget.textAlign == TextAlign.right
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              widget.valueIcon == null
                  ? Text(widget.value!,
                      textAlign: widget.textAlign ?? TextAlign.left,
                      style: TextStyle(
                          fontSize: widget.valueFontSize ?? 16.0,
                          color: valueColor,
                          fontWeight:
                              widget.valueFontWeight ?? FontWeight.normal))
                  : widget.valueIcon!,
              Text(widget.label,
                  textAlign: widget.textAlign ?? TextAlign.left,
                  style: TextStyle(
                      fontSize: widget.labelFontSize ?? 14.0,
                      color: labelColor)),
              const SizedBox(height: 8),
            ]));
  }
}
