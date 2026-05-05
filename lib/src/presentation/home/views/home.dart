import 'package:asc/src/core/constants.dart';
import 'package:asc/src/core/global_blocs/first_time_cubit.dart';
import 'package:asc/src/data/models/entity.dart';
import 'package:asc/src/data/models/tag.dart';
import 'package:asc/src/di/di.dart';
import 'package:asc/src/presentation/camera/camera.dart';
import 'package:asc/src/presentation/credits.dart';
import 'package:asc/src/presentation/home/blocs/home_cubit.dart';
import 'package:asc/src/presentation/logos.dart';
import 'package:asc/src/presentation/onboarding/onboarding_start.dart';
import 'package:asc/src/presentation/page_entity/views/entity.dart';
import 'package:asc/src/presentation/tag_page/views/tag_page.dart';
import 'package:asc/src/theming/buttons.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/tag.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeConnector extends StatelessWidget {
  const HomeConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FirstTimeCubit(),
        ),
        BlocProvider(
          create: (context) =>
              HomeCubit(getIt())..load(() => null, (p0) => null),
        ),
      ],
      child: const _Gateway(),
    );
  }
}

class _Gateway extends StatelessWidget {
  const _Gateway({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirstTimeCubit, bool>(
      builder: (context, state) {
        if (state) {
          return const OnboardingConnector();
        }
        return const _NewHomeWithTags();
      },
    );
  }
}

class _NewHomeWithTags extends StatefulWidget {
  const _NewHomeWithTags({super.key});

  @override
  State<_NewHomeWithTags> createState() => _NewHomeWithTagsState();
}

class _NewHomeWithTagsState extends State<_NewHomeWithTags> {
  List<Tag> tags = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await supabase.from('tags').select();
      setState(() {
        tags = List<Tag>.from(res.map((e) => Tag.fromJson(e)));
        isLoading = false;
      });
      return;
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _Drawer(),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (error.isNotEmpty) {
          return Center(
            child: Text(error),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Grid.m),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 150,
                    bottom: 120,
                  ),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      for (final e in tags)
                        TagWidget(
                          label: e.name,
                          color: e.color,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TagConnector(tag: e),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              ..._buildTopElements(context),
            ],
          ),
        );
      }),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        drawer: const _Drawer(),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: Stack(
              children: [
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is HomeLoaded) {
                      return ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 140,
                          bottom: 120,
                        ),
                        children: [
                          for (final e in state.entities) _Item(entity: e),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ..._buildTopElements(context),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.entity,
  });

  final EntityModel entity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (entity.urlID == null) {
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EntityConnector(id: entity.urlID!)));
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Grid.s),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: entity.profilePicture != null
                    ? NetworkImage(entity.profilePicture!)
                    : null,
              ),
              const SizedBox.square(
                dimension: Grid.m,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TTitle('${entity.firstName} ${entity.lastName}'),
                    TLabel(
                      entity.professions.map((e) => e.name).join(', '),
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFf1f1f1),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icona_asc.png',
                width: 100,
                height: 100,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 32,
              ),
              GestureDetector(
                onTap: () => context.read<FirstTimeCubit>().setFirstTime(true),
                child: const TTitle('Onboarding'),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntityConnector(id: 'asc'),
                  ),
                ),
                child: const TTitle('ASC'),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreditsPage(),
                  ),
                ),
                child: const TTitle('Credits'),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CameraConnector(),
                  ),
                ),
                child: const TTitle('Scan QR code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> _buildTopElements(BuildContext context) {
  return [
    Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: true,
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: 'Scan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CameraConnector(),
                ),
              );
            },
          ),
        ),
      ),
    ),
    SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: Grid.m),
        padding: const EdgeInsets.all(Grid.m),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Grid.m),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: Grid.m,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox.square(
              dimension: Grid.m,
            ),
            GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(Icons.menu),
            ),
            const SizedBox.square(
              dimension: Grid.m,
            ),
            const Spacer(),
            if (false) ...[
              const Icon(Icons.search),
              Expanded(
                child: CupertinoTextField(
                  padding: const EdgeInsets.all(Grid.m),
                  placeholder: 'Search',
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  onChanged: (e) {
                    context.read<HomeCubit>().search(e, (error) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const TBody('Error'),
                          content: TBody(error),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const TBody('OK'),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CameraConnector(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: Grid.m),
                child: Icon(
                  Icons.qr_code_2,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ];
}
