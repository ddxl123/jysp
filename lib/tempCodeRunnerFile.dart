main(List<String> args) {
  a();
}

void a() {
  Map v = {"code": Exception()};

  switch (v["code"]) {
    case 1:
      print("aaa");
      break;
    default:
      print(v["code"].runtimeType());
  }
}
