import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class CardWidget {
    actionCard({
      required BuildContext context,
      String? title,
      Widget? widget,
      String? subTitle,
      double padding = 16.0,
      bool textCenter = false,
      titleStyle = const TextStyle(),
      subTitleStyle = const TextStyle(),
      bool hasAction = false,
      actionIcon = Icons.more_vert,
      VoidCallback? onPressed,
    }){
      return GestureDetector(
        onTap: !hasAction ? onPressed : null,
        child: Card(
        color: Colors.white,
        elevation: 5, // Adds shadow to the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Padding(
          padding: EdgeInsets.all(padding), // Padding inside the card
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between widgets
            children: <Widget>[
              Expanded(
                child: widget ?? Column(
                  crossAxisAlignment: textCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  mainAxisAlignment: textCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title??'',
                      style: titleStyle
                    ),
                    SizedBox(height: 4), // Space between title and subtitle
                    subTitle != null ?
                    Text(
                      subTitle!,
                      style: subTitleStyle
                    ) : SizedBox.shrink() ,
                  ],
                ),
              ),
              hasAction ?
              IconButton(
                icon: Icon(actionIcon), // Replace with desired icon
                onPressed: onPressed,
              ) : SizedBox.shrink(),
            ],
          ),
        ),
            ),
      );
    }
}