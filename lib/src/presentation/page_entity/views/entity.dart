import 'package:asc/src/data/models/bibliography.dart';
import 'package:asc/src/data/models/cinematic_work.dart';
import 'package:asc/src/data/models/custom_folders.dart';
import 'package:asc/src/data/models/exhibition.dart';
import 'package:asc/src/data/models/magazine.dart';
import 'package:asc/src/data/models/scene_photo.dart';
import 'package:asc/src/data/models/set_photo.dart';
import 'package:asc/src/data/models/sketch.dart';
import 'package:asc/src/di/di.dart';
import 'package:asc/src/presentation/camera/camera.dart';
import 'package:asc/src/presentation/magazine/views/magazine.dart';
import 'package:asc/src/presentation/page_entity/blocs/entity_cubit.dart';
import 'package:asc/src/presentation/page_entity/blocs/image_cubit.dart';
import 'package:asc/src/presentation/page_entity/widgets/map.dart';
import 'package:asc/src/presentation/tag_page/views/tag_page.dart';
import 'package:asc/src/theming/buttons.dart';
import 'package:asc/src/theming/expandable_container.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/tag.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EntityConnector extends StatelessWidget {
  const EntityConnector({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EntityCubit(getIt())
            ..load(id, (error) {
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
            }),
        ),
        BlocProvider(
          create: (context) => ImageCubit(),
        ),
      ],
      child: _Body(
        id: id,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<EntityCubit, EntityState>(
          builder: (context, state) {
            if (state is! EntityLoaded) {
              return const SizedBox.shrink();
            }
            return TBodyLarge(
              state.entity.professions.firstOrNull?.name ?? '',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            );
          },
        ),
        actions: [
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
        toolbarHeight: 72,
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 1),
          child: Divider(),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<EntityCubit, EntityState>(
            builder: (context, state) {
              if (state is EntityLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is EntityLoaded) {
                print(
                  state.entity.professions.firstOrNull?.color,
                );
                return ListView(
                  padding: const EdgeInsets.all(
                    Grid.x,
                  ),
                  children: [
                    TDisplay(
                      state.entity.firstName.toUpperCase(),
                      textAlign: TextAlign.center,
                      height: 1,
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                    ),
                    if (state.entity.lastName != null)
                      TDisplay(
                        state.entity.lastName!.toUpperCase(),
                        textAlign: TextAlign.center,
                        color: state.entity.professions.firstOrNull?.color,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        fontSize: 40,
                      ),
                    if (state.entity.profilePicture != null) ...[
                      const SizedBox.square(
                        dimension: 32,
                      ),
                      Center(
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: state.entity.profilePicture!,
                            width: 210,
                            height: 210,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox.square(
                      dimension: 32,
                    ),
                    TDisplay(
                      state.entity.professions.firstOrNull?.name ?? '',
                      textAlign: TextAlign.center,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox.square(
                      dimension: Grid.m,
                    ),
                    if (state.entity.bio != null)
                      TBody(
                        state.entity.bio!,
                        textAlign: TextAlign.center,
                      ),
                    if (state.entity.url != null)
                      Bounce(
                        onTap: () => launchUrlString(
                          state.entity.url!,
                          mode: LaunchMode.externalApplication,
                        ),
                        child: TBody(
                          state.entity.url!,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox.square(
                      dimension: Grid.m,
                    ),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: state.entity.professions.firstOrNull?.color,
                      ),
                    ),
                    const SizedBox.square(
                      dimension: 32,
                    ),
                    if (state.entity.hasSubtitle)
                      if (state.entity.subtitle != null) ...[
                        TDisplay(
                          state.entity.subtitle!,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          fontSize: 28,
                        ),
                        const SizedBox.square(
                          dimension: 32,
                        ),
                      ] else if (state.entity.lastName != null) ...[
                        TDisplay(
                          '${state.entity.firstName} ${state.entity.lastName}',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          fontSize: 28,
                        ),
                        const TDisplay(
                          'in Scenografia&Costume',
                          textAlign: TextAlign.center,
                          height: 1.1,
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                        ),
                        const SizedBox.square(
                          dimension: 32,
                        ),
                      ],
                    for (final e in state.entity.magazines)
                      _Magazine(magazine: e),
                    const SizedBox.square(
                      dimension: Grid.xl,
                    ),
                    _Bibliography(bibliographies: state.entity.bibliographies),
                    _CinematicWorks(
                        cinematicWorks: state.entity.cinematicWorks),
                    _Exhibition(exhibition: state.entity.exhibitions),
                    _SetPhoto(setPhotos: state.entity.setPhotos),
                    _ScenePhoto(scenePhotos: state.entity.scenePhotos),
                    _Sketches(sketches: state.entity.sketches),
                    _CustomFolders(customFolders: state.entity.customFolders),
                    _Map(
                      pins: state.entity.pins,
                    ),
                    const SizedBox.square(
                      dimension: Grid.xl,
                    ),
                    if (state.entity.tags.isNotEmpty) ...[
                      const THeadline(
                        'Tag',
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox.square(
                        dimension: 16,
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final e in state.entity.tags)
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
                    ],
                    const SizedBox.square(
                      dimension: Grid.xl,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<ImageCubit, String?>(builder: (context, state) {
            if (state == null) {
              return const SizedBox.shrink();
            }
            return Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  context.read<ImageCubit>().unfocus();
                },
                child: ColoredBox(
                  color: Colors.black.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(Grid.m),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: state,
                        fit: BoxFit.contain,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class _Bibliography extends StatelessWidget {
  const _Bibliography({super.key, required this.bibliographies});

  final List<Bibliography> bibliographies;

  @override
  Widget build(BuildContext context) {
    if (bibliographies.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpandableContainer(
      title: 'Bibliografia',
      child: Column(
        children: [
          const SizedBox.square(
            dimension: Grid.m,
          ),
          for (final e in bibliographies)
            if (e.title != null && e.description != null)
              Column(
                children: [
                  TTitle(e.title!),
                  TBody(e.description!),
                ],
              ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
        ],
      ),
    );
  }
}

class _CinematicWorks extends StatelessWidget {
  const _CinematicWorks({super.key, required this.cinematicWorks});

  final List<CinematicWork> cinematicWorks;

  @override
  Widget build(BuildContext context) {
    if (cinematicWorks.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpandableContainer(
      title: 'Cinema',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox.square(
            dimension: Grid.m,
          ),
          for (final e in cinematicWorks)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: e.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: '(${e.year})',
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        const TextSpan(
                          text: ', ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: '${e.description}',
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
              ],
            ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
        ],
      ),
    );
  }
}

class _Exhibition extends StatelessWidget {
  const _Exhibition({super.key, required this.exhibition});

  final List<Exhibition> exhibition;

  @override
  Widget build(BuildContext context) {
    if (exhibition.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpandableContainer(
      title: 'Mostre',
      child: Column(
        children: [
          const SizedBox.square(
            dimension: Grid.m,
          ),
          for (final e in exhibition)
            if (e.url != null)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<ImageCubit>().focus(e.url!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Grid.s),
                      child: CachedNetworkImage(imageUrl: e.url!),
                    ),
                  ),
                ],
              ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
        ],
      ),
    );
  }
}

class _SetPhoto extends StatelessWidget {
  const _SetPhoto({super.key, required this.setPhotos});

  final List<SetPhoto> setPhotos;

  @override
  Widget build(BuildContext context) {
    if (setPhotos.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpandableContainer(
      title: 'Foto del set',
      child: Column(
        children: [
          const SizedBox.square(
            dimension: Grid.m,
          ),
          for (final e in setPhotos)
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<ImageCubit>().focus(e.url);
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: Grid.s),
                      child: CachedNetworkImage(imageUrl: e.url)),
                ),
              ],
            ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
        ],
      ),
    );
  }
}

class _ScenePhoto extends StatelessWidget {
  const _ScenePhoto({super.key, required this.scenePhotos});

  final List<ScenePhoto> scenePhotos;

  @override
  Widget build(BuildContext context) {
    if (scenePhotos.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpandableContainer(
      title: 'Le foto di scena',
      child: Column(
        children: [
          const SizedBox.square(
            dimension: Grid.m,
          ),
          for (final e in scenePhotos)
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<ImageCubit>().focus(e.url);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Grid.s),
                    child: CachedNetworkImage(imageUrl: e.url),
                  ),
                ),
              ],
            ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
        ],
      ),
    );
  }
}

class _Sketches extends StatelessWidget {
  const _Sketches({super.key, required this.sketches});

  final List<Sketch> sketches;

  @override
  Widget build(BuildContext context) {
    if (sketches.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpandableContainer(
      title: 'Bozzetti',
      child: Column(
        children: [
          const SizedBox.square(
            dimension: Grid.m,
          ),
          for (final e in sketches)
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<ImageCubit>().focus(e.url);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Grid.s),
                    child: CachedNetworkImage(imageUrl: e.url),
                  ),
                ),
              ],
            ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
        ],
      ),
    );
  }
}

class _CustomFolders extends StatelessWidget {
  const _CustomFolders({super.key, required this.customFolders});

  final List<CustomFolders> customFolders;

  @override
  Widget build(BuildContext context) {
    if (customFolders.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        for (final e in customFolders)
          ExpandableContainer(
            title: e.name,
            child: Html(
              shrinkWrap: true,
              data: e.content,
            ),
          ),
      ],
    );
  }
}

class _Map extends StatelessWidget {
  const _Map({super.key, required this.pins});

  final List<dynamic> pins;

  @override
  Widget build(BuildContext context) {
    if (pins.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpandableContainer(
      title: 'A spasso con...',
      child: Column(
        children: [
          const SizedBox.square(
            dimension: Grid.m,
          ),
          PrimaryButton(
            label: 'Apri Mappa',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapSheet(
                    pins: pins,
                  ),
                ),
              );
            },
          ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
        ],
      ),
    );
  }
}

class _Magazine extends StatelessWidget {
  const _Magazine({super.key, required this.magazine});

  final Magazine magazine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Grid.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                context.read<ImageCubit>().focus(magazine.imageUrl);
              },
              child: CachedNetworkImage(
                imageUrl: magazine.imageUrl,
                height: 250,
              ),
            ),
          ),
          const SizedBox.square(
            dimension: Grid.m,
          ),
          TBody(
            magazine.title,
            fontWeight: FontWeight.w800,
          ),
          TBody(
            DateFormat('MMM y').format(magazine.date),
            fontWeight: FontWeight.w300,
          ),
          const SizedBox.square(
            dimension: Grid.s,
          ),
          if (magazine.pdfUrl != null)
            PrimaryButton(
              label: "Leggi l'articolo",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PDFConnector(
                        name: magazine.title, url: magazine.pdfUrl!)));
              },
            ),
        ],
      ),
    );
  }
}
