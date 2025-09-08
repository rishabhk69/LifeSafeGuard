import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../router/router.dart';
import 'locator.config.dart';

final locator = GetIt.instance;

@injectableInit
Future<void> setupLocator() async {
      _init(locator);
      $initGetIt(locator);
}


Future<void> _init(GetIt locator) async {
      // Register your GoRouter here
      locator.registerLazySingleton<GoRouter>(() => goRouter);

      // Example: registering other services
      // var remoteConfigService = await RemoteConfigService.getInstance();
      // locator.registerSingleton<RemoteConfigService>(remoteConfigService!);
}