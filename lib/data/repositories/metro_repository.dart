import '../models/metro_model.dart';

class MetroRepository {
  // Chennai Metro — Blue Line (Wimco Nagar <-> Chennai Airport)
  static final List<MetroStationModel> blueLine = [
    const MetroStationModel(
      id: 'bl_01',
      name: 'Wimco Nagar',
      line: MetroLine.blue,
      sequence: 1,
      lat: 13.2185,
      lng: 80.2963,
    ),
    const MetroStationModel(
      id: 'bl_02',
      name: 'Wimco Nagar Depot',
      line: MetroLine.blue,
      sequence: 2,
      lat: 13.2145,
      lng: 80.2940,
    ),
    const MetroStationModel(
      id: 'bl_03',
      name: 'Thiruvottiyur Theradi',
      line: MetroLine.blue,
      sequence: 3,
      lat: 13.1995,
      lng: 80.2985,
    ),
    const MetroStationModel(
      id: 'bl_04',
      name: 'Thiruvottiyur',
      line: MetroLine.blue,
      sequence: 4,
      lat: 13.1685,
      lng: 80.3010,
    ),
    const MetroStationModel(
      id: 'bl_05',
      name: 'Kaladipet',
      line: MetroLine.blue,
      sequence: 5,
      lat: 13.1553,
      lng: 80.2957,
    ),
    const MetroStationModel(
      id: 'bl_06',
      name: 'Tollgate',
      line: MetroLine.blue,
      sequence: 6,
      lat: 13.1470,
      lng: 80.2937,
    ),
    const MetroStationModel(
      id: 'bl_07',
      name: 'New Washermanpet',
      line: MetroLine.blue,
      sequence: 7,
      lat: 13.1370,
      lng: 80.2887,
    ),
    const MetroStationModel(
      id: 'bl_08',
      name: 'Washermanpet',
      line: MetroLine.blue,
      sequence: 8,
      lat: 13.1224,
      lng: 80.2871,
    ),
    const MetroStationModel(
      id: 'bl_09',
      name: 'Mannadi',
      line: MetroLine.blue,
      sequence: 9,
      lat: 13.1013,
      lng: 80.2861,
    ),
    const MetroStationModel(
      id: 'bl_10',
      name: 'High Court',
      line: MetroLine.blue,
      sequence: 10,
      lat: 13.0940,
      lng: 80.2865,
    ),
    const MetroStationModel(
      id: 'bl_11',
      name: 'Chennai Central',
      line: MetroLine.blue,
      sequence: 11,
      isInterchange: true,
      lat: 13.0827,
      lng: 80.2757,
    ),
    const MetroStationModel(
      id: 'bl_12',
      name: 'Government Estate',
      line: MetroLine.blue,
      sequence: 12,
      lat: 13.0722,
      lng: 80.2707,
    ),
    const MetroStationModel(
      id: 'bl_13',
      name: 'LIC',
      line: MetroLine.blue,
      sequence: 13,
      lat: 13.0622,
      lng: 80.2664,
    ),
    const MetroStationModel(
      id: 'bl_14',
      name: 'Thousand Lights',
      line: MetroLine.blue,
      sequence: 14,
      lat: 13.0561,
      lng: 80.2582,
    ),
    const MetroStationModel(
      id: 'bl_15',
      name: 'AG-DMS',
      line: MetroLine.blue,
      sequence: 15,
      lat: 13.0483,
      lng: 80.2513,
    ),
    const MetroStationModel(
      id: 'bl_16',
      name: 'Teynampet',
      line: MetroLine.blue,
      sequence: 16,
      lat: 13.0406,
      lng: 80.2494,
    ),
    const MetroStationModel(
      id: 'bl_17',
      name: 'Nandanam',
      line: MetroLine.blue,
      sequence: 17,
      lat: 13.0333,
      lng: 80.2432,
    ),
    const MetroStationModel(
      id: 'bl_18',
      name: 'Saidapet',
      line: MetroLine.blue,
      sequence: 18,
      lat: 13.0212,
      lng: 80.2231,
    ),
    const MetroStationModel(
      id: 'bl_19',
      name: 'Little Mount',
      line: MetroLine.blue,
      sequence: 19,
      lat: 13.0122,
      lng: 80.2185,
    ),
    const MetroStationModel(
      id: 'bl_20',
      name: 'Guindy',
      line: MetroLine.blue,
      sequence: 20,
      lat: 13.0067,
      lng: 80.2126,
    ),
    const MetroStationModel(
      id: 'bl_21',
      name: 'Alandur',
      line: MetroLine.blue,
      sequence: 21,
      isInterchange: true,
      lat: 12.9974,
      lng: 80.2010,
    ),
    const MetroStationModel(
      id: 'bl_22',
      name: 'Nanganallur Road',
      line: MetroLine.blue,
      sequence: 22,
      lat: 12.9878,
      lng: 80.1946,
    ),
    const MetroStationModel(
      id: 'bl_23',
      name: 'Meenambakkam',
      line: MetroLine.blue,
      sequence: 23,
      lat: 12.9865,
      lng: 80.1739,
    ),
    const MetroStationModel(
      id: 'bl_24',
      name: 'Chennai Airport',
      line: MetroLine.blue,
      sequence: 24,
      lat: 12.9941,
      lng: 80.1709,
    ),
  ];

