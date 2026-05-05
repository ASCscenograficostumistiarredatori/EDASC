import 'package:asc/src/data/models/bibliography.dart';
import 'package:asc/src/data/models/cinematic_work.dart';
import 'package:asc/src/data/models/custom_folders.dart';
import 'package:asc/src/data/models/exhibition.dart';
import 'package:asc/src/data/models/interview.dart';
import 'package:asc/src/data/models/magazine.dart';
import 'package:asc/src/data/models/professions.dart';
import 'package:asc/src/data/models/scene_photo.dart';
import 'package:asc/src/data/models/set_photo.dart';
import 'package:asc/src/data/models/sketch.dart';
import 'package:asc/src/data/models/tag.dart';
import 'package:asc/src/data/models/theatre_performance.dart';
import 'package:asc/src/data/models/videointerview.dart';

/*{id: debb25a8-e06a-408f-8154-beec963cef07, first_name: A, last_name: B, profile_picture: null, bio: Nata a Genzano di Roma. Frequentato lo IED., created_at: 2024-03-01T11:49:26.724935+00:00, professions: [], magazines: [{id: 5719d353-332c-48a6-a077-1047f45898fa, date: 2024-03-04, title: Magazine n.-1, link_url:  , image_url:  , created_at: 2024-03-04T06:37:50.890573+00:00, page_images: [url, url1]}], bibliography: [], cinematic_works: [], exhibitions: [], interviews: [], scene_photos: [], sketches: [], tags: [], theatre_performances: [], videointerviews: []}*/

class EntityModel {
  EntityModel({
    required this.id,
    required this.urlID,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.bio,
    required this.url,
    required this.subtitle,
    required this.hasSubtitle,
    required this.bibliographies,
    required this.cinematicWorks,
    required this.exhibitions,
    required this.interviews,
    required this.magazines,
    required this.professions,
    required this.scenePhotos,
    required this.setPhotos,
    required this.sketches,
    required this.tags,
    required this.theatrePerformances,
    required this.videoInterviews,
    required this.pins,
    required this.customFolders,
  });

  final String id;
  final String? urlID;
  final String firstName;
  final String? lastName;
  final String? profilePicture;
  final String? url;
  final String? subtitle;
  final String? bio;
  final bool hasSubtitle;
  final List<Bibliography> bibliographies;
  final List<CinematicWork> cinematicWorks;
  final List<Exhibition> exhibitions;
  final List<Interview> interviews;
  final List<Magazine> magazines;
  final List<Profession> professions;
  final List<ScenePhoto> scenePhotos;
  final List<SetPhoto> setPhotos;
  final List<Sketch> sketches;
  final List<Tag> tags;
  final List<TheatrePerformance> theatrePerformances;
  final List<VideoInterview> videoInterviews;
  final List<dynamic> pins;
  final List<CustomFolders> customFolders;

  static EntityModel fromJson(Map<String, dynamic> json) {
    return EntityModel(
      id: json['id'],
      urlID: json['url_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      url: json['url'],
      subtitle: json['subtitle'],
      hasSubtitle: json['has_subtitle'] ?? false,
      bibliographies: Bibliography.fromJsonList(json['bibliography'] ?? []),
      cinematicWorks: CinematicWork.fromJsonList(json['cinematic_works'] ?? []),
      exhibitions: Exhibition.fromJsonList(json['exhibitions'] ?? []),
      interviews: Interview.fromJsonList(json['interviews'] ?? []),
      magazines: Magazine.fromJsonList(json['magazines'] ?? []),
      professions: Profession.fromJsonList(json['professions'] ?? []),
      scenePhotos: ScenePhoto.fromJsonList(json['scene_photos'] ?? []),
      setPhotos: SetPhoto.fromJsonList(json['set_photos'] ?? []),
      sketches: Sketch.fromJsonList(json['sketches'] ?? []),
      tags: Tag.fromJsonList(json['tags'] ?? []),
      theatrePerformances:
          TheatrePerformance.fromJsonList(json['theatre_performances'] ?? []),
      videoInterviews:
          VideoInterview.fromJsonList(json['videointerviews'] ?? []),
      pins: json['map_pin'] ?? [],
      customFolders: CustomFolders.fromJsonList(json['custom_folders'] ?? []),
    );
  }

  static List<EntityModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EntityModel.fromJson(json)).toList();
  }
}
