import 'package:flutter/material.dart';

class SeletedItem extends StatefulWidget {

  final ValueChanged<bool> isSelected;
  final Widget child;


  SeletedItem({this.isSelected, this.child});

  @override
  _SeletedItemState createState() => _SeletedItemState();
}

class _SeletedItemState extends State<SeletedItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Container(
              color: Colors.black.withOpacity(isSelected ? 0.9 : 0),
              child: widget.child),
          isSelected
              ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
            ),
          )
              : Container()
        ],
      ),
    );;
  }
}
