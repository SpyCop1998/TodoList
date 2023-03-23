import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/providers/splashProvider.dart';

import 'homeScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pv = Provider.of<SplashProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: pv.getUser,
        builder: (_, snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.waiting:
              return _body(context);
            default:
              if (snapShot.hasData && snapShot.data != null) {
                return !snapShot.data! ? MyApp() : HomeSceen();
              }
              return _body(context);
          }
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    bool shrinkWrap = true;
    return Center(
      child: ListView(
        shrinkWrap: shrinkWrap,
        children: [
          _icon(context),
          SizedBox(height: 10,),
          // context.emptySizedHeightBox1x,
          _title(context)
        ],
      ),
    );
  }

  FadeInLeft _icon(BuildContext context) {
    return FadeInLeft(
      child: Icon(
        Icons.article,
        // size: context.dynamicWidth(0.2),
      ),
    );
  }

  FadeInRight _title(BuildContext context) {
    return FadeInRight(
      child: Center(
        child: Text(
          "appTitle",
          // style: context.textTheme.headline5,
        ),
      ),
    );
  }
}
