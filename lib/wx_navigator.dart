import 'package:flutter/material.dart';
import 'app_config.dart';

class WXNavigator {
  static NavigatorState _of([BuildContext context]) {
    NavigatorState navigatorState;
    if (context != null) {
      navigatorState = Navigator.of(context);
    } else {
      navigatorState = AppConfig.navigatorKey.currentState;
    }
    return navigatorState;
  }

  /// push
  static Future pushNamed({
    BuildContext context,
    String moduleName,
    @required String routeName,
    Object arguments,
  }) {
    
    String path = getPath(routeName, moduleName);
    return WXNavigator._of(context).pushNamed(path, arguments: arguments);
  }

  /// pushNamedAndRemoveUntil
  static Future<T> pushNamedAndRemoveUntil<T extends Object>(
    String newRouteName,
    RoutePredicate predicate, {
    Object arguments,
    BuildContext context,
    String moduleName,
  }) {
    String path = getPath(newRouteName, moduleName);
    return WXNavigator._of(context)
        .pushNamedAndRemoveUntil(path, predicate, arguments: arguments);
  }

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
    BuildContext context,
    String moduleName,
  }) {
    String path = getPath(routeName, moduleName);
    return WXNavigator._of(context).pushReplacementNamed(path,result: result,arguments: arguments);
  }

  /// pop
  static void pop<T extends Object>({BuildContext context, T result}) {
    return WXNavigator._of(context).pop(result);
  }

  static void popUntil({BuildContext context, RoutePredicate predicate}) {
    return WXNavigator._of(context).popUntil(predicate);
  }

  Future<T> popAndPushNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
    BuildContext context,
    String moduleName,
  }) {
    String path = getPath(routeName, moduleName);
    return WXNavigator._of(context).popAndPushNamed(path,result: result,arguments: arguments);
  }

  static String getPath(String routeName, String moduleName) {
    assert(() {
      if (routeName.contains('*')) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('路由名称不得包含*号: $routeName'),
          ErrorDescription(''),
        ]);
      }
      return true;
    }());
    assert(routeName.startsWith('/'));
    String path = routeName;
    if (moduleName != null) {
      path = '$moduleName*$routeName';
    }
    return path;
  }
}
