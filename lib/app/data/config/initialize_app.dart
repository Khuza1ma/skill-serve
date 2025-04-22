import '../remote/api_service/init_api_service.dart';
import 'package:get_storage/get_storage.dart';
import '../local/user_provider.dart';
import 'logger.dart';

/// Initialize all core functionalities
Future<void> initializeCoreApp() async {
  initLogger();
  await GetStorage.init();
  UserProvider.loadUser();
  APIService.initialize();
}
