import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minecraft_server_status/infra/constants/image_constants.dart';

class McButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const McButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<McButton> createState() => _McButtonState();
}

class _McButtonState extends State<McButton> {
  static const _darkBorderColor = Color.fromARGB(95, 0, 0, 0);
  static const _brighterBorderColor = Color.fromARGB(255, 181, 181, 181);
  static const _horizontalBorderWidth = 3.0;
  static const _bottomBorderWidth = 6.0;
  static const _topBorderWidth = 3.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.buttonPattern),
                repeat: ImageRepeat.repeat,
              ),
              // border: Border(
              //   right: BorderSide(
              //     color: _darkBorderColor,
              //     width: _horizontalBorderWidth,
              //   ),
              //   bottom: BorderSide(
              //     color: _darkBorderColor,
              //     width: _bottomBorderWidth,
              //   ),
              // ),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: const TextStyle(
                fontFamily: "Minecraft-ui",
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: _brighterBorderColor,
                ),
                height: _topBorderWidth,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: const BoxDecoration(
                  color: _brighterBorderColor,
                ),
                width: _horizontalBorderWidth,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: _darkBorderColor,
                ),
                width: _horizontalBorderWidth,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: _darkBorderColor,
                ),
                height: _bottomBorderWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
