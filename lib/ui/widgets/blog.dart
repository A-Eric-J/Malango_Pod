import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:malango_pod/ui/widgets/widget_in_busy_state.dart';

/// [ImageAndIconFill] is a custom Image widget that accepts all the types of images like network image
/// assets image, svg images and images as a file and etc that is using in this app
class ImageAndIconFill extends StatefulWidget {
  final String path;
  final Color color;
  final double height;
  final double width;
  final VoidCallback onTap;
  final BoxFit fit;
  final double radius;
  final Clip clipBehavior;
  final ImageType imageType;
  final Uint8List bytes;
  final bool isSvg;

  const ImageAndIconFill({
    Key key,
    @required this.path,
    this.color,
    this.height,
    this.width,
    this.onTap,
    this.fit = BoxFit.fill,
    this.radius = 0.0,
    this.clipBehavior,
    this.imageType = ImageType.assets,
    this.bytes,
    this.isSvg = false,
  }) : super(key: key);

  @override
  State<ImageAndIconFill> createState() => _ImageAndIconFillState();
}

class _ImageAndIconFillState extends State<ImageAndIconFill> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Stroke(
        height: widget.height,
        width: widget.width,
        clipBehavior: widget.clipBehavior,
        radius: widget.radius ?? 0,
        borderWidth: 0,
        child: _imageWidget(),
      ),
    );
  }

  Widget _imageWidget() {
    Widget image = const SizedBox();
    if (widget.isSvg) {
      image = SvgPicture.asset(
        widget.path ?? ' ',
        color: widget.color,
      );
    } else {
      image = Image.asset(
        widget.path ?? ' ',
        fit: widget.fit,
        color: widget.color,
      );
      switch (widget.imageType) {
        case ImageType.assets:
          break;
        case ImageType.file:
          image = Image.file(
            File(widget.path ?? ' '),
            fit: widget.fit,
            color: widget.color,
          );
          break;
        case ImageType.byte:
          if (widget.bytes != null) {
            image = Image.memory(
              widget.bytes,
              fit: widget.fit,
              color: widget.color,
            );
          }
          break;
        case ImageType.network:
          image = NetImage(
            url: widget.path ?? ' ',
            fit: widget.fit,
            key: Key('key ${widget.path}'),
            keyCache: 'key ${widget.path}',
            placeholder: WidgetInBusyState(
              width: widget.width,
              height: widget.height,
              radius: widget.radius,
            ),
            errorPlaceholder: WidgetInBusyState(
              width: widget.width,
              height: widget.height,
              radius: widget.radius,
            ),
          );
          break;
      }
    }

    return image;
  }
}

/// [Stroke] is a custom Container widget that is using in this app
class Stroke extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final double minHeight;
  final double maxHeight;
  final double minWidth;
  final double maxWidth;
  final double radius;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double borderWidth;
  final Color borderColor;
  final Color shadowColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final List<BoxShadow> boxShadow;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry innerPadding;
  final Clip clipBehavior;

  const Stroke({
    Key key,
    this.child,
    this.width,
    this.height,
    this.minHeight = 0.0,
    this.radius = 0.0,
    this.borderWidth = 0.0,
    this.borderColor = transparent,
    this.shadowColor = transparent,
    this.backgroundColor = transparent,
    this.onTap,
    this.boxShadow = const <BoxShadow>[],
    this.clipBehavior,
    this.padding,
    this.innerPadding,
    this.maxHeight = double.infinity,
    this.minWidth = 0,
    this.maxWidth = double.infinity,
    this.topLeftRadius = 0.0,
    this.topRightRadius = 0.0,
    this.bottomLeftRadius = 0.0,
    this.bottomRightRadius = 0.0,
  }) : super(key: key);

  @override
  State<Stroke> createState() => _StrokeState();
}

class _StrokeState extends State<Stroke> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onTap,
        child: Container(
          height: widget.height,
          width: widget.width,
          constraints: BoxConstraints(
              minHeight: widget.minHeight,
              maxHeight: widget.maxHeight,
              minWidth: widget.minWidth,
              maxWidth: widget.maxWidth),
          clipBehavior: widget.clipBehavior ?? Clip.none,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: _borderRadius(),
            border: Border.all(
                color: widget.borderColor, width: widget.borderWidth),
            boxShadow: widget.boxShadow,
          ),
          child: Padding(
            padding: widget.innerPadding ?? EdgeInsets.zero,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  BorderRadius _borderRadius() {
    if (widget.radius != 0.0) {
      return BorderRadius.circular(widget.radius);
    } else {
      return BorderRadius.only(
          topLeft: Radius.circular(widget.topLeftRadius),
          topRight: Radius.circular(widget.topRightRadius),
          bottomLeft: Radius.circular(widget.bottomLeftRadius),
          bottomRight: Radius.circular(widget.bottomRightRadius));
    }
  }
}

/// [NetImage] refers to network image that is a custom version of ExtendedImage that is using in [ImageAndIconFill]
class NetImage extends StatefulWidget {
  final String keyCache;
  final String url;
  final double height;
  final double width;
  final int cacheWidth;
  final BoxFit fit;
  final Widget placeholder;
  final Widget errorPlaceholder;

  const NetImage({
    Key key,
    @required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorPlaceholder,
    this.cacheWidth,
    this.keyCache,
  }) : super(key: key);

  @override
  State<NetImage> createState() => _NetImageState();
}

class _NetImageState extends State<NetImage> with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    animation?.forward();
  }

  @override
  void dispose() {
    animation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      key: widget.key,
      width: widget.height,
      height: widget.width,
      cacheWidth: widget.cacheWidth,
      fit: widget.fit,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        Widget renderWidget;

        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            animation?.reset();

            renderWidget = widget.placeholder ??
                SizedBox(
                  width: widget.width,
                  height: widget.height,
                );
            break;
          case LoadState.completed:
            if (state.wasSynchronouslyLoaded) {
              renderWidget = ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              );
            } else {
              animation?.forward();

              renderWidget = FadeTransition(
                opacity: _fadeInFadeOut,
                child: ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                ),
              );
            }
            break;
          case LoadState.failed:
            animation?.reset();

            renderWidget = widget.errorPlaceholder ??
                Container(
                  color: brandMainColor,
                  width: widget.width,
                  height: widget.height,
                );
            break;
        }

        return renderWidget;
      },
    );
  }
}

/// [PodcastDetailsDiagonalClipper] is a custom beautiful shape that is using in podcastDetail
class PodcastDetailsDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// [EpisodePageDiagonalClipper] is a custom beautiful shape that is using in episodePage
class EpisodePageDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.width * 0.4901);

    var firstControlPoint = Offset(size.width / 4, size.width * 0.6501);
    var firstPoint = Offset(size.width / 2, size.width * 0.6501);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 4), size.width * 0.6501);
    var secondPoint = Offset(size.width, size.width * 0.4901);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
