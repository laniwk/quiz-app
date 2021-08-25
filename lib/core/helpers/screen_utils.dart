
import 'package:flutter/material.dart';

typedef PageBuilderFunction = Widget Function(
  BuildContext context,
  Animation<double> a1,
  Animation<double> a2,
);
mixin ScreenUtils<S extends StatefulWidget> on State<S> {

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarMsg({
    String? message,
    Widget? content,
    Duration? duration,
    Color? backgroundColor,
    double? elevation,
    bool? floating,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    SnackBarAction? action,
    Animation<double>? animation,
    void Function()? onVisible,
  }) {
    assert(
      (message != null) ^ (content != null),
      'You have to choose between showing a text message or '
      'showing a content which is a widget. If you only want '
      'to show a text message, provide some `String` to the [message], '
      "and don't provide a `Widget` to the [content]. And vice versa.",
    );
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: message != null ? Text(message) : content!,
      duration: duration ?? const Duration(milliseconds: 2000),
      backgroundColor: backgroundColor ?? Theme.of(context).accentColor,
      elevation: elevation,
      behavior: floating != null && floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      action: action,
      animation: animation,
      onVisible: onVisible,
    ));
  }
}