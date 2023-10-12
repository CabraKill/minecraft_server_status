import 'package:flutter/material.dart';
import 'package:minecraft_server_status/infra/constants/image_constants.dart';

class McButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  const McButton({
    super.key,
    required this.text,
    this.onPressed,
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

  final ValueNotifier<bool> _isInHover = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    const scale = 0.8;

    return MouseRegion(
      onEnter: (_) => _isInHover.value = true,
      onExit: (_) => _isInHover.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isInHover,
        builder: (context, isInHover, _) => GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    _isInHover.value && enabled ? Colors.white : Colors.black,
                width: 2,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstants.buttonPattern),
                  repeat: ImageRepeat.repeat,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 232 * scale,
              ),
              height: 64 * scale,
              child: Container(
                color: !enabled ? Colors.black.withOpacity(0.5) : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontFamily: "Minecraft-ui",
                          color: enabled
                              ? Colors.white
                              : const Color.fromARGB(255, 170, 170, 170),
                          fontSize: 24,
                        ),
                      ),
                    ),
                    if (enabled) ...[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _brighterBorderColor,
                          ),
                          height: _topBorderWidth,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _brighterBorderColor,
                          ),
                          width: _horizontalBorderWidth,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _darkBorderColor,
                          ),
                          width: _horizontalBorderWidth,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _darkBorderColor,
                          ),
                          height: _bottomBorderWidth,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
