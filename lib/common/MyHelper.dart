import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class MyHelper {
  //--- Convert ---

  static String replaceBaseUrl(String url) {
    var parse = url.replaceAll("[base_url]", ApiService.baseUrl);
    return parse;
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static String formatRupiah(int price) {
    if (price == 0) {
      return "Tidak ada data";
    }

    final oCcy = new NumberFormat("#,##0", "en_US");

    final f = oCcy.format(price);

    return "Rp. " + f.toString();
  }

  static int returnToInt(var input) {
    int result = 0;

    if (input is int) {
      result = input;
    } else if (input is double) {
      result = (.5 * input).round();
    } else if (input is String) {
      result = 0;
    } else if (input == null) {
      result = 0;
    } else {
      result = 0;
    }

    return result;
  }

  static double returnToDouble(var input) {
    double result = 0;

    if (input is int) {
      result = input.toDouble();
    } else if (input is double) {
      result = input;
    } else if (input is String) {
      result = 0;
    } else if (input == null) {
      result = 0;
    } else {
      result = 0;
    }

    return result;
  }

  static String returnToString(var input) {
    String result = "";

    if (input is int) {
      result = input.toString();
    } else if (input is double) {
      result = input.toString();
    } else if (input is String) {
      result = input.toString();
    } else if (input == null) {
      result = "-";
    } else {
      result = "-";
    }

    return result;
  }

  static String formatDate(String date) {
    final f = DateFormat("dd MMM yyyy (hh:mm:ss)").format(DateTime.parse(date));
    return f.toString();
  }

  static String formatShortDate(String date) {
    // print('tanggal: $date');
    if (date == '' || date == '-') {
      return '-';
    }
    final f = DateFormat("dd MMM yyyy").format(DateTime.parse(date));
    return f.toString();
  }

  static toast(BuildContext context, String message,
      {int gravity = Toast.bottom}) {
    ToastContext().init(context);
    gravity == 1
        ? Toast.show(message, duration: Toast.lengthShort, gravity: Toast.top)
        : gravity == 2
            ? Toast.show(message,
                duration: Toast.lengthShort, gravity: Toast.center)
            : Toast.show(message,
                duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  static String encodeURL(String slug) {
    String url = '';
    url = slug.replaceAll('/', '*').replaceAll('-', '~').replaceAll(' ', '-');
    return 'https://pontianak.go.id/pontianak-hari-ini/berita/' + url;
  }
}
