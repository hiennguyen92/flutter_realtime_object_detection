
class Recognition {

  final double confidenceInClass;

  final String detectedClass;

  final Rect rect;

  Recognition({required this.detectedClass, required this.confidenceInClass, required this.rect});

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
    'detectedClass': detectedClass,
    'confidenceInClass': confidenceInClass,
    'rect': rect.toJson()
  };

  factory Recognition.fromJson(Map<dynamic, dynamic> json) => Recognition(
      detectedClass: json['detectedClass'] as String,
      confidenceInClass: json['confidenceInClass'] as double,
      rect: Rect.fromJson(json['rect'])
  );

  @override
  String toString() {
    return 'Recognition{x: $confidenceInClass, detectedClass: $detectedClass, rect: $rect}';
  }

}

class Rect {

  final double x;
  final double y;
  final double w;
  final double h;

  Rect({required this.x, required this.y, required this.w, required this.h});

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
    'x': x,
    'y': y,
    'w': w,
    'h': h
  };

  factory Rect.fromJson(Map<dynamic, dynamic> json) => Rect(x: json['x'], y: json['y'], w: json['w'], h: json['h']);

  @override
  String toString() {
    return 'Rect{x: $x, y: $y, w: $w, h: $h}';
  }

}