// Shabad Raag model for API response data structure
// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

// Model class for Shabad Raag API response
class ShabadRaagModel {
  dynamic status; // API response status
  dynamic message; // API response message
  List<ShabadData>? data; // List of Shabad data

  String? error; // Error message for failed requests

  // Constructor for error responses
  ShabadRaagModel.withError(String errorMessage) {
    error = errorMessage;
  }

  // Default constructor
  ShabadRaagModel({this.status, this.message, this.data});

  // Create model from JSON response
  ShabadRaagModel.fromJson(Map<String, dynamic> json) {
    status = json['status']; // Get status from JSON
    message = json['message']; // Get message from JSON
    if (json['data'] != null) {
      data = <ShabadData>[]; // Initialize data list
      json['data'].forEach((v) {
        data!.add(ShabadData.fromJson(v)); // Add each Shabad data item
      });
    }
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status; // Add status to JSON
    data['message'] = message; // Add message to JSON
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList(); // Convert data list to JSON
    }
    return data;
  }
}

// Model class for individual Shabad data
class ShabadData {
  dynamic title; // Shabad title
  dynamic albumart; // Album art image URL
  dynamic author; // Author/composer of the Shabad
  dynamic song; // Song name
  dynamic jsonData; // JSON data for lyrics
  dynamic audio; // Audio file URL
  dynamic fileNameOnS3; // File name on S3 storage
  List<EnglishTransLyrics>? englishTransLyrics; // English translation lyrics
  List<EnglishTransLyrics>? englishLyrics; // English lyrics
  List<EnglishTransLyrics>? spanishLyrics; // Spanish translation lyrics
  List<EnglishTransLyrics>? hindiLyrics; // Hindi translation lyrics

  bool isSelectedForPlaylist = false; // Flag for playlist selection

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
