import 'package:asc/src/core/global_blocs/first_time_cubit.dart';
import 'package:asc/src/presentation/onboarding/onboarding_second.dart';
import 'package:asc/src/theming/buttons.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingConnector extends StatelessWidget {
  const OnboardingConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/onboarding/bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ColoredBox(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Grid.x),
            child: SafeArea(
              bottom: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const TDisplay(
                    'Benvenuti',
                    color: Colors.white,
                  ),
                  const THeadline(
                    'nell\'enciclopedia digitale sui mestieri del cinema e dello spettacolo di ASC',
                    textAlign: TextAlign.center,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryButton(
                          label: 'ENTRA',
                          onTap: () async {
                            context.read<FirstTimeCubit>().setFirstTime(false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OnboardingSecondConnector(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: Grid.s),
                        SecondaryButton(
                          label: 'Salta tutorial',
                          onTap: () {
                            context.read<FirstTimeCubit>().setFirstTime(false);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
