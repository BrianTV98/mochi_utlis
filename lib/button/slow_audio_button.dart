import 'package:flutter/material.dart';
import 'package:mochi_utils/extension/extension.dart';

class SlowAudioButton extends StatefulWidget {
  const SlowAudioButton({
    this.onTap,
    this.width,
    this.color= Colors.white,
    this.colorTitle = Colors.white,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.shadowColor,
    this.widgetTitle,
    this.isBorder = false,
    Key? key,
    this.forceDisable,
    this.height = 52,
    this.borderColor,
  })  : gradient = null,
        super(key: key);

  final Widget? widgetTitle;

  final Color colorTitle;

  final VoidCallback? onTap;

  final double? width;

  final double? height;

  final Color? color;

  final EdgeInsets margin;

  final Color? shadowColor;

  final bool isBorder;

  final Color? borderColor;

  final List<Color>? gradient;

  /// [forceDisable] == true -> disable button
  /// [forceDisable] == false and onTap!=null -> enable
  /// [forceDisable] -> dependency ontap
  final bool? forceDisable;

  @override
  State<SlowAudioButton> createState() => _SlowAudioButtonState();
}

class _SlowAudioButtonState extends State<SlowAudioButton> with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> animation;

  late AnimationController controller2;

  late Animation<double> animation2;

  late bool enableButton;

  Color? shadowColor;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 40),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation2 = Tween<double>(begin: -1, end: 1).animate(controller2);

    controller.addListener(() {
      setState(() {});
    });
    enableButton = _getStateButton();

    shadowColor = (widget.shadowColor??  Colors.black.withOpacity(0.2));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SlowAudioButton oldWidget) {
    // TODO: implement didUpdateWidget
    enableButton = _getStateButton();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 4),
      child: Container(
        margin: widget.margin,
        height: widget.height,
        width: widget.width ?? context.withScreenUtil * 2 / 3,
        decoration: BoxDecoration(
          // gradient: _buildGradient(),
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: shadowColor,
              ),
            ),
            Transform.translate(
              offset: Offset(0, (enableButton ? -4 + 4 * animation.value : 0)),
              child: Material(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                      color: _getBorderColor(),
                    )),
                child: GestureDetector(
                  onTap: widget.onTap,
                  onTapDown: (_) => controller.forward(),
                  onTapCancel: () => controller.reset(),
                  onTapUp: (detail) async {
                    controller.reset();
                    await controller2.forward();
                    await controller2.reverse();
                  },
                  child: Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: _getStateButton() ? widget.color : const Color(0xffE0E0E0),
                      gradient: _getStateButton() ? _buildGradient() : null,
                    ),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: animation2,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.translate(
                              offset: Offset(((widget.width ?? 0) / 2 - 22) * animation2.value, 0),
                              child: widget.widgetTitle);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient? _buildGradient() {
    if (widget.onTap == null) return null;
    return widget.color != null
        ? null
        : LinearGradient(
            colors: widget.gradient ??
                [
                  const Color(0xff58CC02),
                  const Color(0xff23AC38),
                ],
          );
  }

  /// return true if enable;
  /// return false if disable
  bool _getStateButton() {
    if (widget.forceDisable == null || widget.forceDisable == false) {
      return widget.onTap != null;
    }
    return false;
  }

  _getBorderColor() {
    bool isBorder = (widget.isBorder && widget.onTap != null);
    Color? borderColor = widget.borderColor ?? shadowColor;
    return isBorder ? borderColor : Colors.transparent;
  }
}
