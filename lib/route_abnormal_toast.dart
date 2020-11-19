import 'package:flutter/material.dart';

class RouteAbnormalToast extends StatefulWidget {
  final String message;
  RouteAbnormalToast({this.message = '未知路由'});

  @override
  _ToastPageState createState() => _ToastPageState();
}

class _ToastPageState extends State<RouteAbnormalToast> {
  @override
  void initState() {
    super.initState();

    /// 1.5秒后退出
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        margin: EdgeInsets.only(bottom: 100),
        alignment: Alignment.bottomCenter,
        child: Text(
          widget.message,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}

/// [WXDialogRoute]为[_DialogRoute]组件的拷贝，因为是私有类，外部无法使用，所以自己拷贝一份出来
/// 具体见[routes.dart]
class WXDialogRoute<T> extends PopupRoute<T> {
  WXDialogRoute({
    @required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String barrierLabel,
    Color barrierColor = const Color(0x10000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder transitionBuilder,
    RouteSettings settings,
  })  : assert(barrierDismissible != null),
        _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder _transitionBuilder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      child: _pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child);
    } // Some default transition
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}
