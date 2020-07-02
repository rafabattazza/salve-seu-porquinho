import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:salveSeuPorquinho/utils/utils.dart';

class DashboardItem extends StatelessWidget {
  final String text;
  final double budget;
  final double spent;

  final bool showAdd;
  const DashboardItem(
    this.text,
    this.budget,
    this.spent, {
    this.showAdd = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 72,
      decoration: BoxDecoration(
        color: Color(0xFF12121A),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(text),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              Utils.numberFormat.format(budget),
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text(
                              "Previsto",
                              style: ThemeUtils.thinText.copyWith(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      Text(' - '),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(children: <Widget>[
                          Text(
                            Utils.numberFormat.format(spent),
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            "Gasto",
                            style: ThemeUtils.thinText.copyWith(fontSize: 12),
                          )
                        ]),
                      ),
                      Text(' = '),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(children: <Widget>[
                          Text(
                            Utils.numberFormat.format(budget - spent),
                            style: TextStyle(
                                color: budget - spent < 0
                                    ? Colors.red
                                    : Colors.green),
                          ),
                          Text(
                            "Saldo",
                            style: ThemeUtils.thinText.copyWith(fontSize: 12),
                          )
                        ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (showAdd) ...[
              VerticalDivider(),
              InkWell(
                child: Center(
                    child: Icon(
                  Icons.add,
                  size: 32,
                )),
                onTap: () {
                  print("a");
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
