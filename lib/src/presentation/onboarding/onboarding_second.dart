import 'package:asc/src/core/global_blocs/first_time_cubit.dart';
import 'package:asc/src/theming/buttons.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/theme.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class OnboardingSecondConnector extends StatefulWidget {
  const OnboardingSecondConnector({super.key});

  @override
  State<OnboardingSecondConnector> createState() => _OnboardingConnectorState();
}

class _OnboardingConnectorState extends State<OnboardingSecondConnector> {
  final PageController _controller = PageController();
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Grid.x),
        child: SafeArea(
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const THeadline(
                'Enciclopedia digitale',
                fontWeight: FontWeight.bold,
              ),
              const THeadline('di ASC'),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      page = index;
                    });
                  },
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/onboarding/1.png',
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Scansiona',
                                style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' il QR Code\nall\'interno del decennale dell\'ASC\nper accedere all\'enciclopedia',
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/onboarding/2.png',
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Clicca',
                                style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' nella sezione che ti interessa e\n',
                              ),
                              TextSpan(
                                text: 'leggi',
                                style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' le informazioni',
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/onboarding/3.png',
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Naviga',
                                style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' cliccando sugli hashtag ed\n',
                              ),
                              TextSpan(
                                text: 'esplora',
                                style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' l\'enciclopedia e i suoi prefessionisti',
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox.square(
                dimension: Grid.xxl,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final i in List.generate(3, (index) => index))
                    _Circle(isActive: page == i),
                ],
              ),
              const SizedBox.square(
                dimension: 25,
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                    label: page < 2 ? 'Avanti' : 'ENTRA',
                    onTap: () {
                      if (page < 2) {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      } else {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: CircleAvatar(
        radius: isActive ? 5 : 4,
        backgroundColor: isActive
            ? const Color(0xFFB9B9B9)
            : const Color(0xFFD9D9D9).withOpacity(0.7),
      ),
    );
  }
}
