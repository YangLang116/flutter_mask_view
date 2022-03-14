<!-- 
show mask view for your application with this plugin
-->

create mask view for your application, like image progress bar, or guide view for newer

## Features

- show height light mask for newer
- create image progress bar

## Usage

Import the packages:

```dart
import 'package:flutter_mask_view/flutter_mask_view.dart';
```

show height light mask for newer

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
            //should repaint
            rePaintDelegate: (CustomPainter oldDelegate){
              return false;
            },
          )
```



