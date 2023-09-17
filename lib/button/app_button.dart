import 'package:flutter/material.dart';
import 'package:mochi_utils/extension/extension.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    this.title,
    this.onTap,
    this.width,
    this.color,
    this.colorTitle = Colors.white,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.shadowColor = const Color(0xff209B32),
    this.widgetTitle,
    this.isBorder = false,
    Key? key,
    this.forceDisable,
    this.height = 52,
    this.borderColor,
  })  : assert(title == null || widgetTitle == null),
        gradient = null,
        boxShape = BoxShape.rectangle,
        super(key: key);

  const AppButton.gradient({
    required this.gradient,
    this.title,
    this.onTap,
    this.width,
    this.color,
    this.colorTitle = Colors.white,
    this.margin = const EdgeInsets.symmetric(vertical: 16),
    this.shadowColor = const Color(0xff209B32),
    this.widgetTitle,
    this.isBorder = false,
    this.forceDisable,
    this.height = 48,
    this.borderColor,
    Key? key,
  })  : boxShape = BoxShape.rectangle,
        assert(title == null || widgetTitle == null),
        super(key: key);

  const AppButton.circle({
    this.title,
    this.onTap,
    this.width,
    this.color,
    this.colorTitle = Colors.white,
    this.margin = const EdgeInsets.symmetric(vertical: 16),
    this.shadowColor = const Color(0xff209B32),
    this.widgetTitle,
    this.isBorder = false,
    this.forceDisable,
    this.height = 48,
    this.borderColor,
    Key? key,
  })  : boxShape = BoxShape.circle,
        gradient = null,
        assert(title == null || widgetTitle == null),
        super(key: key);

  final String? title;

  final Widget? widgetTitle;

  final Color colorTitle;

  final VoidCallback? onTap;

  final double? width;

  final double? height;

  final Color? color;

  final EdgeInsets margin;

  final Color shadowColor;

  final bool isBorder;

  final Color? borderColor;

  final List<Color>? gradient;

  final BoxShape boxShape;

  /// [forceDisable] == true -> disable button
  /// [forceDisable] == false and onTap!=null -> enable
  /// [forceDisable] -> dependency ontap
  final bool? forceDisable;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> animation;

  late bool enableButton;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 40),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    enableButton = _getStateButton();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
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
            borderRadius: widget.boxShape != BoxShape.circle ? BorderRadius.circular(100) : null,
            gradient: _buildGradient(),
            shape: widget.boxShape),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: widget.shadowColor,
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
                  onTapUp: (detail) => controller.reset(),
                  child: Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: _getStateButton() ? widget.color : const Color(0xffE0E0E0),
                      gradient: _getStateButton() ? _buildGradient() : null,
                    ),
                    child: Center(
                      child: widget.widgetTitle ??
                          Text(
                            widget.title ?? '',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              color: widget.color,
                              letterSpacing: 1.29,
                            ),
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
    Color borderColor = widget.borderColor ?? widget.shadowColor;
    return isBorder ? borderColor : Colors.transparent;
  }
}
