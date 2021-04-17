///
///
///
///
///
///
///
///
///
///
///

extension objExt on dynamic {
  int a() => 11;
  String b() => "bbb";
}

main(List<String> args) {
  dynamic dyn = "";
  // ignore: unused_local_variable
  var v = dyn.a();
  (dyn.a() as Object).a();
  (dyn.a() as Object).b();
}