  // Chennai Metro — Green Line (Chennai Central <-> St. Thomas Mount)
  static final List<MetroStationModel> greenLine = [
    const MetroStationModel(
      id: 'gl_01',
      name: 'Chennai Central',
      line: MetroLine.green,
      sequence: 1,
      isInterchange: true,
      lat: 13.0827,
      lng: 80.2757,
    ),
    const MetroStationModel(
      id: 'gl_02',
      name: 'Egmore',
      line: MetroLine.green,
      sequence: 2,
      lat: 13.0778,
      lng: 80.2609,
    ),
    const MetroStationModel(
      id: 'gl_03',
      name: 'Nehru Park',
      line: MetroLine.green,
      sequence: 3,
      lat: 13.0763,
      lng: 80.2481,
    ),
    const MetroStationModel(
      id: 'gl_04',
      name: 'Kilpauk',
      line: MetroLine.green,
      sequence: 4,
      lat: 13.0791,
      lng: 80.2416,
    ),
    const MetroStationModel(
      id: 'gl_05',
      name: 'Pachaiyappas College',
      line: MetroLine.green,
      sequence: 5,
      lat: 13.0797,
      lng: 80.2350,
    ),
    const MetroStationModel(
      id: 'gl_06',
      name: 'Shenoy Nagar',
      line: MetroLine.green,
      sequence: 6,
      lat: 13.0797,
      lng: 80.2280,
    ),
    const MetroStationModel(
      id: 'gl_07',
      name: 'Anna Nagar East',
      line: MetroLine.green,
      sequence: 7,
      lat: 13.0850,
      lng: 80.2201,
    ),
    const MetroStationModel(
      id: 'gl_08',
      name: 'Anna Nagar Tower',
      line: MetroLine.green,
      sequence: 8,
      lat: 13.0850,
      lng: 80.2101,
    ),
    const MetroStationModel(
      id: 'gl_09',
      name: 'Thirumangalam',
      line: MetroLine.green,
      sequence: 9,
      lat: 13.0790,
      lng: 80.2016,
    ),
    const MetroStationModel(
      id: 'gl_10',
      name: 'Koyambedu',
      line: MetroLine.green,
      sequence: 10,
      lat: 13.0705,
      lng: 80.1963,
    ),
    const MetroStationModel(
      id: 'gl_11',
      name: 'CMBT',
      line: MetroLine.green,
      sequence: 11,
      lat: 13.0693,
      lng: 80.1994,
    ),
    const MetroStationModel(
      id: 'gl_12',
      name: 'Arumbakkam',
      line: MetroLine.green,
      sequence: 12,
      lat: 13.0713,
      lng: 80.2114,
    ),
    const MetroStationModel(
      id: 'gl_13',
      name: 'Vadapalani',
      line: MetroLine.green,
      sequence: 13,
      lat: 13.0503,
      lng: 80.2126,
    ),
    const MetroStationModel(
      id: 'gl_14',
      name: 'Ashok Nagar',
      line: MetroLine.green,
      sequence: 14,
      lat: 13.0378,
      lng: 80.2103,
    ),
    const MetroStationModel(
      id: 'gl_15',
      name: 'Ekkatuthangal',
      line: MetroLine.green,
      sequence: 15,
      lat: 13.0264,
      lng: 80.2049,
    ),
    const MetroStationModel(
      id: 'gl_16',
      name: 'Alandur',
      line: MetroLine.green,
      sequence: 16,
      isInterchange: true,
      lat: 12.9974,
      lng: 80.2010,
    ),
    const MetroStationModel(
      id: 'gl_17',
      name: 'St. Thomas Mount',
      line: MetroLine.green,
      sequence: 17,
      lat: 12.9887,
      lng: 80.1979,
    ),
  ];

