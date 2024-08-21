import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';

///all parse extends this file
abstract class LyricsParse {
  String lyric;

  LyricsParse(this.lyric);

  ///call this method parse
  List<LyricsLineModel> parseLines({bool isMain = true,bool isMid = false,bool isSpanish = false,bool isHindi = false,});

  ///verify [lyric] is matching
  bool isOK() => true;
}
