import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = true;
  late List<bool> isPressedList; // Track the pressed state for each button

  @override
  void initState() {
    super.initState();
    isPressedList = List.generate(Btn.buttonValues.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bckgroundDark =
        isDarkMode ? const Color(0xff292d32) : const Color(0xffE6EFF7);

    final screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bckgroundDark,
        elevation: 0,
        actions: [
          Switch(
              activeColor: Colors.grey[350],
              inactiveThumbColor:
                  isDarkMode ? Colors.blueGrey : Color(0xff374C70),
              value: isDarkMode,
              onChanged: (bool newBool) {
                setState(() {
                  isDarkMode = newBool;
                });
              }),
        ],
      ),
      backgroundColor: bckgroundDark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "0",
                    style: GoogleFonts.urbanist(
                      color: isDarkMode ? Colors.white : Color(0xff374C70),
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: List.generate(
                Btn.buttonValues.length,
                (index) => SizedBox(
                  width: screen.width / 4,
                  height: screen.width / 5,
                  child: buildButton(Btn.buttonValues[index], index),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value, int index) {
    Color textColor = Btn.isOperator(value)
        ? Color(0xffbb00ff) // Use purple for operators
        : (isDarkMode ? Colors.white : Color(0xff374C70)); // Default text color

    final bckgroundDark = isDarkMode
        ? const Color(0xff292d32)
        : const Color(0xffE6EFF7); /*Color(0xff080019);*/

    Offset _distance = isPressedList[index] ? const Offset(3, 3) : Offset(6, 6);
    double blur = isPressedList[index] ? 6.0 : 16.0;
    return Center(
      child: Listener(
        onPointerUp: (event) => setState(() {
          isPressedList[index] = false;
        }),
        onPointerDown: (event) => setState(() {
          isPressedList[index] = true;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bckgroundDark,
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Color(0xff363a3f) : Color(0xffF6FCFF),
                offset: -_distance,
                blurRadius: blur,
                inset: isPressedList[index],
              ),
              BoxShadow(
                color: isDarkMode ? Color(0xff1c2025) : Color(0xffC5D5E7),
                offset: _distance,
                blurRadius: blur,
                inset: isPressedList[index],
              ),
            ],
          ),
          child: SizedBox(
            height: 60,
            width: 60,
            child: Center(
              child: Text(
                value,
                style: GoogleFonts.urbanist(
                  color:
                      textColor, //isDarkMode ? Colors.white : Color(0xff374C70),
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*
Material(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Text(value),
        ),
      ),
    )
     */