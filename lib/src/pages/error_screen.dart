import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/core.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),

              //Image
              SvgPicture.asset(
                ConstantImages.errorLogo,
                height: size.width * 0.4,
              ),

              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Text(
                      "Oops!",
                      style: theme.textTheme.headline4,
                    ),
                    Text(
                      "You got a bad beat!",
                      style: theme.textTheme.headline5,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      """It seems that this page is not available. While we work on fixing this, try exploring a lot more you can do on this app!""",
                      style: theme.textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.03),
                  child: Container(
                    width: size.width * 0.56,
                    height: size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ConstantColors.primaryDarkBlue,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        //Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text(
                        "Go back",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
