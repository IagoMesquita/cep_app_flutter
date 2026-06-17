import 'dart:developer';

import 'package:cep_app/shared/data/local/errors/local_exception.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesService implements LocalService {
  @override
  Future<T?> get<T>(String key) async {
    try {
      final instance = await SharedPreferences.getInstance();
      if (T == String) {
        return instance.getString(key) as T?;
      } else if (T == bool) {
        return instance.getBool(key) as T?;
      }
      return null;
    } catch (error, st) {
      log('Error loading local String or bool', error: error, stackTrace: st);

      throw const LocalException(
        message: 'Error loading cache. Please, try again',
      );
    }
  }

  @override
  Future <void> set<T>(String key, T data) async {
    try {
      final instance = await SharedPreferences.getInstance();

      if (T == String) {
        await instance.setString(key, data as String);
      } else if (T == bool) {
        await instance.setBool(key, data as bool);
      }
    } catch (error, st) {
      log('Error setting local string or bool', error: error, stackTrace: st);

      throw const LocalException(
        message: 'Error setting cache. Please, try again later',
      );
    }
  }
}
