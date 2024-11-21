import 'package:flutter/widgets.dart';

mixin AfterBuild<T extends StatefulWidget> on State<T> {
  @protected
  void afterBuild(BuildContext context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterBuild(context);
    });
  }
}
