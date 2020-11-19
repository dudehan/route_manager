import 'package:flutter/material.dart';
import 'route_abnormal_toast.dart';

abstract class WXModuleRoute {
  String getModuleName();

  Route<dynamic> onGenerateRoute(setting);
}

/// 路由配置
class AppRouter {
  static List<WXModuleRoute> _moduleRoutes = [];

  /// 提供给外部，添加路由
  static void addModuleRoutes(List<WXModuleRoute> moduleRoutes) {
    _moduleRoutes.addAll(moduleRoutes);
  }

  /// 将此函数赋值给MaterialApp的onGenerateRoute属性
  static Route<dynamic> onGenerateRoute(settings) {
    Route route;
    String path = settings.name;
    print('routeName === $path');
    if (path.contains('*')) {
      /// 传入moduleName，moduleName与routeName以*分隔
      String moduleName = path.split('*').first;
      String routeName = path.split('*').last;

      RouteSettings newSettings =
          RouteSettings(name: routeName, arguments: settings.arguments);
      for (int i = 0; i < _moduleRoutes.length; i++) {
        print('${_moduleRoutes[i].getModuleName()}');
        String tempName = _moduleRoutes[i].getModuleName();
        if (tempName != null && tempName.isNotEmpty) {
          if (tempName == moduleName) {
            route = _moduleRoutes[i].onGenerateRoute(newSettings);
            break;
          }
        } else {
          route = _moduleRoutes[i].onGenerateRoute(newSettings);
          if (route != null) break;
        }
      }
    } else {
      int index = 0;
      while (route == null && index < _moduleRoutes.length) {
        route = _moduleRoutes[index].onGenerateRoute(settings);
        index++;
      }
    }

    return route ?? unknownRoute(path);
  }

  /// 未知路由
  static Route unknownRoute(String routePath) {
    return WXDialogRoute(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: RouteAbnormalToast(message: '未知路由：$routePath'),
        );
      },
    );
  }
}
