// Model class for Punjabi lyrics API response
class PunjabiLyricsModel {
  List<Lyrics>? lyrics; // List of lyrics with timing

  String? error; // Error message for failed requests

  // Constructor for error responses
  PunjabiLyricsModel.withError(String errorMessage) {
    error = errorMessage;
  }

  // Default constructor
  PunjabiLyricsModel({this.lyrics});

  PunjabiLyricsModel.fromJson(Map<String, dynamic> json) {
    if (json['lyrics'] != null) {
      lyrics = <Lyrics>[];
      json['lyrics'].forEach((v) {
        lyrics!.add(Lyrics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lyrics != null) {
      data['lyrics'] = lyrics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Model class for individual lyrics line with timing
class Lyrics {
  dynamic line; // Lyrics text line
  dynamic time; // Timing for the lyrics line

  Lyrics({this.line, this.time});

  Lyrics.fromJson(Map<String, dynamic> json) {
    line = json['line'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line'] = line;
    data['time'] = time;
    return data;
  }
}