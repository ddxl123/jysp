main(List<String> args) {
  a();
}

void a() {
  List list = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List list2 = [];
  list.removeWhere(
    (item) {
      list2.add(item);
      return true;
    },
  );
  print(list.toString());
  print(list2.toString());
}
