import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool get isIOS => Platform.isIOS;

class AppIcons {
  AppIcons._();

  static IconData get cart =>
      isIOS ? CupertinoIcons.bag_fill : Icons.shopping_cart;

  static IconData get notification =>
      isIOS ? CupertinoIcons.bell_fill : Icons.notifications;
  static IconData get filter =>
      isIOS ? CupertinoIcons.slider_horizontal_3 : Icons.tune;
  static IconData get search => isIOS ? CupertinoIcons.search : Icons.search;
  static IconData get scan =>
      isIOS ? CupertinoIcons.qrcode_viewfinder : Icons.qr_code_scanner;

  static IconData get home => Icons.home_rounded;

  static IconData get explore =>
      isIOS ? CupertinoIcons.placemark : Icons.location_on_rounded;

  static IconData get wishlist => Icons.favorite_rounded;

  static IconData get profile => Icons.person_2_rounded;

  static IconData get settings =>
      isIOS ? CupertinoIcons.settings : Icons.settings;

  static IconData get back => isIOS ? CupertinoIcons.back : Icons.arrow_back;
}
