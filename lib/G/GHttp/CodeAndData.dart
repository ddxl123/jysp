import 'package:dio/dio.dart';
import 'package:jysp/G/GHttp/RequestInterruptedType.dart';
import 'package:jysp/Tools/TDebug.dart';

class CodeAndData<T> {
  CodeAndData(Response<Map<String, dynamic>> response) {
    try {
      if (response.data == null) {
        dLog(() => 'response.data is not map');
        throw RequestInterruptedType.codeAndDataNotMap;
      }

      final dynamic rCode = response.data!['code'];
      dynamic rData = response.data!['data'];
      final dynamic rErr = response.data!['err'];

      if (rErr != null) {
        dLog(() => '服务器异常: ', () => 'code: $rCode, server_err: ${rErr.toString()}');
        throw RequestInterruptedType.codeAndDataServerErr;
      }

      if (rCode is! int) {
        throw RequestInterruptedType.codeAndDataCodeNotInt;
      }

      if (T.toString() == 'List<Map<String, dynamic>>') {
        if (rData is! List) {
          throw RequestInterruptedType.codeAndDataDataNotT;
        }
        try {
          rData = List<Map<String, dynamic>>.from(rData);
        } catch (e) {
          // rData 元素存在非 Map 类型元素
          throw RequestInterruptedType.codeAndDataDataNotT;
        }
      } else if (T.toString() == 'Map<String, dynamic>' && rData is! Map<String, dynamic>) {
        throw RequestInterruptedType.codeAndDataDataNotT;
      } else if (T.toString() == 'Null' && !(rData == null)) {
        throw RequestInterruptedType.codeAndDataDataNotT;
      }

      resultCode = rCode;
      resultData = rData as T;
    } catch (e) {
      dLog(() => e);
      throw RequestInterruptedType.codeAndDataUnknownError;
    }
  }
  late int resultCode;
  late T resultData;
}
