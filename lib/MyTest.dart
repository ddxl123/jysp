main(List<String> args) {
  a();
}

void a() {
  print("111");
  b();
  print("222");
}

Future b() async {
  print("333");
  await Future.delayed(Duration(seconds: 2));
}
