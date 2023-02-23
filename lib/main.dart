import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          title: Text('IoT Smart Farm'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Row(
                  children: <Widget>[
                    BoxWidget(
                      color: Colors.blue,
                      percent: 0.75,
                      title: 'SOIL MOISTURE',
                    ),
                    BoxWidget(
                      color: Colors.green,
                      percent: 0.25,
                      title: 'SOIL TEMPERATURE',
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                Row(
                  children: <Widget>[
                    BoxWidget(
                      color: Colors.red,
                      percent: 0.50,
                      title: 'AIR TEMPERATURE',
                    ),
                    BoxWidget(
                      color: Colors.orange,
                      percent: 0.90,
                      title: 'AIR HUMIDITY',
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'PUMP STATUS',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 16.0),
                    Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BoxWidget extends StatefulWidget {
  final Color color;
  final double percent;
  final String title;

  BoxWidget({required this.color, required this.percent, required this.title});

  @override
  State<BoxWidget> createState() => _BoxWidgetState();
}

class _BoxWidgetState extends State<BoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 16.0),
              CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 10.0,
                percent: widget.percent,
                center: Text(
                  '${(widget.percent * 100).toInt()}%',
                  style: TextStyle(fontSize: 18.0),
                ),
                progressColor: widget.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
