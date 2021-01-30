main(List<String> args) {
  a();
}

void a() {
  b();
}

Future b() async {
  print("1");
  await Future.delayed(Duration(seconds: 2)).then((value) async {
    print("2");
    await Future.delayed(Duration(seconds: 2)).then((value) {
      print("3");
    });
    print("4");
  });
  print("5");
}
