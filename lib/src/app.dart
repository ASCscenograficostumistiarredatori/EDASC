import 'package:asc/src/core/constants.dart';
import 'package:asc/src/core/dependency_initializer.dart';
import 'package:asc/src/core/global_blocs/first_time_cubit.dart';
import 'package:asc/src/di/di.dart';
import 'package:asc/src/presentation/home/views/home.dart';
import 'package:asc/src/presentation/onboarding/onboarding_start.dart';
import 'package:asc/src/presentation/splash/splash.dart';
import 'package:asc/src/theming/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    try {
      final currentUserRes = await supabase.auth.getUser();
      if (currentUserRes.user == null) {
        await supabase.auth.signInAnonymously();
      }
    } catch (e) {
      print(e);
      try {
        await supabase.auth.signInAnonymously();
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      isLoading = false;
    });
    await Future.wait([
      precacheImage(
        const AssetImage('assets/pin.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/onboarding/1.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/onboarding/1.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/onboarding/1.png'),
        context,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SplashConnector();
    }
    return BlocProvider<FirstTimeCubit>(
      create: (context) => FirstTimeCubit(),
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
        home: BlocBuilder<FirstTimeCubit, bool>(
          builder: (context, state) {
            print('state: $state');
            if (state) {
              return const OnboardingConnector();
            }
            return const HomeConnector();
          },
        ),
      ),
    );
  }
}
