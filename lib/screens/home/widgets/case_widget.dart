import 'package:flutter/material.dart';

class CaseWidget extends StatefulWidget {
  final int id;
  final double size;

  const CaseWidget({
    Key key,
    @required this.id,
    @required this.size,
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
        setState(() {
          selected = !selected;
        });
      },
      child: Stack(
        children: [
          ColorFiltered(
            child: Image.asset(
              'assets/images/${widget.id}.jpg',
              fit: BoxFit.cover,
            ),
            colorFilter: ColorFilter.mode(
              !selected ? Colors.transparent : Colors.red[100],
              BlendMode.color,
            ),
          ),
          selected
              ? Center(
                  child: Icon(
                    Icons.highlight_off,
                    size: widget.size / 1.4,
                    color: Colors.red,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
