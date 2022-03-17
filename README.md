<!-- 
show mask view for your application with this plugin
-->

create mask view for your application, like image progress bar, or guide view for newer

## Features

- show height-light mask for newer
- create image progress bar

## Usage

### Import the packages:

```dart
import 'package:flutter_mask_view/flutter_mask_view.dart';
```

### show height-light mask for newer:

```dart
 Scaffold(
      body: Stack(
        children: [
          //only display background for demo
          Image.asset(ImagesRes.BG_HOME),
          
          //config
          HeightLightMaskView(
            //set view size
            maskViewSize: Size(720, 1080),
            //set barrierColor 
            backgroundColor: Colors.blue.withOpacity(0.6),
            //set color for height-light
            color: Colors.transparent,
            //set height-light shape 
            // if width == radius, circle or rect
            rRect: RRect.fromRectAndRadius(
              Rect.fromLTWH(100, 100, 50, 50),
              Radius.circular(50),
            ),
          )
        ],
      ),
    )
```

more: 

```dart
          HeightLightMaskView(
            maskViewSize: Size(720, 1080),
            backgroundColor: Colors.blue.withOpacity(0.6),
            color: Colors.transparent,
            //custom height-light shape
            pathBuilder: (Size size) {
              return Path()
                ..moveTo(100, 100)
                ..lineTo(50, 150)
                ..lineTo(150, 150);
            },
            //draw something above height-light view
            drawAfter: (Canvas canvas, Size size) {
              Paint paint = Paint()
                ..color = Colors.red
                ..strokeWidth = 15
                ..style = PaintingStyle.stroke;
              canvas.drawCircle(Offset(150, 150), 50, paint);
            },
            //should repaint, default 'return false'
            rePaintDelegate: (CustomPainter oldDelegate){
              return false;
            },
          )
```

Display

<img src="https://cdn.jsdelivr.net/gh/YangLang116/picture_storage/flutter_mask_view_1.jpg" width="300" />

### create image progress bar:

```dart
      ImageProgressMaskView(
          size: Size(360, 840),
          //background image
          backgroundRes: 'images/bg.png',
          //current progress
          progress: 0.5,
          //mask shape, built-in:
          //PathProviders.sRecPathProvider: wave progress bar
          //PathProviders.createWaveProvider: rect clip progressbar
          
          //you can create more shape
          pathProvider: PathProviders.createWaveProvider(60, 100),
        ),
      )
```

`PathProviders.sRecPathProvider`:

<img src="https://cdn.jsdelivr.net/gh/YangLang116/picture_storage/flutter_mask_view_3.jpg" width="300" />

`PathProviders.createWaveProvider`:

<img src="https://cdn.jsdelivr.net/gh/YangLang116/picture_storage/flutter_mask_view_2.jpg" width="300" />

for animation:

```dart
class _MaskTestAppState extends State<MaskTestApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ImageProgressMaskView(
                  size: Size(300, 300),
                  backgroundRes: ImagesRes.IMG,
                  progress: _controller.value,
                  pathProvider: PathProviders.createWaveProvider(60, 40),
                  rePaintDelegate: (_) => true,
                ),
                Text(
                  '${(_controller.value * 100).toInt()} %',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
```

Result:

case 1: 

<img src="https://cdn.jsdelivr.net/gh/YangLang116/picture_storage/flutter_mask_view_4.webp" width="300" />

case 2: (png)

<img src="https://cdn.jsdelivr.net/gh/YangLang116/picture_storage/flutter_mask_view_6.gif" width="300" />
