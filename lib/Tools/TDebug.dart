import 'dart:developer';

void dPrint(String message) {
  print(message + " " + StackTrace.current.toString().split("\n")[1].split("(")[1]);
}

void dLog(String message) {
  log(message + " " + StackTrace.current.toString().split("\n")[1].split("(")[1]);
}
