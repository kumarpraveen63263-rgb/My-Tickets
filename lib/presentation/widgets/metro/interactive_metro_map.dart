import '../../../core/localization/app_localizations.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/config/maps_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/metro_model.dart';
import '../../../data/repositories/metro_repository.dart';
import '../../../providers/metro_provider.dart';
import 'metro_line_style.dart';
import 'metro_marker_icons.dart';

/// A real, pannable/zoomable Google Map of the Chennai Metro network (Blue +
/// Green lines) with tappable station markers.
///
/// Selecting "Set as From" / "Set as To" on a station writes straight into
/// [fromStationProvider]/[toStationProvider] — the exact same state the
/// text-based [StationSearchScreen] writes to — so a station picked on the
/// map or picked by typing its name always stay in sync with each other.
class InteractiveMetroMap extends ConsumerStatefulWidget {
  /// Fixed height for the embedded card use (e.g. on Metro Home). Pass
  /// `null` to fill the available space instead (used in the fullscreen map
  /// screen, where this widget sits inside an `Expanded`/`Positioned.fill`).
  final double? height;
  final EdgeInsets mapPadding;

  InteractiveMetroMap({
    super.key,
    this.height = 340,
    this.mapPadding = EdgeInsets.zero,
  });

  @override
  ConsumerState<InteractiveMetroMap> createState() =>
      _InteractiveMetroMapState();
}

class _InteractiveMetroMapState extends ConsumerState<InteractiveMetroMap> {
  // Roughly the centroid of the Chennai Metro network; used only until the
  // camera fits itself to the real station bounds in [onMapCreated].
  static LatLng _chennaiCenter = LatLng(13.045, 80.235);

  GoogleMapController? _controller;
  Map<String, BitmapDescriptor>? _icons;
  String? _styleJson;
  bool _boundsFitted = false;

  @override
  void initState() {
    super.initState();
    if (MapsConfig.hasApiKey) _loadAssets();
  }

  Future<void> _loadAssets() async {
    final results = await Future.wait([
      MetroMarkerIcons.load(),
      rootBundle.loadString('assets/map_style_dark.json'),
    ]);
    if (!mounted) return;
    setState(() {
      _icons = results[0] as Map<String, BitmapDescriptor>;
      _styleJson = results[1] as String;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (_boundsFitted) return;
    _boundsFitted = true;
    // Fit the camera to the real network extent once, instead of guessing a
    // zoom level — this is what makes the initial view feel "composed"
    // rather than arbitrarily centered.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final stations = MetroRepository.allStations;
        final lats = stations.map((s) => s.lat);
        final lngs = stations.map((s) => s.lng);
        final bounds = LatLngBounds(
          southwest: LatLng(lats.reduce(math.min), lngs.reduce(math.min)),
          northeast: LatLng(lats.reduce(math.max), lngs.reduce(math.max)),
        );
        await controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 32),
        );
      } catch (_) {
        // Falls back to the initial camera position — cosmetic only.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!MapsConfig.hasApiKey) {
      return _MapFallback(height: widget.height);
    }
    if (_icons == null || _styleJson == null) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accentMetro),
        ),
      );
    }

    final from = ref.watch(fromStationProvider);
    final to = ref.watch(toStationProvider);
    final route = ref.watch(metroRouteProvider);
    final uniqueStations = ref.watch(metroStationsProvider);

    final map = GoogleMap(
      initialCameraPosition: CameraPosition(target: _chennaiCenter, zoom: 12),
      style: _styleJson,
      markers: _buildMarkers(uniqueStations, from, to),
      polylines: _buildPolylines(route),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      padding: widget.mapPadding,
      onMapCreated: _onMapCreated,
      // Markers/polylines are derived from Riverpod selection state, not
      // from the camera viewport, so nothing needs to recompute on every
      // pan/zoom frame — the expensive case a naive `onCameraMove` listener
      // would create. `onCameraIdle` (fires once per gesture, after the
      // camera settles) is the reserved extension point for any future
      // viewport-based work, e.g. marker clustering/culling at low zoom.
      onCameraIdle: () {},
    );

    final content = widget.height != null
        ? SizedBox(height: widget.height, child: map)
        : map;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      child: content,
    );
  }

  Set<Marker> _buildMarkers(
    List<MetroStationModel> stations,
    String? from,
    String? to,
  ) {
    final icons = _icons!;
    return stations.map((station) {
      final isFrom = station.name == from;
      final isTo = station.name == to;
      final icon = isFrom
          ? icons['from']!
          : isTo
          ? icons['to']!
          : station.isInterchange
          ? icons['interchange']!
          : icons[station.line == MetroLine.blue ? 'blue' : 'green']!;

      return Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.lat, station.lng),
        icon: icon,
        anchor: Offset(0.5, 0.5),
        zIndexInt: isFrom || isTo ? 3 : (station.isInterchange ? 2 : 1),
        consumeTapEvents: true,
        onTap: () => _showStationSheet(station),
      );
    }).toSet();
  }

  Set<Polyline> _buildPolylines(MetroRouteResult? route) {
    Polyline lineFor(MetroLine line, List<MetroStationModel> stations) =>
        Polyline(
          polylineId: PolylineId('line_${line.name}'),
          points: stations.map((s) => LatLng(s.lat, s.lng)).toList(),
          color: line.color,
          width: 4,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        );

    final polylines = {
      lineFor(MetroLine.blue, MetroRepository.blueLine),
      lineFor(MetroLine.green, MetroRepository.greenLine),
    };

    if (route != null && route.stations.length > 1) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('selected_route'),
          points: route.stations.map((s) => LatLng(s.lat, s.lng)).toList(),
          color: AppColors.metroSelectedRoute,
          width: 6,
          zIndex: 1,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    return polylines;
  }

  void _showStationSheet(MetroStationModel station) {
    final isOnBlue = MetroRepository.blueLine.any(
      (s) => s.name == station.name,
    );
    final isOnGreen = MetroRepository.greenLine.any(
      (s) => s.name == station.name,
    );

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _StationInfoSheet(
        station: station,
        isOnBlue: isOnBlue,
        isOnGreen: isOnGreen,
        onSetFrom: () {
          ref.read(fromStationProvider.notifier).state = station.name;
          Navigator.of(sheetContext).pop();
        },
        onSetTo: () {
          ref.read(toStationProvider.notifier).state = station.name;
          Navigator.of(sheetContext).pop();
        },
      ),
    );
  }
}

