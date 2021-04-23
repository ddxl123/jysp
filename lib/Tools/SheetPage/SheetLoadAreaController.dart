enum SheetLoadAreaStatus { loading, noMore, fail }

extension SheetLoadAreaStatusExtension on SheetLoadAreaStatus {
  String get text {
    switch (index) {
      case 0:
        return 'loading';
      case 1:
        return 'noMore';
      case 2:
        return 'fail';
      default:
        throw 'SheetLoadAreaStatusExtension err';
    }
  }
}

class SheetLoadAreaController {
  SheetLoadAreaStatus sheetLoadAreaStatus = SheetLoadAreaStatus.noMore;
}
