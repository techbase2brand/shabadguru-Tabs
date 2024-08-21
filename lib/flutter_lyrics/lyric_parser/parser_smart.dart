import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';

///smart parser
///Parser is automatically selected
class ParserSmart extends LyricsParse {
  ParserSmart(String lyric) : super(lyric);

  @override
  List<LyricsLineModel> parseLines({bool isMain = true, bool isMid = false, bool isHindi = false, bool isSpanish = false}) {
    var qrc = ParserQrc(lyric);
    if (qrc.isOK()) {
      return qrc.parseLines(isMain: isMain, isMid: isMid, isHindi: isHindi, isSpanish: isSpanish,);
    }
    return ParserLrc(lyric).parseLines(isMain: isMain, isMid: isMid, isHindi: isHindi, isSpanish: isSpanish);
  }
}
