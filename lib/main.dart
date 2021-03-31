
import 'package:dark_theme/theme_provider.dart';
import 'package:dark_theme/z_animated_t.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
  await pathProvider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;

  print(isLightTheme);

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(isLightTheme: isLightTheme),
    child: AppStart(),
  ));
}

// to ensure we have the themeProvider before the app starts lets make a few more changes.

class AppStart extends StatelessWidget {
  const AppStart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MyApp(
      themeProvider: themeProvider,
    );
  }
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  final ThemeProvider themeProvider;

  const MyApp({Key key, @required this.themeProvider}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Light Dark Theme',
      theme: widget.themeProvider.themeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    super.initState();
  }

  // function to toggle circle animation
  changeThemeMode(bool theme) {
    if (!theme) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
   key: _scaffoldKey,
    body: SafeArea(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: height*0.01),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: Width * 0.35,
                  height: Width * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: themeProvider.themeMode().gradient,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                  ),
                ),
                Transform.translate(
                  offset: Offset(40, 0),
                  child: ScaleTransition(
                    scale: _animationController.drive(
                      Tween<double>(begin: 0.0, end: 1.0).chain(
                        CurveTween(curve: Curves.decelerate),
                      ),
                    ),
                    alignment: Alignment.topRight,
                    child: Container(
                      width: Width * .26,
                      height: Width * .26,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeProvider.isLightTheme
                              ? Colors.white
                              : Color(0xFF26242e)),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: height * 0.1),
            Text(
              'Choose a style',
              style: TextStyle(
                  fontSize: Width * .06, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.03),
            Container(
              width: Width * .6,
              child: Text(
                'Pop or subtle. Day or night.'' Customize your interface',
                textAlign: TextAlign.center,
              ),
            ),
        SizedBox(height: height * 0.1),
        Z_animated_t(values: ['Light','Dark'],ont:(v) async{
          await themeProvider.toggleThemeData();
          setState(() {
            changeThemeMode(themeProvider.isLightTheme);
          });



        }),
            SizedBox(
              height: height * .05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildDot(
                  width: Width * 0.022,
                  height: Width * 0.022,
                  color: const Color(0xFFd9d9d9),
                ),
                buildDot(
                  width: Width * 0.055,
                  height: Width * 0.022,
                  color: themeProvider.isLightTheme
                      ? Color(0xFF26242e)
                      : Colors.white,
                ),
                buildDot(
                  width: Width * 0.022,
                  height: Width * 0.022,
                  color: const Color(0xFFd9d9d9),
                ),
              ],
            ),
            Expanded(child: Container(
              width: Width ,
              height: Width,
            margin: EdgeInsets.symmetric(

              vertical: height*0.02,horizontal: Width*0.04),

              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Width * 0.025),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: Width * 0.045,
                        color: const Color(0xFF7c7b7e),
                        fontFamily: 'Rubik',
                      ),
                    ),
                  ),

              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: () {
                  // ignore: deprecated_member_use
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(
                        " Coming soon",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Width * 0.045,
                        ),
                      ),
                    ),
                  );
                },
                shape: CircleBorder(),
                color: themeProvider.isLightTheme
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF35303f),
                child: Padding(
                  padding: EdgeInsets.all(Width * 0.05),
                  child: Icon(
                    Icons.arrow_forward,
                    color: themeProvider.isLightTheme
                        ? const Color(0xFF000000)
                        : const Color(0xFFFFFFFF),
                  ),
                ),
              )



                ],



              ),

            ),



            ),


          ],
        ),


      ),

    ),
    );

  }
}


Container buildDot({double width, double height, Color color}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4),
    width: width,
    height: height,
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: color,
    ),
  );
}
