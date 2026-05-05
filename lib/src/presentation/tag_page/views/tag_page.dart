import 'package:asc/src/data/models/entity.dart';
import 'package:asc/src/data/models/tag.dart';
import 'package:asc/src/di/di.dart';
import 'package:asc/src/presentation/camera/camera.dart';
import 'package:asc/src/presentation/page_entity/views/entity.dart';
import 'package:asc/src/presentation/tag_page/blocs/tag_cubit.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/tag.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagConnector extends StatelessWidget {
  const TagConnector({super.key, required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TagCubit(getIt())
        ..load(
          tag.id,
          (error) => null,
        ),
      child: _Body(
        tag: tag,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key, required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TBody(tag.name),
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
      ),
      body: BlocBuilder<TagCubit, TagState>(
        builder: (context, state) {
          if (state is TagLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TagLoaded) {
            return ListView(
              padding: const EdgeInsets.all(Grid.x),
              children: [
                const THeadline('Tag'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TagWidget(
                    label: tag.name,
                    color: tag.color,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: Grid.m),
                for (final e in state.entities)
                  _Item(
                    entity: e,
                    color: tag.color,
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.entity,
    required this.color,
  });

  final EntityModel entity;
  final Color color;

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
            builder: (context) => EntityConnector(id: entity.urlID!),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(Grid.m),
        margin: const EdgeInsets.only(bottom: Grid.m),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Grid.m),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.24),
              blurRadius: Grid.m,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: entity.profilePicture ?? '',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Icon(
                  Icons.person_outline,
                  size: 32,
                  color: Colors.black38,
                ),
              ),
            ),
            const SizedBox(width: Grid.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TTitle('${entity.firstName} ${entity.lastName}'),
                  const SizedBox.square(
                    dimension: 4,
                  ),
                  TBody(
                    entity.professions.firstOrNull?.name ?? '',
                    color: color,
                  ),
                  const SizedBox.square(
                    dimension: 4,
                  ),
                  TLabel(
                    entity.tags.map((e) => e.name).toList().join(', '),
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
