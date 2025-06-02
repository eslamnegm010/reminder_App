import 'package:flutter/material.dart';

import '../../core/app_export.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFFFFFFFF),
        ),
        backgroundColor: Color(0XFFFFFFFF),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                            text: 'naw you can make your\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "REMINDER",
                                  style: TextStyle(
                                      color: AppColors.blueColor,
                                      fontWeight: FontWeight.bold))
                            ]),
                        style: TextStyle(fontSize: 20.h),
                      ),SizedBox(height: 10,),
                      SizedBox(
                        height: 60.h,
                        width: double.infinity,
                        child: Card(
                          color: AppColors.greyColor,
                          elevation: 30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: _buildScreenTitle(
                            context,
                            screenTitle: "create naw",
                            onTapScreenTitle: () => onTapScreenTitle(
                              context,
                              AppRoutes.remainderPage,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 200,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.blueColor,
            width: .5
          )
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              screenTitle,
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.title20RegularRoboto.copyWith(
                color: AppColors.blueColor,
                fontWeight: FontWeight.bold
              ),
            ),
            Icon(Icons.arrow_forward, color: Color(0XFF343330)),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
