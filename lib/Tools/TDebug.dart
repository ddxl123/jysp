import 'dart:convert';
import 'dart:developer';

void dPrint(String message) {
  print(message + " " + StackTrace.current.toString().split("\n")[1].split("(")[1]);
}

void dLog(String message, [dynamic data]) {
  if (data != null) {
    log(JsonEncoder.withIndent("  ").convert(data));
  } else {
    log(message + " " + StackTrace.current.toString().split("\n")[1].split("(")[1]);
  }
}
