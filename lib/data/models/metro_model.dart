enum MetroLine { blue, green }

extension MetroLineX on MetroLine {
  String get label => this == MetroLine.blue ? 'Blue Line' : 'Green Line';
}

class MetroStationModel {
  final String id;
  final String name;
  final MetroLine line;
  final int sequence;
  final bool isInterchange;
  final double lat;
  final double lng;

  const MetroStationModel({
    required this.id,
    required this.name,
    required this.line,
    required this.sequence,
    this.isInterchange = false,
    required this.lat,
    required this.lng,
  });
}

class MetroRouteResult {
  final List<MetroStationModel> stations;
  final int fare;
  final int travelMinutes;
  final int interchanges;

  const MetroRouteResult({
    required this.stations,
    required this.fare,
    required this.travelMinutes,
    required this.interchanges,
  });
}
