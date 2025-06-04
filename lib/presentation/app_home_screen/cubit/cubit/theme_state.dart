part of 'theme_cubit.dart';


@immutable
class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({this.themeMode = ThemeMode.dark});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState && runtimeType == other.runtimeType && themeMode == other.themeMode;

  @override
  int get hashCode => themeMode.hashCode;
}
