import 'dart:async';

import 'package:asc/src/theming/app_bar.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSheet extends StatefulWidget {
  const MapSheet({
    super.key,
    required this.pins,
  });

  final List<dynamic> pins;

  @override
  State<MapSheet> createState() => _MapSheetState();
}

class _MapSheetState extends State<MapSheet> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<void> openSheet(Map<String, dynamic> map) async {
    await _controller.future.then(
      (controller) => controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              map['latitude'],
              map['longitude'],
            ),
            zoom: 14,
          ),
        ),
      ),
    );
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(Grid.mplus),
                child: Icon(
                  Icons.close,
                  color: Colors.black45,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: Grid.mplus),
                children: [
                  if (map['image'] != null &&
                      (map['image'] as String).trim() != '')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Grid.m),
                      child: CachedNetworkImage(
                        imageUrl: map['image'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => ColoredBox(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  THeadline(map['title']),
                  const SizedBox(
                    height: 16,
                  ),
                  html.Html(
                    data: map['description'],
                  ),
                  const SafeArea(
                    child: SizedBox(
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'A spacco con...'),
      body: Stack(
        children: [
          CustomGoogleMapMarkerBuilder(
            customMarkers: [
              ...widget.pins.map(
                (e) => MarkerData(
                  marker: Marker(
                    markerId: MarkerId(e['id'].toString()),
                    position: LatLng(
                      e['latitude'],
                      e['longitude'],
                    ),
                    onTap: () => openSheet(e),
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: const Color.fromARGB(255, 133, 34, 27),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 8.0,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Image.asset(
                        'assets/pin.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            builder: (BuildContext context, Set<Marker>? markers) => GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  41.902782,
                  12.496366,
                ),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle(mapStyle);
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        widget.pins.first['latitude'],
                        widget.pins.first['longitude'],
                      ),
                      zoom: 14,
                    ),
                  ),
                );
              },
              markers: markers ?? {},
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 230,
                  child: Builder(builder: (context) {
                    final list = widget.pins.reversed.toList();
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.pins.length,
                      itemBuilder: (context, index) {
                        final pin = list[index];
                        if (pin['image'] != null) {
                          return GestureDetector(
                            onTap: () => openSheet(pin),
                            child: Container(
                              margin: const EdgeInsets.only(left: Grid.s),
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Grid.m),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Grid.m),
                                    child: CachedNetworkImage(
                                      imageUrl: pin['image'],
                                      width: 200,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          ColoredBox(
                                              color:
                                                  Colors.grey.withOpacity(0.3)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        TBody(
                                          pin['title'],
                                          color: Colors.black,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const mapStyle = '''[
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]''';
