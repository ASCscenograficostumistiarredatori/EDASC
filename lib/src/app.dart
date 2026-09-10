import 'package:asc/src/core/constants.dart';
import 'package:asc/src/core/dependency_initializer.dart';
import 'package:asc/src/core/global_blocs/first_time_cubit.dart';
import 'package:asc/src/core/global_blocs/settings_cubit.dart';
import 'package:asc/src/di/di.dart';
import 'package:asc/src/presentation/home/views/home.dart';
import 'package:asc/src/presentation/onboarding/onboarding_start.dart';
import 'package:asc/src/presentation/splash/splash.dart';
import 'package:asc/src/theming/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLoading = true;

  static const _dependenciesInitializer = DependencyInitializer();

  Future<void> _splashDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _splashDelay();
    await _dependenciesInitializer.init();
    initializeDependencies();
    // Il login anonimo è disabilitato sul progetto Supabase in uso
    // (`anonymous_provider_disabled`): tentarlo produrrebbe solo un errore a
    // ogni avvio. I dati che servono all'app sono leggibili con la sola chiave
    // pubblica, quindi non c'è nulla da autenticare.
    // Se un domani si riattiva l'accesso anonimo, qui va rimessa la chiamata a
    // supabase.auth.signInAnonymously().
    setState(() {
      isLoading = false;
    });
    await Future.wait([
      precacheImage(
        const AssetImage('assets/pin.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/onboarding/bg.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/onboarding/1.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/onboarding/2.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/onboarding/3.png'),
        context,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SplashConnector();
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<FirstTimeCubit>(
          create: (context) => FirstTimeCubit(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit()..init(),
        ),
      ],
      child: MaterialApp(
        title: 'ASC',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.brandColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
          ),
        ),
        home: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            if (settingsState is SettingsLoading) {
              return const SplashConnector();
            }
            if (settingsState is SettingsError) {
              return Scaffold(
                body: Center(
                  child: Text('Something went wrong:\n${settingsState.error}'),
                ),
              );
            }
            return BlocBuilder<FirstTimeCubit, bool>(
              builder: (context, isFirstTime) {
                if (isFirstTime) {
                  return const OnboardingConnector();
                }
                return const HomeConnector();
              },
            );
          },
        ),
      ),
    );
  }
}
