import 'package:flutter/cupertino.dart';

import '../../internal/internal_defines.dart';

/// switch cameras
class ZegoAcceptButton extends StatefulWidget {
  const ZegoAcceptButton({
    Key? key,
    this.onPressed,
    this.icon,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  final ButtonIcon? icon;

  ///  You can do what you want after pressed.
  final void Function()? onPressed;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  @override
  State<ZegoAcceptButton> createState() => _ZegoAcceptButtonState();
}

class _ZegoAcceptButtonState extends State<ZegoAcceptButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final containerSize = widget.buttonSize ?? const Size(96, 96);
    final sizeBoxSize = widget.iconSize ?? const Size(56, 56);

    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: BoxDecoration(
          color: widget.icon?.backgroundColor ??
              const Color(0xff2C2F3E).withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: widget.icon?.icon ??
              const Image(
                image: AssetImage(
                  'assets/icons/invite_voice.png',
                  package: 'tussle_zego_sdk_manager',
                ),
              ),
        ),
      ),
    );
  }
}