class _StationInfoSheet extends StatelessWidget {
  final MetroStationModel station;
  final bool isOnBlue;
  final bool isOnGreen;
  final VoidCallback onSetFrom;
  final VoidCallback onSetTo;

  _StationInfoSheet({
    required this.station,
    required this.isOnBlue,
    required this.isOnGreen,
    required this.onSetFrom,
    required this.onSetTo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(AppDimensions.paddingMedium),
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  station.isInterchange
                      ? Icons.swap_horiz_rounded
                      : Icons.train_rounded,
                  color: station.isInterchange
                      ? AppColors.metroInterchange
                      : AppColors.accentMetro,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(station.name, style: AppTypography.titleLarge),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (isOnBlue) _lineChip('Blue Line', AppColors.metroLineBlue),
                if (isOnGreen)
                  _lineChip('Green Line', AppColors.metroLineGreen),
              ],
            ),
            SizedBox(height: AppDimensions.paddingLarge),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSetFrom,
                    icon: Icon(Icons.trip_origin_rounded, size: 18),
                    label: Text(context.tr('Set as From')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.metroSelectedRoute,
                      side: BorderSide(color: AppColors.metroSelectedRoute),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onSetTo,
                    icon: Icon(Icons.location_on_rounded, size: 18),
                    label: Text(context.tr('Set as To')),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentMovie,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Shown wherever the interactive map would render, whenever
/// [MapsConfig.hasApiKey] is `false` — keeps the app fully usable (via the
/// existing text-based station search) without ever touching the native
/// Google Maps SDK.
class _MapFallback extends StatelessWidget {
  final double? height;
  _MapFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    // No border/radius of its own — every call site already frames this
    // widget (the embedded card on Metro Home, the fullscreen map screen),
    // so adding a second one here would double up on top of it.
    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      color: AppColors.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, color: AppColors.textMuted, size: 40),
          SizedBox(height: 12),
          Text(
            context.tr('Live map not set up yet'),
            style: AppTypography.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            'Add your Google Maps API key in AndroidManifest.xml and AppDelegate.swift, then set MapsConfig.hasApiKey to true.',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          OutlinedButton(
            onPressed: () => context.push('/metro/search-station'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentMetro,
              side: BorderSide(color: AppColors.accentMetro),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ),
            child: Text(context.tr('Search stations instead')),
          ),
        ],
      ),
    );
  }
}
