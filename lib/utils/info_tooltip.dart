import 'package:flutter/material.dart';

Row showTextWithTooltip(String text, String toolTipText) {
  return Row(
    children: [Text(text), showInfoToolTip(toolTipText)],
  );
}

Tooltip showInfoToolTip(String message) {
  return Tooltip(
    message: message,
    triggerMode: TooltipTriggerMode.tap,
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    child: const Icon(
      Icons.info_outline,
      size: 16,
      weight: 0.5,
    ),
  );
}
