// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:shabadguru/flutter_lyrics/lyric_helper.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';

///draw lyric reader
class LyricsReaderPaint extends ChangeNotifier implements CustomPainter {
  LyricsReaderModel? model;

  LyricUI lyricUI;
  final bool isDarkMode;

  LyricsReaderPaint(this.model, this.lyricUI, this.isDarkMode);

  ///高亮混合笔
  var lightBlendPaint = Paint()
    ..blendMode = BlendMode.srcIn
    ..isAntiAlias = true;

  var playingIndex = 0;

  double _lyricOffset = 0;

  set lyricOffset(double offset) {
    if (checkOffset(offset)) {
      _lyricOffset = offset;
      refresh();
    }
  }

  double totalHeight = 0;

  var cachePlayingIndex = -1;

  clearCache() {
    cachePlayingIndex = -1;
    highlightWidth = 0;
  }

  ///check offset illegal
  ///true is OK
  ///false is illegal
  bool checkOffset(double? offset) {
    if (offset == null) return false;

    calculateTotalHeight();

    if (offset >= maxOffset && offset <= 0) {
      return true;
    } else {
      if (offset <= maxOffset && offset > _lyricOffset) {
        return true;
      }
    }
    return false;
  }

  ///calculateTotalHeight
  void calculateTotalHeight() {
    ///缓存下，避免多余计算
    if (cachePlayingIndex != playingIndex) {
      cachePlayingIndex = playingIndex;
      var lyrics = model?.lyrics ?? [];
      double lastLineSpace = 0;
      //最大偏移量不包含最后一行
      if (lyrics.isNotEmpty) {
        lyrics = lyrics.sublist(0, lyrics.length - 1);
        lastLineSpace = LyricHelper.getLineSpaceHeight(lyrics.last, lyricUI,
            excludeInline: true);
      }
      totalHeight = -LyricHelper.getTotalHeight(lyrics, playingIndex, lyricUI) +
          (model?.firstCenterOffset(playingIndex, lyricUI) ?? 0) -
          (model?.lastCenterOffset(playingIndex, lyricUI) ?? 0) -
          lastLineSpace;
    }
  }

  double get baseOffset => lyricUI.halfSizeLimit()
      ? mSize.height * (0.5 - lyricUI.getPlayingLineBias())
      : 0;

  double get maxOffset {
    calculateTotalHeight();
    return baseOffset + totalHeight;
  }

  double get lyricOffset => _lyricOffset;

  //限制刷新频率
  int ts = DateTime.now().microsecond;

  refresh() {
    notifyListeners();
  }

  var _centerLyricIndex = 0;

  set centerLyricIndex(int value) {
    _centerLyricIndex = value;
    centerLyricIndexChangeCall?.call(value);
  }

  int get centerLyricIndex => _centerLyricIndex;

  Function(int)? centerLyricIndexChangeCall;

  Size mSize = Size.zero;

  ///给外部C位位置
  var centerY = 80.0;

  @override
  bool? hitTest(Offset position) => null;

  @override
  void paint(Canvas canvas, Size size) {
    //全局尺寸信息
    mSize = size;
    //溢出裁剪
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    // centerY = size.height * lyricUI.getPlayingLineBias();

    var drawOffset = centerY + _lyricOffset;
    var lyrics = model?.lyrics ?? [];
    drawOffset -= model?.firstCenterOffset(playingIndex, lyricUI) ?? 0;
    for (var i = 0; i < lyrics.length; i++) {
      var element = lyrics[i];
      var lineHeight = drawLine(i, drawOffset, canvas, element);
      var nextOffset = drawOffset + lineHeight;
      if (centerY > drawOffset && centerY < nextOffset) {
        if (i != centerLyricIndex) {
          centerLyricIndex = i;
        }
      }
      drawOffset = nextOffset;
    }
  }

  double drawLine(
      int i, double drawOffset, Canvas canvas, LyricsLineModel element) {
    //空行直接返回
    if (!element.hasMain && !element.hasExt && !element.hasMid && !element.hasSpanish && !element.hasHindi) {
      return lyricUI.getBlankLineHeight();
    }
    return _drawOtherLyricLine(canvas, drawOffset, element, i);
  }

