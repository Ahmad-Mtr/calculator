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
  String number1 = "";
  String operand = "";
  String number2 = "";
  bool isDarkMode = false;
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
          IconButton(
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
            icon: isDarkMode
                ? Icon(Icons.dark_mode_outlined)
                : Icon(
                    Icons.dark_mode_rounded,
                    color: Color(0xff374C70),
                  ),
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          ),
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
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: GoogleFonts.urbanist(
                      color: (isDarkMode ? Colors.white : Color(0xff374C70)),
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: [
                // Generate buttons excluding the "=" button
                ...Btn.buttonValues
                    .where((value) => value != Btn.calculate)
                    .map((value) => SizedBox(
                          width: screen.width / 4,
                          height: screen.width / 5,
                          child: buildButton(
                              value, Btn.buttonValues.indexOf(value)),
                        )),
                // Generate the "=" button
                SizedBox(
                  width: screen.width / 2, // Make it twice as wide
                  height: screen.width / 5,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: buildButton(
                        Btn.calculate, Btn.buttonValues.indexOf(Btn.calculate)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value, int index) {
    final buttonTextStyle = TextStyle(
      color: [Btn.del, Btn.clr].contains(value)
          ? Color(0xff80a5fa)
          : [
              Btn.per,
              Btn.add,
              Btn.subtract,
              Btn.multiply,
              Btn.divide,
              Btn.calculate
            ].contains(value)
              ? Color(0xff9980fa)
              : (isDarkMode
                  ? Colors.white
                  : Color(
                      0xff374C70)), //isDarkMode ? Colors.white : Color(0xff374C70),
      fontWeight: [
        Btn.calculate,
        Btn.add,
        Btn.multiply,
        Btn.subtract,
        Btn.divide,
        Btn.clr,
        Btn.del,
        Btn.dot,
        Btn.per
      ].contains(value)
          ? FontWeight.w500
          : FontWeight.w400,
      fontSize: [
        Btn.calculate,
        Btn.add,
        Btn.multiply,
        Btn.subtract,
        Btn.divide,
        Btn.dot,
        Btn.per
      ].contains(value)
          ? 25
          : 18,
    );
    final bckgroundDark = isDarkMode
        ? const Color(0xff292d32)
        : const Color(0xffE6EFF7); /*Color(0xff080019);*/

    Offset _distance = isPressedList[index] ? const Offset(3, 3) : Offset(6, 6);
    double blur = isPressedList[index] ? 6.0 : 16.0;
    return GestureDetector(
      onTap: () => onBtnTap(value),
      child: Center(
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
              color: /* [Btn.calculate].contains(value)
                  ? Color(0xffd0c5fa)
                  : */
                  bckgroundDark,
              boxShadow: [
                BoxShadow(
                  color: /* [Btn.calculate].contains(value)
                      ? Color(0x66b79eff)
                      : */
                      (isDarkMode ? Color(0xff363a3f) : Color(0xffF6FCFF)),
                  offset: -_distance,
                  blurRadius: blur,
                  inset: isPressedList[index],
                ),
                BoxShadow(
                  color: /*[Btn.calculate].contains(value)
                      ? Color(0xff7c68cc)
                      : */
                      (isDarkMode ? Color(0xff1c2025) : Color(0xffC5D5E7)),
                  offset: _distance,
                  blurRadius: blur,
                  inset: isPressedList[index],
                ),
              ],
            ),
            child: SizedBox(
              height: 60,
              width: [Btn.calculate].contains(value) ? 160.0 : 60.0,
              child: Center(
                child: Text(
                  value,
                  style: [
                    Btn.n0,
                    Btn.n1,
                    Btn.n2,
                    Btn.n3,
                    Btn.n4,
                    Btn.n5,
                    Btn.n6,
                    Btn.n7,
                    Btn.n8,
                    Btn.n9,
                    Btn.del,
                    Btn.clr
                  ].contains(value)
                      ? GoogleFonts.comfortaa(textStyle: buttonTextStyle)
                      : GoogleFonts.urbanist(textStyle: buttonTextStyle),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void appendValue(String value) {
    // number1 operand number2
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      //////// number2.empty ||
      // 23 + .
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    } else if (value == Btn.clr) {
      clear();
      return;
    } else if (value == Btn.per) {
      _mathPercentage();
      return;
    } else if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty || number2.isEmpty || operand.isEmpty) return;
    final num1 = double.parse(number1);
    final num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
    }
    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0"))
        number1 = number1.substring(0, number1.length - 2);
      operand = "";
      number2 = "";
    });
  }

  void _mathPercentage() {
    if (number1.isNotEmpty && number2.isNotEmpty && operand.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void clear() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
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