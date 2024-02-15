import 'dart:convert';

import "package:http/http.dart" as http;

enum NameType {
  firstName('firstname'),
  surname('surname'),
  fullName('fullname');

  const NameType(this.value);

  final String value;
}

final service = RandomNameService();

Future<String> getSomeName(NameType type) async {
  final List<String> name;
  try {
    name = await service.loadNames(
      amount: 1,
      nameType: type,
    );
  } on HttpException catch (e) {
    throw Exception(e.toString());
  }
  return name[0];
}

sealed class HttpException implements Exception {
  @override
  String toString() => switch (this) {
        // норм
        RequestFailed() => 'Ошибка запроса. Проверьте параметры запроса!!',
        Forbidden() =>
          // Нет доступа
          'Пользователь ограничен в доступе к указанному ресурсу!!',
        // Не найдено
        NotFound() => 'Ошибка в написании адреса Web-страницы!!',
        UnknownException() => 'Неизвестная ошибка!' //неизвестная ошибка
      };
}

final class RequestFailed extends HttpException {} // 400 - ошибка запроса

final class Forbidden extends HttpException {} // 403 – доступ запрещен

final class NotFound extends HttpException {} //404 – не найдено

final class UnknownException extends HttpException {} // != 200

abstract interface class IRandomNameService {
  Future<String> loadName({required NameType nameType});

  Future<List<String>> loadNames({
    required int amount,
    required NameType nameType,
  });
}

final class RandomNameService implements IRandomNameService {
  static const _apiKey = 'f8f010f6e888495dbce7cc9c02c6cd65';

  @override
  Future<String> loadName({required NameType nameType}) async =>
      (await loadNames(amount: 1, nameType: nameType))[0];

  @override
  Future<List<String>> loadNames({
    required int amount,
    required NameType nameType,
  }) async {
    final response = await http.get(
        Uri.https('randommer.io', '/api/Name', {
          'nameType': nameType.value,
          'quantity': amount.toString(),
        }),
        headers: {
          'x-api-key': _apiKey,
        });
    _handleError(response.statusCode);
    List<dynamic> decoded = jsonDecode(response.body);
    List<String> res = decoded.map((e) => e as String).toList();
    return res;
  }

  void _handleError(int statusCode) {
    if (statusCode == 400) {
      throw RequestFailed();
    } else if (statusCode == 403) {
      throw Forbidden();
    } else if (statusCode == 404) {
      throw NotFound();
    } else if (statusCode != 200) {
      throw UnknownException();
    }
  }
}
