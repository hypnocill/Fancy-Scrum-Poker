import 'package:flutter/material.dart';

class SingleCard extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool flat;

  SingleCard(this.text, this.color)
      : this.textSize = 60.0,
        this.flat = false;

  SingleCard.flat(this.text, this.color)
      : this.textSize = 400.0,
        this.flat = true;

  @override
  Widget build(BuildContext context) {
    if (this.flat == true) {
      return buildFlatCard();
    }

    return buildCard();
  }

  Widget buildCard() {
    return Container(
      child: Card(
        elevation: 2,
        color: color,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget buildFlatCard() {
    return Container(
      padding: EdgeInsets.all(15.0),
      color: color,
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
