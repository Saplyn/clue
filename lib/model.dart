class LynLocation {
  final String name;
  final double lat;
  final double lon;

  LynLocation(this.name, this.lat, this.lon);
}

class RoutePlan {
  bool status;
  String info;
  int infocode;
  int? count;
  Route? route;

  RoutePlan(this.status, this.info, this.infocode, this.count, this.route);

  factory RoutePlan.fromJson(Map<String, dynamic> json) {
    bool status = json['status'].toLowerCase() == 'true';
    return RoutePlan(
      status,
      json['info'],
      int.parse(json['infocode']),
      status ? int.parse(json['count']) : null,
      status ? Route.fromJson(json['route']) : null,
    );
  }
}

class Route {
  String origin; // geo-point
  String destination; // geo-point
  List<Path> paths;

  Route(this.origin, this.destination, this.paths);

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      json['origin'],
      json['destination'],
      (json['paths'] as List).map((i) => Path.fromJson(i)).toList(),
    );
  }
}

class Path {
  int distance;
  int duration;
  List<Step> steps;

  Path(this.distance, this.duration, this.steps);

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      int.parse(json['distance']),
      int.parse(json['duration']),
      (json['steps'] as List).map((i) => Step.fromJson(i)).toList(),
    );
  }
}

class Step {
  String instruction;
  String orientation;
  String? road;
  String distance;
  String duration;
  String polyline; // geo-point array
  String? action;
  String? assistantAction;
  int walkType;

  Step(
      this.instruction,
      this.orientation,
      this.road,
      this.distance,
      this.duration,
      this.polyline,
      this.action,
      this.assistantAction,
      this.walkType);

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      json['instruction'],
      json['orientation'],
      json['road'],
      json['distance'],
      json['duration'],
      json['polyline'],
      json['action'],
      json['assistant_action'],
      int.parse(json['walk_type']),
    );
  }
}
