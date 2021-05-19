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

void main(List<String> args) {
  print(a<B>().runtimeType);
}

T a<T extends A>() {
  return B() as T;
}

abstract class A {
  int get i;
}

class B implements A {
  @override
  int get i => 1111;
}
