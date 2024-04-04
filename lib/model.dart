import 'dart:ffi';

class LynLocation {
  final String name;
  final double latitude;
  final double longitude;

  LynLocation(this.name, this.latitude, this.longitude);
}

class RoutePlanResp {
  bool status;
  String info;
  UnsignedInt infocode;
  UnsignedInt count;
  Route route;

  RoutePlanResp(this.status, this.info, this.infocode, this.count, this.route);

  factory RoutePlanResp.fromJson(Map<String, dynamic> json) {
    return RoutePlanResp(
      json['status'],
      json['info'],
      json['infocode'],
      json['count'],
      Route.fromJson(json['route']),
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
  UnsignedInt distance;
  UnsignedInt duration;
  List<Step> steps;

  Path(this.distance, this.duration, this.steps);

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      json['distance'],
      json['duration'],
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
  UnsignedInt walkType;

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
      json['walk_type'],
    );
  }
}
