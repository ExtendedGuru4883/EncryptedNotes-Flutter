import 'package:encrypted_notes/src/shared/clients/http/providers/dio_provider.dart';
import 'package:encrypted_notes/src/shared/clients/http/services/http_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_service_provider.g.dart';

@Riverpod(keepAlive: true)
HttpService httpService(Ref ref) {
  final dio = ref.read(dioProvider);

  return HttpService(dio);
}
