main(List<String> args) {
  a();
}

void a() {
  print(DateTime.now().microsecondsSinceEpoch);
  print(DateTime.now().millisecondsSinceEpoch);
}
