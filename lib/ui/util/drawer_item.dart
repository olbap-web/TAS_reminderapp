import 'package:flutter/material.dart';

class DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback action;

  DrawerItem({required this.icon, required this.title, required this.action});
}
