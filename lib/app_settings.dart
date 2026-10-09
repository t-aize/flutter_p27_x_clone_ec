import 'package:flutter/material.dart';

class AppSettings extends InheritedWidget {
  const AppSettings({
    super.key,
    required this.backgroundColor,
    required this.changeBackgroundColor,
    required super.child,
  });

  final Color backgroundColor;
  final Future<void> Function(Color) changeBackgroundColor;

  static AppSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppSettings>()!;

  @override
  bool updateShouldNotify(AppSettings oldWidget) =>
      backgroundColor != oldWidget.backgroundColor;
}
