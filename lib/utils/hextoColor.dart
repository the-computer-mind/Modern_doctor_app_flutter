import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  // Remove the '#' symbol if it exists
  hex = hex.replaceAll('#', '');

  // If the length of the hex is 6, assume it's RGB (e.g. 'FF5733')
  // If the length is 8, assume it's ARGB (e.g. 'AARRGGBB')
  if (hex.length == 6) {
    hex = 'FF' + hex; // Add full opacity for RGB colors
  }

  // Parse the hex string to an integer
  int colorInt = int.parse(hex, radix: 16);

  // Return the color with the parsed value
  return Color(colorInt);
}
