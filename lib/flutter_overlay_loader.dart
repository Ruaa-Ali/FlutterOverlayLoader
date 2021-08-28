import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const defaultValue = 56.0;

class Loader extends StatelessWidget {
  static OverlayEntry? _currentLoader;
  Loader._(this._progressIndicator, this._themeData);
  final Widget? _progressIndicator;
  final ThemeData? _themeData;

  static OverlayState? _overlayState;

  /// If you need to show an normal overlayloader, 
  /// just call Loader.show() with a build context. BuildContext is a required param.
  
  static void show(BuildContext context,
      {Widget? progressIndicator,

      /// Define your custom progress indicator if you want [optional]
      ThemeData? themeData,

      /// Define Theme [optional]
      Color? overlayColor,

      /// Define Overlay color [optional]
      double? overlayFromTop,

      /// overlayTop mean overlay start from Top margin. If you have custom appbar then will be custom appbar height here.
      double? overlayFromBottom,

      /// overlayFromBottom mean overlay end from Bottom margin.If you have custom BottomAppBar then will be custom BottomAppBar height here.
      bool isAppbarOverlay = false,

      /// isAppbarOverlay default false. By default overlay start from appbar. If haven't any AppBar then change to true.
      bool isBottomBarOverlay = true

      /// isBottomBarOverlay default true. If you don't want to overlap bottomAppbar then do false.
      }) {
    _overlayState = Overlay.of(context);
    if (_currentLoader == null) {
      ///Create current Loader Entry
      _currentLoader = new OverlayEntry(builder: (context) {
        return Stack(
          children: <Widget>[
            SafeArea(
              child: Container(
                color: overlayColor ?? Color(0x99ffffff),
                margin: EdgeInsets.only(
                    top:
                        !isAppbarOverlay ? overlayFromTop ?? defaultValue : 0.0,
                    bottom: isBottomBarOverlay
                        ? 0.0
                        : overlayFromBottom ?? defaultValue),
              ),
            ),
            Center(
                child: Loader._(
              progressIndicator,
              themeData,
            )),
          ],
        );
      });

      try {
        WidgetsBinding.instance?.addPostFrameCallback(
            (_) {

              if(_currentLoader != null) {
              _overlayState?.insert(_currentLoader!);
              }

            });
      } catch (e) {}
    }
  }

  /// You have to call hide() method in the dispose method to clear
  ///  the overlay or hide your loader when your view is disposed otherwise throws an exception.
  /// And also you have to call hide() method when you need to hide your overlay loader. For exmaple, After finishing your api call you need to hide your loader. then just call Loader.hide()
  static void hide() {
    if (_currentLoader != null) {
      try { 
        _currentLoader?.remove();
      } catch (e) {
        print(e.toString());
      } finally {
        _currentLoader = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Theme(
            data: _themeData ??
                Theme.of(context).copyWith(accentColor: Colors.blue),
            child: _progressIndicator ?? CircularProgressIndicator()));
  }
}
