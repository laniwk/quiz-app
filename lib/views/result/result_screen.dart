import 'package:flutter/material.dart';
import '/core/constants/route_names.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    Key? key,
    required this.correctAnswers,
    required this.questionsLength,
  }) : super(key: key);

  final int correctAnswers;
  final int questionsLength;

  void _goBackToCategories(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(RouteNames.categories));
  }

  double get _score => (correctAnswers / questionsLength) * 100;

  List<Widget> get _stars {
    final howManyCorrect = _score ~/ 10;
    final hoManyCorrectStars = List<Widget>.filled(
      correctAnswers,
      const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
    final howManyWrong = 10 - howManyCorrect;
    final howManyWrongStars = List<Widget>.filled(
      howManyWrong,
      const Icon(
        Icons.star_border_outlined,
        color: Colors.amber,
      ),
    );
    return [...hoManyCorrectStars,...howManyWrongStars];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goBackToCategories(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () => _goBackToCategories(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.pinkAccent,
            ),
          ),
          title: const Text(
            'Hasil',
            style: TextStyle(color: Colors.pinkAccent),
          ),
        ),
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Jumlah Soal',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  questionsLength.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Divider(),
                const Text(
                  'Jawaban Benar',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  correctAnswers.toString(),
                  style: TextStyle(
                    color: Colors.greenAccent[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Divider(),
                const Text(
                  'Jawaban Salah',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${questionsLength - correctAnswers}',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Divider(),
                const Text(
                  'Skor',
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    ..._stars,
                    Text(
                      _score.toStringAsFixed(0),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ElevatedButton.icon(
                  onPressed: () => _goBackToCategories(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  label: const Icon(Icons.exit_to_app),
                  icon: const Text('Kembali Ke Kategori'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
