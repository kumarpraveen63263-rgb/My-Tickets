import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/config/maps_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/metro_model.dart';
import '../../../data/repositories/metro_repository.dart';
import '../../../providers/metro_provider.dart';
import 'metro_marker_icons.dart';

/// Full-featured interactive Chennai Metro map widget.
class InteractiveMetroMap extends ConsumerStatefulWidget {
  final double? height;
  final EdgeInsets mapPadding;
  final bool isFullScreen;

  const InteractiveMetroMap({
    super.key,
    this.height,
    this.mapPadding = EdgeInsets.zero,
    this.isFullScreen = false,
  });

  @override
  ConsumerState<InteractiveMetroMap> createState() =>
      _InteractiveMetroMapState();
}

class _InteractiveMetroMapState extends ConsumerState<InteractiveMetroMap> {
  static const LatLng _chennaiCenter = LatLng(13.0827, 80.2707);

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
    if (_styleJson != null) {
      // ignore: deprecated_member_use
      controller.setMapStyle(_styleJson);
    }
    _fitBoundsOnce(ref.read(metroStationsProvider));
  }

  void _fitBoundsOnce(List<MetroStationModel> stations) {
    if (_boundsFitted || _controller == null || stations.isEmpty) return;
    _boundsFitted = true;

    double minLat = stations.first.lat;
    double maxLat = stations.first.lat;
    double minLng = stations.first.lng;
    double maxLng = stations.first.lng;

    for (final s in stations) {
      if (s.lat < minLat) minLat = s.lat;
      if (s.lat > maxLat) maxLat = s.lat;
      if (s.lng < minLng) minLng = s.lng;
      if (s.lng > maxLng) maxLng = s.lng;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, widget.isFullScreen ? 48.0 : 32.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!MapsConfig.hasApiKey) {
      return _MapFallback(height: widget.height);
    }

    if (_icons == null) {
      return Container(
        height: widget.height,
        color: AppColors.surface,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.accentMetro),
        ),
      );
    }

    final stations = ref.watch(metroStationsProvider);
    final from = ref.watch(fromStationProvider);
    final to = ref.watch(toStationProvider);
    final route = ref.watch(metroRouteProvider);

    final markers = _buildMarkers(stations, from, to);
    final polylines = _buildPolylines(route);

    final map = GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: _chennaiCenter,
        zoom: 11.5,
      ),
      markers: markers,
      polylines: polylines,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      padding: widget.mapPadding,
      onMapCreated: _onMapCreated,
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
        anchor: const Offset(0.5, 0.5),
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
          color: line == MetroLine.blue
              ? AppColors.metroLineBlue
              : AppColors.metroLineGreen,
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
          polylineId: const PolylineId('selected_route'),
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

  const _StationInfoSheet({
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
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
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
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
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
                const SizedBox(width: 10),
                Expanded(
                  child: Text(station.name, style: AppTypography.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (isOnBlue) _lineChip('Blue Line', AppColors.metroLineBlue),
                if (isOnGreen)
                  _lineChip('Green Line', AppColors.metroLineGreen),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSetFrom,
                    icon: const Icon(Icons.trip_origin_rounded, size: 18),
                    label: Text(context.tr('Set as From')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.metroSelectedRoute,
                      side: const BorderSide(color: AppColors.metroSelectedRoute),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onSetTo,
                    icon: const Icon(Icons.location_on_rounded, size: 18),
                    label: Text(context.tr('Set as To')),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentMovie,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

class _MapFallback extends StatelessWidget {
  final double? height;
  const _MapFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accentMetro.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.train_rounded,
              color: AppColors.accentMetro,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Chennai Metro Network',
            style: AppTypography.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '41 stations across Blue Line (Wimco Nagar to Airport) & Green Line (Chennai Central to St. Thomas Mount).',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.metroLineBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.metroLineBlue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Blue Line • 26 Stations',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.metroLineBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.metroLineGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.metroLineGreen.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Green Line • 17 Stations',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.metroLineGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.push('/metro/search-station'),
            icon: const Icon(Icons.search_rounded, size: 16),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentMetro,
              side: const BorderSide(color: AppColors.accentMetro),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ),
            label: Text(context.tr('Search Stations')),
          ),
        ],
      ),
    );
  }
}
