import 'dart:convert';
import 'dart:developer';

void dPrint(String message) {
  print(message + " " + StackTrace.current.toString().split("\n")[1].split("(")[1]);
}

void dLog(String message, [List list]) {
  if (list != null) {
    log(JsonEncoder.withIndent("  ").convert(list));
  } else {
    log(message + " " + StackTrace.current.toString().split("\n")[1].split("(")[1]);
  }
}
