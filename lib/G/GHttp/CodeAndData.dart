import 'package:dio/dio.dart';
import 'package:jysp/G/GHttp/RequestInterruptedType.dart';
import 'package:jysp/Tools/TDebug.dart';

class CodeAndData<T> {
  CodeAndData(Response<Map<String, dynamic>> response) {
    try {
      if (response.data == null) {
        throw 'response.data is not map';
      }

      final dynamic rCode = response.data!['code'];
      dynamic rData = response.data!['data'];
      final dynamic rErr = response.data!['err'];

      if (rErr != null) {
        throw 'server err: code - $rCode, server_err - ${rErr.toString()}';
      }

      if (rCode is! int) {
        throw 'rCode is not int type: ${rCode.runtimeType}';
      }

      if (T.toString() == 'List<Map<String, dynamic>>') {
        try {
          rData ??= <dynamic>[];
          rData = List<Map<String, dynamic>>.from(rData as List<dynamic>);
        } catch (e) {
          throw 'Type of T is -List<Map<String, dynamic>>-, but type of rData is -${rData.runtimeType}-';
        }
      }
      //
      else if (T.toString() == 'Map<String, dynamic>') {
        try {
          rData ??= <dynamic, dynamic>{};
          rData = Map<String, dynamic>.from(rData as Map<dynamic, dynamic>);
        } catch (e) {
          throw 'Type of T is -Map<String, dynamic>-, but type of rData is -${rData.runtimeType}-';
        }
      }
      //
      else if (T.toString() == 'Map<String, String>') {
        try {
          rData ??= <dynamic, dynamic>{};
          rData = Map<String, String>.from(rData as Map<dynamic, dynamic>);
        } catch (e) {
          throw 'Type of T is -Map<String, String>?-, but type of rData is -${rData.runtimeType}-';
        }
      }
      //
      else if (T.toString() == 'Null' || T.toString() == 'void') {
        if (!(rData == null)) {
          throw 'Type of T is -Null-, but type of rData is -${rData.runtimeType}-';
        }
      }
      //
      else {
        throw 'Type of -$T- unset, type of rData is -${rData.runtimeType}-';
      }

      resultCode = rCode;
      resultData = rData as T;
    } catch (e) {
      dLog(() => e);
      throw RequestInterruptedType.codeAndDataError;
    }
  }
  late int resultCode;
  late T resultData;
}
