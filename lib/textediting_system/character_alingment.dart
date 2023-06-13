import 'package:flutter/material.dart';

import 'package:flutter/painting.dart';
import 'dart:math' as math;

class CharacterArrangementScreen extends StatefulWidget {
  @override
  _CharacterArrangementScreenState createState() =>
      _CharacterArrangementScreenState();
}

class _CharacterArrangementScreenState
    extends State<CharacterArrangementScreen> {
  TextEditingController textController = TextEditingController();
  String inputText = 'Double click here';
  bool isVerticalArrangement = false;
  double containerX = 0.0;
  double containerY = 0.0;
  double dragX = 0.0;
  double dragY = 0.0;
  double containerRotation = 0.0;
  double containerHeight = 70.0;
  double previousContainerHeight = 70.0;
  double containerWidth = 250.0;
  bool isSliderVisible = false;
  double sliderValue = 140.0;
  bool isCurvedArrangement = false;
  bool isFirstTimeCurvedClick = true;
  bool isCurvedClick = false;
  bool refreshUI = false;

  @override
  Widget build(BuildContext context) {
    if (refreshUI) {
      updateUI();
      refreshUI = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Arrangement App'),
      ),
      body: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: textController,
                    onChanged: onTextChanged,
                    decoration: const InputDecoration(
                      labelText: 'Enter text',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => setVerticalArrangement(),
                    child: const Text('Vertical Arrangement'),
                  ),
                  ElevatedButton(
                    onPressed: () => setHorizontalArrangement(),
                    child: const Text('Horizontal Arrangement'),
                  ),
                  ElevatedButton(
                    onPressed: () => setCurvedArrangement(),
                    child: const Text('Curved Arrangement'),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: isSliderVisible,
                    child: Slider(
                      value: sliderValue,
                      min: -180,
                      max: 180,
                      divisions: 18,
                      label: sliderValue.round().toString(),
                      onChanged: onSliderChanged,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Decorated Text:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
              Positioned(
                left: containerX,
                top: containerY,
                child: Transform.rotate(
                  angle: calculateContainerRotation(),
                  child: Center(
                    child: Container(
                      width: calculateContainerWidth(),
                      height: containerHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Center(
                        child: isCurvedArrangement
                            ? CurvedText(
                                text: inputText,
                                curveAngle: sliderValue,
                                sliderValue: sliderValue,
                              )
                            : Text(
                                inputText,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPanStart(DragStartDetails details) {
    dragX = details.globalPosition.dx;
    dragY = details.globalPosition.dy;
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      containerX += details.globalPosition.dx - dragX;
      containerY += details.globalPosition.dy - dragY;
      dragX = details.globalPosition.dx;
      dragY = details.globalPosition.dy;
    });
  }

  void onTextChanged(String text) {
    setState(() {
      inputText = text;
    });
  }

  void setVerticalArrangement() {
    setState(() {
      isVerticalArrangement = true;
      containerRotation = 90.0;
      isSliderVisible = false;
      isCurvedArrangement = false;
      isCurvedClick = false;
      refreshUI = true;
    });
  }

  void setHorizontalArrangement() {
    setState(() {
      isVerticalArrangement = false;
      containerRotation = 0.0;
      isSliderVisible = false;
      isCurvedArrangement = false;
      isCurvedClick = false;
      refreshUI = true;
    });
  }

  void setCurvedArrangement() {
    setState(() {
      isVerticalArrangement = false;
      containerRotation = -90.0;
      isSliderVisible = true;
      previousContainerHeight = containerHeight;
      isCurvedArrangement = true;
      isFirstTimeCurvedClick = true;
      isCurvedClick = true;
      refreshUI = true;
    });
  }

  void onSliderChanged(double value) {
    setState(() {
      sliderValue = value;
      containerHeight = previousContainerHeight + value.abs();
      refreshUI = true;
    });
  }

  double calculateContainerWidth() {
    if (inputText.isEmpty) {
      return 250.0; // Default width
    } else {
      final textPainter = getTextPainter(inputText);
      return textPainter.width + 10.0; // Add padding to the width
    }
  }

  double calculateContainerRotation() {
    return (sliderValue < 0)
        ? containerRotation * (math.pi / -180.0)
        : containerRotation * (math.pi / 180.0);
  }

  void updateUI() {
    if (isFirstTimeCurvedClick) {
      containerHeight = previousContainerHeight + sliderValue.abs();
      isFirstTimeCurvedClick = false;
    }
    if (!isCurvedClick) {
      containerHeight = previousContainerHeight;
      containerWidth = calculateContainerWidth();
    }
  }

  TextPainter getTextPainter(String text) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 18.0),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }
}

class CurvedText extends StatelessWidget {
  final String text;
  final double curveAngle;
  final double sliderValue;

  const CurvedText({
    Key? key,
    required this.text,
    required this.curveAngle,
    required this.sliderValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = math.min(constraints.maxWidth, constraints.maxHeight);
        final radius = diameter / 2;

        return CustomPaint(
          painter: CurvedTextPainter(
            text: text,
            radius: radius,
            curveAngle: curveAngle,
            sliderValue: sliderValue,
          ),
          size: Size(diameter, diameter),
        );
      },
    );
  }
}

class CurvedTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final double curveAngle;
  final double sliderValue;

  CurvedTextPainter({
    required this.text,
    required this.radius,
    required this.curveAngle,
    required this.sliderValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
        fontSize: 18.0, color: Colors.blue, fontWeight: FontWeight.bold);

    final centerX = size.width / 3;
    final centerY = size.height / 2;

    final anglePerLetter = curveAngle / (text.length - 2);

    final curvedContainerPath = Path();
    curvedContainerPath.moveTo(centerX - radius, centerY);
    curvedContainerPath.arcToPoint(
      Offset(centerX + radius, centerY),
      radius: Radius.circular(radius),
      clockwise: curveAngle > 0,
    );

    canvas.drawPath(
      curvedContainerPath,
      Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    for (var i = 0; i < text.length; i++) {
      final letter = text[i];
      final letterPainter =
          getTextPainter(TextSpan(text: letter, style: textStyle));

      final angle = -curveAngle / 2 + i * anglePerLetter;
      final dx = centerX + radius * math.cos(angle * math.pi / 180);
      final dy = centerY + radius * math.sin(angle * math.pi / 180);

      final offset = Offset(dx, dy);

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      if (curveAngle >= 0) {
        canvas.rotate((angle + 90) * math.pi / 180);
      } else {
        canvas.rotate((angle - 90) * math.pi / 180);
      }
      letterPainter.paint(
          canvas, Offset(-letterPainter.width / 2, -letterPainter.height / 2));
      canvas.restore();
    }
  }

  TextPainter getTextPainter(TextSpan textSpan) {
    return TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  bool shouldRepaint(CurvedTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        radius != oldDelegate.radius ||
        curveAngle != oldDelegate.curveAngle ||
        sliderValue != oldDelegate.sliderValue;
  }
}
