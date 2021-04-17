import 'package:dio/dio.dart';
import 'package:jysp/G/GHttp/RequestInterruptedType.dart';
import 'package:jysp/Tools/TDebug.dart';

class CodeAndData<T> {
  late int resultCode;
  late T resultData;

  CodeAndData(Response response) {
    try {
      if (!(response.data is Map)) {
        dLog(() => "response.data is not map");
        throw RequestInterruptedType.codeAndDataNotMap;
      }

      dynamic rCode = response.data["code"];
      dynamic rData = response.data["data"];
      dynamic rErr = response.data["err"];

      if (rErr != null) {
        dLog(() => "服务器异常: ", () => "code: $rCode, server_err: ${rErr.toString()}");
        throw RequestInterruptedType.codeAndDataServerErr;
      }

      if (!(rCode is int)) {
        throw RequestInterruptedType.codeAndDataCodeNotInt;
      }

      if (T.toString() == "List<Map<String, dynamic>>") {
        if (!(rData is List)) {
          throw RequestInterruptedType.codeAndDataDataNotT;
        }
        try {
          rData = List<Map<String, dynamic>>.from(rData);
        } catch (e) {
          // rData 元素存在非 Map 类型元素
          throw RequestInterruptedType.codeAndDataDataNotT;
        }
      } else if (T.toString() == "Map<String, dynamic>" && !(rData is Map<String, dynamic>)) {
        throw RequestInterruptedType.codeAndDataDataNotT;
      } else if (T.toString() == "Null" && !(rData == null)) {
        throw RequestInterruptedType.codeAndDataDataNotT;
      }

      this.resultCode = rCode;
      this.resultData = rData;
    } catch (e) {
      dLog(() => e);
      throw RequestInterruptedType.codeAndDataUnknownError;
    }
  }
}
