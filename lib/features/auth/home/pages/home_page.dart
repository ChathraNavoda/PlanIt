import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planit/core/constants/utils.dart';
import 'package:planit/features/auth/home/widgets/date_selector.dart';
import 'package:planit/features/auth/home/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => HomePage());

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tasks"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          DateSelector(),
          Row(
            children: [
              Expanded(
                child: TaskCard(
                  color: const Color.fromARGB(246, 156, 148, 199),
                  headerText: 'Hell',
                  descriptionText:
                      'This is my first task. This is my first task. This is my first task. This is my first task. This is my first task. This is my first task. This is my first task.',
                ),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: strengthenColor(
                      const Color.fromARGB(246, 156, 148, 199), 0.69),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  '10.00AM',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
