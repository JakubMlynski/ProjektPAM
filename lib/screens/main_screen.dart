import 'package:flutter/material.dart';
import 'generic_list_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/mtgicon.png', height: 100),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, 'Karty', true),
                SizedBox(width: 20),
                _buildButton(context, 'Sety', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, bool isCards) {
    return Material(
      color: Color(0xFF2B2B2B),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GenericListScreen(isCards: isCards))),
        child: Container(
          width: 140, height: 140, alignment: Alignment.center,
          child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}