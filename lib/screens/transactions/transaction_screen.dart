import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuAppController.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../main/components/side_menu.dart';
import '../dashboard/components/header.dart';

class TransactionScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return Header(); // Now 'context' includes the provider.
                      },
                    ),

                    SizedBox(height: defaultPadding),
                    Center(
                      child: Text(
                        "Transaction Page",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
