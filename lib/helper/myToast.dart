

import 'package:fluttertoast/fluttertoast.dart';

Future<bool> toast(message){ 
  return Fluttertoast.showToast(msg: message);
}