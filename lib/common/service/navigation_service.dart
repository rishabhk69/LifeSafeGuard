import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> _rootNavigatorKey;

  NavigationService(this._rootNavigatorKey);

  BuildContext? get _context => _rootNavigatorKey.currentContext;

  /// Push to a new route
  Future<void> push(String location, {Object? extra}) async {
    try {
      _context?.push(location, extra: extra);
    } catch (_) {}
  }

  /// Replace current route with new route
  Future<void> replace(String location, {Object? extra}) async {
    try {
      _context?.go(location, extra: extra);
    } catch (_) {}
  }

  /// Pop current route
  bool pop<T extends Object?>([T? result]) {
    try {
      _context?.pop(result);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Push and remove all previous routes
  Future<void> pushAndRemoveUntil(String location, {Object? extra}) async {
    try {
      _context?.go(location, extra: extra);
    } catch (_) {}
  }

  /// Pop until root
  void popToRoot() {
    try {
      while (_context?.canPop() ?? false) {
        _context?.pop();
      }
    } catch (_) {}
  }

  /// Example for going to home page
  Future<void> gotoHome({bool refresh = false}) async {
    try {
      _context?.go('/home', extra: {'refresh': refresh});
    } catch (_) {}
  }

  /// Example for logout
  Future<void> clearSessionAndLogout() async {
    try {
      _context?.go('/login');
    } catch (_) {}
  }
}
