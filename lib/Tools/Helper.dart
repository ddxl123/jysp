enum Compare { frontBig, backBig, equal }

class Helper {
  static Compare compare(int front, int back) {
    if (front > back) {
      return Compare.frontBig;
    } else if (front < back) {
      return Compare.backBig;
    } else {
      return Compare.equal;
    }
  }
}
