// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';

///normal lyric parser
class ParserLrc extends LyricsParse {
  RegExp pattern = RegExp(r"\[\d{2}:\d{2}.\d{2,3}]");

  ///匹配普通格式内容
  ///eg:[00:03.47] -> 00:03.47
  RegExp valuePattern = RegExp(r"\[(\d{2}:\d{2}.\d{2,3})\]");

  ParserLrc(String lyric) : super(lyric);

  @override
  List<LyricsLineModel> parseLines({bool isMain = true, bool isMid = false, bool isSpanish = false, bool isHindi = false}) {
    //读每一行
    var lines = lyric.split("\n");
    if (lines.isEmpty) {
      return [];
    }
    List<LyricsLineModel> lineList = [];
    lines.forEach((line) {
      //匹配time
      var time = pattern.stringMatch(line);
      if (time == null) {
        return;
      }
      //移除time，拿到真实歌词
      var realLyrics = line.replaceFirst(pattern, "");
      //转时间戳
      var ts = timeTagToTS(time);
      var lineModel = LyricsLineModel()..startTime = ts;
      if (realLyrics == "//") {
        realLyrics = "";
      }
      if (isMain) {
        lineModel.mainText = realLyrics;
      } else if (isMid) {
        lineModel.midText = realLyrics;
      } else if (isSpanish) {
        lineModel.spanishText = realLyrics;
      } else if (isHindi) {
        lineModel.hindiText = realLyrics;
      } else {
        lineModel.extText = realLyrics;
      }
      lineList.add(lineModel);
    });
    return lineList;
  }

  int? timeTagToTS(String timeTag) {
    if (timeTag.trim().isEmpty) {
      return null;
    }
    //通过正则取出value
    var value = valuePattern.firstMatch(timeTag)?.group(1) ?? "";
    if (value.isEmpty) {
      return null;
    }
    var timeArray = value.split(".");
    var padZero = 3 - timeArray.last.length;
    var millisecond = timeArray.last.padRight(padZero, "0");
    //避免出现奇葩
    if (millisecond.length > 3) {
      millisecond = millisecond.substring(0, 3);
    }
    var minAndSecArray = timeArray.first.split(":");
    return Duration(
            minutes: int.parse(minAndSecArray.first),
            seconds: int.parse(minAndSecArray.last),
            milliseconds: int.parse(millisecond))
        .inMilliseconds;
  }
}
