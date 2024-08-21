import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'lyric_parser/parser_smart.dart';
import 'lyrics_reader_model.dart';
import 'package:collection/collection.dart';

/// lyric Util
/// support Simple format、Enhanced format
class LyricsModelBuilder {
  ///if line time is null,then use MAX_VALUE replace
  static const defaultLineDuration = 5000;

  var _lyricModel = LyricsReaderModel();

  reset() {
    _lyricModel = LyricsReaderModel();
  }

  List<LyricsLineModel>? mainLines;
  List<LyricsLineModel>? midLines;
  List<LyricsLineModel>? extLines;

  List<LyricsLineModel>? spanishLines;
  List<LyricsLineModel>? hindiLines;

  static LyricsModelBuilder create() => LyricsModelBuilder._();

  LyricsModelBuilder bindLyricToMain(String lyric, [LyricsParse? parser]) {
    mainLines = (parser ?? ParserSmart(lyric)).parseLines(isMain: true);
    return this;
  }

  LyricsModelBuilder bindLyricToMid(String lyric, [LyricsParse? parser]) {
    midLines =
        (parser ?? ParserSmart(lyric)).parseLines(isMain: false, isMid: true, isHindi: false, isSpanish: false);
    return this;
  }

  LyricsModelBuilder bindLyricToSpanish(String lyric, [LyricsParse? parser]) {
    spanishLines =
        (parser ?? ParserSmart(lyric)).parseLines(isMain: false, isMid: false, isHindi: false, isSpanish: true);
    return this;
  }

  LyricsModelBuilder bindLyricToHindi(String lyric, [LyricsParse? parser]) {
    hindiLines =
        (parser ?? ParserSmart(lyric)).parseLines(isMain: false, isMid: false, isHindi: true, isSpanish: false);
    return this;
  }

  LyricsModelBuilder bindLyricToExt(String lyric, [LyricsParse? parser]) {
    extLines = (parser ?? ParserSmart(lyric)).parseLines(isMain: false, isSpanish: false, isHindi: false, isMid: false);
    return this;
  }

  _setLyric(List<LyricsLineModel>? lineList,
      {isMain = true, isMid = false, isSpanish = false, isHindi = false}) {
    if (lineList == null) return;
    //下一行的开始时间则为上一行的结束时间，若无则MAX
    for (int i = 0; i < lineList.length; i++) {
      var currLine = lineList[i];
      try {
        currLine.endTime = lineList[i + 1].startTime;
      } catch (e) {
        var lastSpan = currLine.spanList?.lastOrNull;
        if (lastSpan != null) {
          currLine.endTime = lastSpan.end;
        } else {
          currLine.endTime = (currLine.startTime ?? 0) + defaultLineDuration;
        }
      }
    }
    if (isMain) {
      _lyricModel.lyrics.clear();
      _lyricModel.lyrics.addAll(lineList);
    } else if (isMid) {
      for (var mainLine in _lyricModel.lyrics) {
        var extLine = lineList.firstWhere(
            (extLine) =>
                mainLine.startTime == extLine.startTime &&
                mainLine.endTime == extLine.endTime, orElse: () {
          return LyricsLineModel();
        });
        mainLine.midText = extLine.midText;
      }
    }else if (isSpanish) {
      for (var mainLine in _lyricModel.lyrics) {
        var extLine = lineList.firstWhere(
            (extLine) =>
                mainLine.startTime == extLine.startTime &&
                mainLine.endTime == extLine.endTime, orElse: () {
          return LyricsLineModel();
        });
        mainLine.spanishText = extLine.spanishText;
      }
    }else if (isHindi) {
      for (var mainLine in _lyricModel.lyrics) {
        var extLine = lineList.firstWhere(
            (extLine) =>
                mainLine.startTime == extLine.startTime &&
                mainLine.endTime == extLine.endTime, orElse: () {
          return LyricsLineModel();
        });
        mainLine.hindiText = extLine.hindiText;
      }
    } else {
      for (var mainLine in _lyricModel.lyrics) {
        var extLine = lineList.firstWhere(
            (extLine) =>
                mainLine.startTime == extLine.startTime &&
                mainLine.endTime == extLine.endTime, orElse: () {
          return LyricsLineModel();
        });
        mainLine.extText = extLine.extText;
      }
    }
  }

  LyricsReaderModel getModel() {
    _setLyric(mainLines,isMain: true, isMid: false, isHindi: false, isSpanish: false);
    _setLyric(midLines,isMain: false, isMid: true, isHindi: false, isSpanish: false);
    _setLyric(extLines,isMain: false, isMid: false, isHindi: false, isSpanish: false);
    _setLyric(spanishLines, isMain: false, isMid: false, isHindi: false ,isSpanish: true);
    _setLyric(hindiLines, isMain: false, isMid: false, isHindi: true, isSpanish: false);
    return _lyricModel;
  }

  LyricsModelBuilder._();
}
