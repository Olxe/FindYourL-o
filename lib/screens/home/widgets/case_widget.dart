import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseWidget extends StatefulWidget {
  final Image image;
  final double iconSize;
  final bool soluce;

  const CaseWidget({
    Key key,
    @required this.image,
    @required this.iconSize,
    @required this.soluce,
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
        if(!widget.soluce) {
          setState(() {
            selected = !selected;
          });
        }
        else {
          print('test');
          final imagesCubit = BlocProvider.of<ImagesCubit>(context);
          // imagesCubit.
        }
      },
      child: Stack(
        children: [
          ColorFiltered(
            child: widget.image,
            colorFilter: ColorFilter.mode(
              !selected ? Colors.transparent : Colors.red[100],
              BlendMode.color,
            ),
          ),
          selected
              ? Center(
                  child: Icon(
                    Icons.highlight_off,
                    size: widget.iconSize / 1.4,
                    color: Colors.red,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
