
import 'package:dark_theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Z_animated_t extends StatefulWidget {

  final List <String> values;
  final ValueChanged ont;

 Z_animated_t({
   Key key,
   @required this.values, @required this.ont}): super (key : key);

  @override
  _Z_animated_tState createState() => _Z_animated_tState();
}

class _Z_animated_tState extends State<Z_animated_t> {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: width * .7,
      height: width * .13,
      child: Stack(
        children: [
      GestureDetector(
        onTap: (){
          widget.ont(1);
        },
        child: Container(
          width: width*.7,
          height: width*0.13,
          decoration: ShapeDecoration(
            color: themeProvider.themeMode().toggleBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width*0.1),
            ),


          ),
          child: Row(
            children:List.generate(widget.values.length,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.1),
                      child: Text(
                        widget.values[index],
                        style: TextStyle(
                            fontSize: width * .05,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF918f95)),
                      ),

                    )

            ),

          ),


        ),


      ),
          AnimatedAlign(
            alignment: themeProvider.isLightTheme
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: Duration(milliseconds: 350),
            curve: Curves.ease,
            child: Container(
              alignment: Alignment.center,
              width: width * .35,
              height: width * .13,
              decoration: ShapeDecoration(

                  color: themeProvider.themeMode().toggleButtonColor,
                  shadows: themeProvider.themeMode().shadow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * .1))),
              child: Text(
                themeProvider.isLightTheme
                    ? widget.values[0]
                    : widget.values[1],
                style: TextStyle(
                    fontSize: width * .045, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );


  }
}

