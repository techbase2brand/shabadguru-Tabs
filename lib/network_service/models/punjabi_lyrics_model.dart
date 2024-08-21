class PunjabiLyricsModel {
  List<Lyrics>? lyrics;


  String? error;

  PunjabiLyricsModel.withError(String errorMessage) {
    error = errorMessage;
  }

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

class Lyrics {
  dynamic line;
  dynamic time;

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