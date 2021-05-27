import 'package:flutter/material.dart';


// InputDecoration mainInputs(label, {String Function() validator}) {
//   return InputDecoration(labelText: label, border: OutlineInputBorder());
// }
InputDecoration mainInputs(label, {String Function() validator, String errorText}) {
  return InputDecoration(labelText: label, border: OutlineInputBorder());
}
