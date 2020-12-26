import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:find_your_leo/cubit/images_cubit.dart';

class CaseWidget extends StatefulWidget {
  final Image image;
  final double iconSize;
  final bool soluce;
  final String quote;

  const CaseWidget({
    Key key,
    @required this.image,
    @required this.iconSize,
    @required this.soluce,
    this.quote,
  }) : super(key: key);

  @override
  _CaseWidgetState createState() => _CaseWidgetState();
}

class _CaseWidgetState extends State<CaseWidget> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.soluce) {
          setState(() {
            selected = !selected;
          });
        } else {
          final imagesCubit = BlocProvider.of<ImagesCubit>(context);
          imagesCubit.onWin(widget.image);
        }
      },
      child: ColorFiltered(
        child: widget.image,
        colorFilter: ColorFilter.mode(
          !selected ? Colors.transparent : Colors.red[200],
          BlendMode.color,
        ),
      ),
    );
  }
}
