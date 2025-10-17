import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/core/local_storage/hive.dart';
import 'package:eslam_s_application/presentation/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await HiveService.init();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Reminder',
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.initialRoute,
              routes: AppRoutes.routes,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: getDefaultThemeLight(context),
              darkTheme: getThemeDark(context),
              themeMode: state.themeMode,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
