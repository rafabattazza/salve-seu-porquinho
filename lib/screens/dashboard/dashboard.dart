import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/components/question_dialog.dart';
import 'package:salveSeuPorquinho/screens/dashboard/components/dashboard_footer.dart';
import 'package:salveSeuPorquinho/screens/dashboard/report/reports.dart';
import 'package:salveSeuPorquinho/screens/dashboard/resume/resume.dart';
import 'package:salveSeuPorquinho/screens/welcome.dart';

import 'entries/entries.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedTab = 0;
  static const _EXIT_MESSAGE = "Deseja realmente sair?";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await QuestionDialog.showQuestion(context, _EXIT_MESSAGE)) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return WelcomeScreen();
          }));
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: _createBody(),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50.0,
            child: DashboardFooter(selectedTab, (tab) {
              setState(() {
                selectedTab = tab;
              });
            }),
          ),
        ),
      ),
    );
  }

  Widget _createBody() {
    if (selectedTab == 0) {
      return ResumeScreen();
    } else if (selectedTab == 1) {
      return EntriesScreen();
    } else {
      return ReportsScreen();
    }
  }
}