  static List<MetroStationModel> get allStations => [...blueLine, ...greenLine];

  /// Deduplicated by station name, sorted alphabetically.
  List<MetroStationModel> getAllStationsUnique() {
    final seen = <String>{};
    final result = <MetroStationModel>[];
    for (final s in [...blueLine, ...greenLine]) {
      if (seen.add(s.name)) result.add(s);
    }
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  static const List<String> popularStations = [
    'Chennai Central',
    'Chennai Airport',
    'Koyambedu',
    'CMBT',
    'Guindy',
  ];

  List<MetroStationModel> searchSync(String query) {
    final q = query.toLowerCase();
    return getAllStationsUnique()
        .where((s) => s.name.toLowerCase().contains(q))
        .toList();
  }

  static int calculateFare(int stationCount) {
    if (stationCount <= 2) return 10;
    if (stationCount <= 5) return 20;
    if (stationCount <= 10) return 30;
    if (stationCount <= 15) return 40;
    if (stationCount <= 20) return 50;
    return 60;
  }

  MetroRouteResult findRoute(String fromName, String toName) {
    if (fromName == toName) {
      final station = getAllStationsUnique().firstWhere(
        (s) => s.name == fromName,
      );
      return MetroRouteResult(
        stations: [station],
        fare: 10,
        travelMinutes: 0,
        interchanges: 0,
      );
    }

    final fromInBlue = blueLine.any((s) => s.name == fromName);
    final toInBlue = blueLine.any((s) => s.name == toName);
    final fromInGreen = greenLine.any((s) => s.name == fromName);
    final toInGreen = greenLine.any((s) => s.name == toName);

    // Same line — direct route
    if (fromInBlue && toInBlue) {
      return _directRoute(blueLine, fromName, toName);
    }
    if (fromInGreen && toInGreen) {
      return _directRoute(greenLine, fromName, toName);
    }

    // Cross line — route via best interchange (Chennai Central or Alandur)
    final candidates = <MetroRouteResult>[];
    for (final interchange in ['Chennai Central', 'Alandur']) {
      final fromLine = fromInBlue ? blueLine : greenLine;
      final toLine = toInBlue ? blueLine : greenLine;
      if (!fromLine.any((s) => s.name == interchange)) continue;
      if (!toLine.any((s) => s.name == interchange)) continue;
      final leg1 = _directRoute(fromLine, fromName, interchange);
      final leg2 = _directRoute(toLine, interchange, toName);
      final combinedStations = [...leg1.stations, ...leg2.stations.skip(1)];
      candidates.add(
        MetroRouteResult(
          stations: combinedStations,
          fare: calculateFare(combinedStations.length),
          travelMinutes: (combinedStations.length - 1) * 3 + 5,
          interchanges: 1,
        ),
      );
    }
    candidates.sort((a, b) => a.stations.length.compareTo(b.stations.length));
    return candidates.first;
  }

  MetroRouteResult _directRoute(
    List<MetroStationModel> line,
    String fromName,
    String toName,
  ) {
    final fromIdx = line.indexWhere((s) => s.name == fromName);
    final toIdx = line.indexWhere((s) => s.name == toName);
    final start = fromIdx < toIdx ? fromIdx : toIdx;
    final end = fromIdx < toIdx ? toIdx : fromIdx;
    var segment = line.sublist(start, end + 1);
    if (fromIdx > toIdx) segment = segment.reversed.toList();
    return MetroRouteResult(
      stations: segment,
      fare: calculateFare(segment.length),
      travelMinutes: (segment.length - 1) * 3,
      interchanges: 0,
    );
  }
}
