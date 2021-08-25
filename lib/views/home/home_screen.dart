import 'package:flutter/material.dart';
import '/core/constants/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onStartTapped() {
    Navigator.of(context).pushNamed(RouteNames.categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.40,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(
                radius: 80,
                child: CircleAvatar(
                  radius: 78,
                  backgroundColor: Colors.white,
                  child: Text(
                    'MAGO',
                    style: TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 45,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Matematika Jago',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontFamily: 'Caveat',
                  fontSize: 35,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _onStartTapped,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.pinkAccent,
                  shadowColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ), /* Stack(
        alignment: Alignment.center,
        children: [
          Align(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 60,
              width: MediaQuery.of(context).size.width + 60,
              child: Image.asset(
                'assets/images/home.jpeg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: _onStartTapped,
                style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ), */
    );
  }
}
          // Container(
          //   alignment: Alignment.bottomCenter,
          //   padding: const EdgeInsets.all(20),
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height * 0.5,
          //     width: MediaQuery.of(context).size.width,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         // Container(
          //         //   alignment: Alignment.center,
          //         //   height: 100,
          //         //   decoration: BoxDecoration(
          //         //     color: Colors.grey[50],
          //         //     borderRadius: const BorderRadius.all(Radius.circular(16)),
          //         //   ),
          //         //   child: const Text(
          //         //     'Matematika Jago',
          //         //     textAlign: TextAlign.center,
          //         //     style: TextStyle(
          //         //       color: Colors.pinkAccent,
          //         //       fontSize: 40,
          //         //       fontWeight: FontWeight.bold,
          //         //     ),
          //         //   ),
          //         // ),
          //         ElevatedButton(
          //           onPressed: _onStartTapped,
          //           style: ElevatedButton.styleFrom(
          //             primary: Colors.pinkAccent,
          //             shape: const RoundedRectangleBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(16)),
          //             ),
          //             minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
          //           ),
          //           child: const Text(
          //             'START',
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),