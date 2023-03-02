import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:weather_icons/weather_icons.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override


  double _temperature = 0.0;
  double _soil_temperature = 0.0;
  double _soilMoisture = 0.0;
  double _humidity = 0.0;
  bool _pumpStatus = false;

  DatabaseReference sensorRef = FirebaseDatabase.instance.ref("Sensor");
  DatabaseReference motorRef = FirebaseDatabase.instance.ref("Motor");
  bool setDataDone = false;



  void getData() {
    setDataDone = true;
    motorRef.onValue.listen( (DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      print(data);
      setState(() {
        _pumpStatus = data["inOn"];
      });
    } );
    sensorRef.onValue.listen( (DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      print(data);
      setState(() {
        _temperature = data["temperature"] / 100;

        _humidity = data["humudity"] / 100;
        _soilMoisture = data["soil_moisture"] / 100;
        _soil_temperature = data["Soil_temperature"]/100;
      });
    } );
  }

  Widget build(BuildContext context) {

    if( !setDataDone ) {
      getData();

    }


    Future<void> _getData() async {


      // ref.child('Sensor').get();
      // final data = snapshot.value as Map<String, dynamic>;
      // setState(() {
      //   _temperature = data['temperature'];
      //   _soilMoisture = data['soil_moisture'];
      //   _humidity = data['humudity'];
      //   print(_temperature);
      // });
    }
/*

    () async{
      await _getData();
      print('fgyev');
    };*/

    void setData () async {
      print("asd");
    }

    @override
    initState() {
      super.initState();
      print("asd");

    }
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: Scaffold(

        appBar: AppBar(
          title: Text(
              'Farmitter',
            style: TextStyle(
              letterSpacing: 2.0,
            ),
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.lightGreen[400]
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: StreamBuilder(
                stream: FirebaseDatabase.instance.ref().onValue,
                builder:(context,AsyncSnapshot<DatabaseEvent>snapshot){
                  print(snapshot.connectionState);
                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!=null) {
                    final data = Map<dynamic, dynamic>.from(
                        (snapshot.data as DatabaseEvent).snapshot.value
                        as Map<dynamic, dynamic>);
                    var value = data['Sensor'];
                    // setState(() {


                      _temperature = value['temperature'] / 100;
                      _humidity = value['humudity'] / 100;
                      _soilMoisture = value['soil_moisture'] / 100;
                      var motor = data['Motor'];
                      _pumpStatus = motor['inOn'];
                    // });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Row(
                        children: <Widget>[
                          BoxWidget(
                            color: Colors.blue,
                            percent: _soilMoisture,
                            title: 'SOIL MOISTURE',
                              icon: Icons.water_drop
                          ),
                          BoxWidget(
                            color: Colors.green,
                            percent: _soil_temperature,
                            title: 'SOIL TEMPERATURE',
                              icon: Icons.thermostat,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),

                      Row(
                        children: <Widget>[
                          BoxWidget(
                            color: Colors.red,
                            percent: _temperature,
                            title: 'AIR TEMPERATURE',
                              icon: WeatherIcons.celsius,
                          ),
                          BoxWidget(
                            color: Colors.orange,
                            percent: _humidity,
                            title: 'AIR HUMIDITY',
                            icon: Icons.water_drop,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _pumpStatus ? 'MOTOR ON' : 'MOTOR OFF',
                            style: TextStyle(
                                fontSize: 16.0,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                          SizedBox(width: 16.0,),
                          Switch(
                            value: _pumpStatus,
                            activeColor: Colors.lightGreen,
                            onChanged: (value){
                              // setData();
                              () async {
                                print("äsd");
                                final snapshot = await motorRef.child("inOn").get();
                                final motorInOn = snapshot.value as bool;
                                // final motorInOn = object["inOn"];
                                // print(object);
                                await motorRef.update({
                                  "inOn": !motorInOn
                                });
                                setState(() {
                                  _pumpStatus = value;
                                });
                                // print(  );
                              }();
                            },
                          ),
                          SizedBox(width: 16.0,),

                        ],
                      )
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     Text(
                      //       'PUMP STATUS',
                      //       style: TextStyle(fontSize: 16.0),
                      //     ),
                      //     SizedBox(width: 16.0),
                      //     Switch(
                      //       value: _pumpStatus,
                      //       onChanged: (value) {},
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 16.0),
                      // FlatButton(
                      //   onPressed: (){},
                      //   child: Text("toggle"),
                      ,
                    ],
                  );
                }
            ),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: <Widget>[
            //
            //     Row(
            //       children: <Widget>[
            //         BoxWidget(
            //           color: Colors.blue,
            //           percent: _soilMoisture,
            //           title: 'SOIL MOISTURE',
            //         ),
            //         BoxWidget(
            //           color: Colors.green,
            //           percent: _temperature,
            //           title: 'SOIL TEMPERATURE',
            //         ),
            //       ],
            //     ),
            //     SizedBox(height: 16.0),
            //
            //     Row(
            //       children: <Widget>[
            //         BoxWidget(
            //           color: Colors.red,
            //           percent: 0.50,
            //           title: 'AIR TEMPERATURE',
            //         ),
            //         BoxWidget(
            //           color: Colors.orange,
            //           percent: _humidity,
            //           title: 'AIR HUMIDITY',
            //         ),
            //       ],
            //     ),
            //     SizedBox(height: 16.0),
            //
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Text(
            //           'PUMP STATUS',
            //           style: TextStyle(fontSize: 16.0),
            //         ),
            //         SizedBox(width: 16.0),
            //         Switch(
            //           value: true,
            //           onChanged: (value) {},
            //         ),
            //       ],
            //     ),
            //     SizedBox(height: 16.0),
            //   ],
            // ),
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
  final IconData icon;

  BoxWidget({required this.color, required this.percent, required this.title, required this.icon});

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
                style: TextStyle(fontSize: 13.0),
              ),
              SizedBox(height: 16.0),
              CircularPercentIndicator(
                radius: 75.0,
                lineWidth: 10.0,
                percent: widget.percent,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(widget.icon, color: Colors.black45, size: 25),
                    SizedBox(width: 10.0),
                    Text(
                      '${(widget.percent * 100).toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 18.0,
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
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
