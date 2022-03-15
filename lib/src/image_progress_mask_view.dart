import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mask_view/src/view_base.dart';

typedef PathProvider = Path Function(Size size, double progress);

///built-in PathProvider
class PathProviders {
  //wave progress
  static PathProvider createWaveProvider(
    double waveWidth,
    double maxWaveHeight,
  ) {
    return (Size size, double progress) {
      double waveTotalWidth = size.width * 3;
      double top = size.height * (1 - progress);
      Path path = Path()
        ..moveTo(size.width * 2, top)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..lineTo(-size.width, top);
      //draw bezier
      double waveHeight = (1 - progress) * maxWaveHeight;
      double drawWaveWidth = 0;
      while (drawWaveWidth < waveTotalWidth) {
        path.relativeQuadraticBezierTo(
          waveWidth / 2,
          waveHeight,
          waveWidth,
          0,
        );
        path.relativeQuadraticBezierTo(
          waveWidth / 2,
          -waveHeight,
          waveWidth,
          0,
        );
        drawWaveWidth += (waveWidth * 2);
      }
      return path;
    };
  }

  //rec progress
  static Path sRecPathProvide(Size size, double progress) {
    double top = size.height * (1 - progress);
    return Path()
      ..moveTo(0, top)
      ..lineTo(size.width, top)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }
}

class ImageProgressMaskView extends StatefulWidget {
  ///viewport
  final Size size;

  ///image asset path
  final String backgroundRes;

  ///progress for view
  final double progress;

  ///mask path
  final PathProvider pathProvider;

  ///need repaint
  final ShouldRePaintDelegate? rePaintDelegate;

  const ImageProgressMaskView({
    Key? key,
    required this.size,
    required this.backgroundRes,
    required this.progress,
    required this.pathProvider,
    this.rePaintDelegate,
  })  : assert(progress >= 0 && progress <= 1),
        super(key: key);

  @override
  _ImageProgressMaskViewState createState() => _ImageProgressMaskViewState();
}

class _ImageProgressMaskViewState extends State<ImageProgressMaskView> {
  ///mask image
  ui.Image? _backgroundImg;

  bool get isReady => _backgroundImg != null;

  loadImage() async {
    ByteData byteData = await rootBundle.load(widget.backgroundRes);
    Uint8List byteArray = byteData.buffer.asUint8List();
    Codec imageCodec = await ui.instantiateImageCodec(byteArray);
    FrameInfo frameInfo = await imageCodec.getNextFrame();
    setState(() {
      _backgroundImg = frameInfo.image;
    });
  }

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  @override
  void dispose() {
    _backgroundImg?.dispose();
    _backgroundImg = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size contentSize = widget.size;
    if (isReady) {
      return RepaintBoundary(
        child: CustomPaint(
          size: contentSize,
          isComplex: true,
          painter: _ImagePainter(this),
        ),
      );
    }
    return SizedBox(
      width: contentSize.width,
      height: contentSize.height,
    );
  }
}

class _ImagePainter extends CustomPainter {
  ///config
  final _ImageProgressMaskViewState state;
  final Paint layerPaint;
  final Paint maskPaint;

  _ImagePainter(this.state)
      : layerPaint = Paint(),
        maskPaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    ImageProgressMaskView maskView = state.widget;
    canvas.saveLayer(Offset.zero & size, layerPaint);
    //draw clipPath
    maskPaint.blendMode = BlendMode.src;
    Path path = maskView.pathProvider(size, maskView.progress);
    canvas.drawPath(path, maskPaint);
    //draw image
    maskPaint.blendMode = BlendMode.srcIn;
    ui.Image image = state._backgroundImg!;
    Rect srcRec =
        Offset.zero & Size(image.width.toDouble(), image.height.toDouble());
    Rect desRec = Offset.zero & size;
    canvas.drawImageRect(image, srcRec, desRec, maskPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    ShouldRePaintDelegate? rePaintDelegate = state.widget.rePaintDelegate;
    if (rePaintDelegate == null) return false;
    return rePaintDelegate.call(oldDelegate);
  }
}
