import 'package:flutter/material.dart';
import 'package:malango_pod/enums/gradient_type.dart';
import 'package:malango_pod/ui/shared/colors.dart';

/// We use a Container with  LinearGradient for some screens and widgets named
/// [CustomGradient] that has different behaviours based on [GradientType]
class CustomGradient extends StatelessWidget {
  final GradientType gradientType;
  final Widget child;

  const CustomGradient({Key key, this.child, @required this.gradientType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: child,
    );
  }

  BoxDecoration boxDecoration() {
    switch (gradientType) {
      case GradientType.slider:
        return BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
              black.withOpacity(0.3),
              black.withOpacity(0.2),
            ],
                stops: const [
              0.0,
              1.0
            ]));
        break;
      case GradientType.busyStateScreen:
        return BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                colors: [
              brandMainColor.withOpacity(0.8),
              brandMainColor.withOpacity(0.5),
              brandMainColor.withOpacity(0.4),
              brandMainColor.withOpacity(0.5),
              brandMainColor
            ],
                stops: const [
              0.1,
              0.5,
              0.4,
              0.3,
              0.9
            ]));
        break;
      case GradientType.podcastDetailBoard:
        return BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
              black.withOpacity(0.4),
              black.withOpacity(0.3),
            ],
                stops: const [
              0.0,
              1.0
            ]));
      case GradientType.episodePage:
        return BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.3),
            ],
                stops: const [
              0.0,
              1.0
            ]));
      case GradientType.nowPlayer:
        return BoxDecoration(
            gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topLeft,
          colors: [
            black.withOpacity(1),
            black.withOpacity(0.9),
            black.withOpacity(0.8),
            black.withOpacity(0.7),
            black.withOpacity(0.6),
          ],
          stops: const [0.0, 0.4, 0.6, 0.8, 1],
        ));
      default:
        return const BoxDecoration();
    }
  }
}
