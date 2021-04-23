import 'dart:convert';
import 'dart:developer';

int forceLineCount = -1;

// debugPrintStack(label: "adasdads");

///
///
///
/// 使用回调的形式传入，以防异常是 Log 引起。
/// 不能传异步的
///
/// - [messageString] String 类型。 普通日志输出。
/// - [dataListMap] List 或 Map 类型。需要被格式化的日志输出，比如 List、Map 类型的对象。
/// - [lineCount] 需要输出栈的行数量。
Future<void> dLog(
  dynamic Function()? messageString, [
  dynamic Function()? indentListMap,
  Future<dynamic> Function()? futureCallback,
  int lineCount = 1,
]) async {
  try {
    final List<String> st = StackTrace.current.toString().split('\n');

    // 只留下被 #num 标记的行
    st.removeWhere((String item) => item.contains('<asynchronous suspension>'));

    // 最终需要的 lineCount
    int finalLineCount;
    if (forceLineCount == -1) {
      finalLineCount = lineCount;
    } else {
      finalLineCount = forceLineCount;
    }
    if (st.length < finalLineCount) {
      finalLineCount = st.length;
    }

    // 获取将要打印的主内容
    dynamic ind = indentListMap == null ? 'null' : indentListMap();
    if (futureCallback != null) {
      ind = await futureCallback();
    }
    final dynamic indent = (ind is List) || (ind is Map) ? ind : ind.toString();
    final String message = messageString == null ? 'null' : messageString().toString();

    String? packageOne;
    if (finalLineCount == 1) {
      final String currentLineAt = st[1];
      packageOne = ' ' + currentLineAt.substring(currentLineAt.indexOf('(package:'), currentLineAt.length);
    }

    // 打印主内容
    if (indent != 'null') {
      log('> ' + message + (packageOne ?? ''));
      log(const JsonEncoder.withIndent('  ').convert(indent));
    } else {
      // 可能 [indentListMap()] 的返回值是 null ，也可能是 [indentListMap] 为 null
      log('> ' + message + (packageOne ?? ''));
      log(ind == 'null' ? '' : 'null');
    }

    // 打印调用 dLog() 函数的 package，加个空格才能让其靠在最右边
    if (finalLineCount != 1) {
      for (int i = 0; i < finalLineCount; i++) {
        final String currentLineAt = st[i + 1];
        String packages;
        packages = ' ' + currentLineAt.substring(currentLineAt.indexOf('(package:'), currentLineAt.length);
        log(' ·' + i.toString() + packages);
      }
    }
  } catch (err) {
    if (err is RangeError) {
    } else {
      log('log err:' + err.toString());
    }
  }
}
