
// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';

///qrc lyric parser
class ParserQrc extends LyricsParse {
  RegExp advancedPattern = RegExp(r"""\[\d+,\d+]""");
  RegExp qrcPattern = RegExp(r"""\((\d+,\d+)\)""");

  RegExp advancedValuePattern = RegExp(r"\[(\d*,\d*)\]");

  ParserQrc(String lyric) : super(lyric);

  @override
  List<LyricsLineModel> parseLines({bool isMain = true,bool isMid = false, bool isSpanish = false, bool isHindi = false}) {
    lyric =
        RegExp(r"""LyricContent="([\s\S]*)">""").firstMatch(lyric)?.group(1) ??
            lyric;
    //读每一行
    var lines = lyric.split("\n");
    if (lines.isEmpty) {
      return [];
    }
    List<LyricsLineModel> lineList = [];
    lines.forEach((line) {
      //匹配time
      var time = advancedPattern.stringMatch(line);
      if (time == null) {
        return;
      }
      var ts = int.parse(
          advancedValuePattern.firstMatch(time)?.group(1)?.split(",")[0] ??
              "0");
      var realLyrics = line.replaceFirst(advancedPattern, "");

      List<LyricSpanInfo> spanList = getSpanList(realLyrics);

      var lineModel = LyricsLineModel()
        ..mainText = realLyrics.replaceAll(qrcPattern, "")
        ..startTime = ts
        ..spanList = spanList;
      lineList.add(lineModel);
    });
    return lineList;
  }

  ///get line span info list
  List<LyricSpanInfo> getSpanList(String realLyrics) {
    var invalidLength = 0;
    var startIndex = 0;
    var spanList = qrcPattern.allMatches(realLyrics).map((element) {
      var span = LyricSpanInfo();

      span.raw =
          realLyrics.substring(startIndex + invalidLength, element.start);

      var elementText = element.group(0) ?? "";
      span.index = startIndex;
      span.length = element.start - span.index - invalidLength;
      invalidLength += elementText.length;
      startIndex += span.length;

      var time = (element.group(1)?.split(",") ?? ["0", "0"]);
      span.start = int.parse(time[0]);
      span.duration = int.parse(time[1]);
      return span;
    }).toList();
    return spanList;
  }

  @override
  bool isOK() {
    return lyric.contains("LyricContent=") ||
        advancedPattern.stringMatch(lyric) != null;
  }
}