  ///绘制其他歌词行
  ///返回造成的偏移量值
  double _drawOtherLyricLine(Canvas canvas, double drawOffsetY,
      LyricsLineModel element, int lineIndex) {
    var isPlay = lineIndex == playingIndex;
    var mainTextPainter = (isPlay
        ? element.drawInfo?.playingMainTextPainter
        : element.drawInfo?.otherMainTextPainter);
    var extTextPainter = (isPlay
        ? element.drawInfo?.playingExtTextPainter
        : element.drawInfo?.otherExtTextPainter);
    var midTextPainter = (isPlay
        ? element.drawInfo?.playingMidTextPainter
        : element.drawInfo?.otherMidTextPainter);


    var spanishTextPainter = (isPlay
        ? element.drawInfo?.playingSpanishTextPainter
        : element.drawInfo?.otherSpanishTextPainter);
    var hindiTextPainter = (isPlay
        ? element.drawInfo?.playingHindiTextPainter
        : element.drawInfo?.otherHindiTextPainter);


    //该行行高
    double otherLineHeight = 0;
    //第一行不加行间距
    if (lineIndex != 0) {
      otherLineHeight += lyricUI.getLineSpace();
    }
    var nextOffsetY = drawOffsetY + otherLineHeight;

    if (element.hasMain) {
      otherLineHeight += drawText(
          canvas, mainTextPainter, nextOffsetY, isPlay ? element : null);
    }

    if (element.hasMid) {
      if (element.hasMain) {
        otherLineHeight += lyricUI.getInlineSpace();
      }
      var extOffsetY = drawOffsetY + otherLineHeight;
      otherLineHeight += drawText(canvas, midTextPainter, extOffsetY);
    }
    if (element.hasExt) {
      if (element.hasMid) {
        otherLineHeight += lyricUI.getInlineSpace();
      }
      var extOffsetY = drawOffsetY + otherLineHeight;
      otherLineHeight += drawText(canvas, extTextPainter, extOffsetY);
    }

    if (element.hasSpanish) {
      if (element.hasExt) {
        otherLineHeight += lyricUI.getInlineSpace();
      }
      var extOffsetY = drawOffsetY + otherLineHeight;
      otherLineHeight += drawText(canvas, spanishTextPainter, extOffsetY);
    }
    if (element.hasHindi) {
      if (element.hasSpanish) {
        otherLineHeight += lyricUI.getInlineSpace();
      }
      var extOffsetY = drawOffsetY + otherLineHeight;
      otherLineHeight += drawText(canvas, hindiTextPainter, extOffsetY);
    }

    return otherLineHeight;
  }

  void drawHighlight(LyricsLineModel model, Canvas canvas, TextPainter? painter,
      Offset offset) {
    if (!model.hasMain) return;
    var tmpHighlightWidth = _highlightWidth;
    model.drawInfo?.inlineDrawList.forEach((element) {
      if (tmpHighlightWidth < 0) {
        return;
      }
      var currentWidth = 0.0;
      if (tmpHighlightWidth >= element.width) {
        currentWidth = element.width;
      } else {
        currentWidth = element.width - (element.width - tmpHighlightWidth);
      }
      tmpHighlightWidth -= currentWidth;
      var dx = offset.dx + element.offset.dx;
      if (lyricUI.getHighlightDirection() == HighlightDirection.RTL) {
        dx += element.width;
        dx -= currentWidth;
      }
      canvas.drawRect(
          Rect.fromLTWH(dx, offset.dy + element.offset.dy - 2, currentWidth,
              element.height + 2),
          lightBlendPaint..color = isDarkMode?Colors.white: lyricUI.getLyricHightlightColor());
    });
  }

  var _highlightWidth = 0.0;

  set highlightWidth(double value) {
    _highlightWidth = value;
    refresh();
  }

  double get highlightWidth => _highlightWidth;

  Paint layerPaint = Paint();

  ///绘制文本并返回行高度
  ///when [element] not null,then draw gradient
  double drawText(Canvas canvas, TextPainter? paint, double offsetY,
      [LyricsLineModel? element]) {
    //paint 理论上不可能为空，预期报错
    var lineHeight = paint!.height;
    if (offsetY < 0 - lineHeight || offsetY > mSize.height) {
      return lineHeight;
    }
    var isEnableLight = element != null && lyricUI.enableHighlight();
    var offset = Offset(getLineOffsetX(paint), offsetY);
    if (isEnableLight) {
      canvas.saveLayer(
          Rect.fromLTWH(0, 0, mSize.width, mSize.height), layerPaint);
    }
    paint.paint(canvas, offset);
    if (isEnableLight) {
      drawHighlight(element, canvas, paint, offset);
      canvas.restore();
    }
    return lineHeight;
  }

  ///获取行绘制横向坐标
  double getLineOffsetX(TextPainter textPainter) {
    switch (lyricUI.getLyricHorizontalAlign()) {
      case LyricAlign.LEFT:
        return 0;
      case LyricAlign.CENTER:
        return (mSize.width - textPainter.width) / 2;
      case LyricAlign.RIGHT:
        return mSize.width - textPainter.width;
      default:
        return (mSize.width - textPainter.width) / 2;
    }
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return shouldRepaint(oldDelegate);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
