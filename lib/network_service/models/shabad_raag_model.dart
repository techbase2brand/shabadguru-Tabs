// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

class ShabadRaagModel {
  dynamic status;
  dynamic message;
  List<ShabadData>? data;

  String? error;

  ShabadRaagModel.withError(String errorMessage) {
    error = errorMessage;
  }

  ShabadRaagModel({this.status, this.message, this.data});

  ShabadRaagModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShabadData>[];
      json['data'].forEach((v) {
        data!.add(ShabadData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShabadData {
  dynamic title;
  dynamic albumart;
  dynamic author;
  dynamic song;
  dynamic jsonData;
  dynamic audio;
  dynamic fileNameOnS3;
  List<EnglishTransLyrics>? englishTransLyrics;
  List<EnglishTransLyrics>? englishLyrics;
  List<EnglishTransLyrics>? spanishLyrics;
  List<EnglishTransLyrics>? hindiLyrics;

  bool isSelectedForPlaylist = false;

  ShabadData(
      {this.title,
        this.albumart,
      this.author,
      this.song,
      this.jsonData,
      this.audio,
      this.fileNameOnS3,
      this.englishTransLyrics,
      this.englishLyrics,
      this.spanishLyrics,
      this.hindiLyrics});

  ShabadData.fromJson(Map<String, dynamic> json) {
    albumart = json['albumart'];
    title = json['title']??'';
    author = json['author'];
    song = json['song'];
    jsonData = json['json'];
    audio = json['audio'];
    fileNameOnS3 = json['file_name_on_s3'];
    if (json['english_trans_lyrics'] != null) {
      englishTransLyrics = <EnglishTransLyrics>[];
      json['english_trans_lyrics'].forEach((v) {
        englishTransLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }
    if (json['english_lyrics'] != null) {
      englishLyrics = <EnglishTransLyrics>[];
      json['english_lyrics'].forEach((v) {
        englishLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }

    if (json['spanish_lyrics'] != null) {
      spanishLyrics = <EnglishTransLyrics>[];
      json['spanish_lyrics'].forEach((v) {
        spanishLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }
    if (json['hindi_lyrics'] != null) {
      hindiLyrics = <EnglishTransLyrics>[];
      json['hindi_lyrics'].forEach((v) {
        hindiLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumart'] = albumart;
    data['author'] = author;
    data['song'] = song;
    data['title'] = title;
    data['json'] = jsonData;
    data['audio'] = audio;
    data['file_name_on_s3'] = fileNameOnS3;
    if (englishTransLyrics != null) {
      data['english_trans_lyrics'] =
          englishTransLyrics!.map((v) => v.toJson()).toList();
    }
    if (englishLyrics != null) {
      data['english_lyrics'] = englishLyrics!.map((v) => v.toJson()).toList();
    }
        if (spanishLyrics != null) {
      data['spanish_lyrics'] =
          spanishLyrics!.map((v) => v.toJson()).toList();
    }
    if (hindiLyrics != null) {
      data['hindi_lyrics'] = hindiLyrics!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'title':title,
      'albumart': albumart,
      'author': author,
      'song': song,
      'json': jsonData,
      'audio': audio,
      'english_trans_lyrics':
         englishTransLyrics!=null? englishTransLyrics!.map((v) => v.toJson()).toList():null,
      'english_lyrics': englishLyrics!=null? englishLyrics!.map((v) => v.toJson()).toList():null,

      'spanish_lyrics':
         spanishLyrics!=null? spanishLyrics!.map((v) => v.toJson()).toList():null,
      'hindi_lyrics': hindiLyrics!=null? hindiLyrics!.map((v) => v.toJson()).toList():null,
    };
  }

  factory ShabadData.fromMap(Map<String, dynamic> map) {
    List<EnglishTransLyrics>? englishTransLyrics;
    List<EnglishTransLyrics>? englishLyrics;
    List<EnglishTransLyrics>? spanishTransLyrics;
    List<EnglishTransLyrics>? hindiLyrics;

    if (map['english_trans_lyrics'] != null) {
      englishTransLyrics = <EnglishTransLyrics>[];
      map['english_trans_lyrics'].forEach((v) {
        englishTransLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }
    if (map['english_lyrics'] != null) {
      englishLyrics = <EnglishTransLyrics>[];
      map['english_lyrics'].forEach((v) {
        englishLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }

    if (map['spanish_lyrics'] != null) {
      spanishTransLyrics = <EnglishTransLyrics>[];
      map['spanish_lyrics'].forEach((v) {
        spanishTransLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }
    if (map['hindi_lyrics'] != null) {
      hindiLyrics = <EnglishTransLyrics>[];
      map['hindi_lyrics'].forEach((v) {
        hindiLyrics!.add(EnglishTransLyrics.fromJson(v));
      });
    }

    return ShabadData(
      title: map['title'],
      albumart: map['albumart'],
      author: map['author'],
      song: map['song'],
      jsonData: map['json'],
      audio: map['audio'],
      englishTransLyrics: englishTransLyrics,
      englishLyrics: englishLyrics,
      spanishLyrics: spanishTransLyrics,
      hindiLyrics: hindiLyrics,
    );
  }

  String toJson2() => json.encode(toMap());

  factory ShabadData.fromJson2(String source) =>
      ShabadData.fromMap(json.decode(source));
}

class EnglishTransLyrics {
  dynamic line;
  dynamic time;

  EnglishTransLyrics({this.line, this.time});

  EnglishTransLyrics.fromJson(Map<String, dynamic> json) {
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
