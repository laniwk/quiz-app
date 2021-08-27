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

  double get _scoreInHundreds => (correctAnswers / questionsLength) * 100;

  List<Widget> get _stars {
    const maxStars = 5;
    final score = (correctAnswers / questionsLength) * maxStars;
    final halfStar = ((score * 2) % 2).toInt();
    final fullStars = (score - (halfStar * 0.5)).toInt();
    final emptyStars = maxStars - fullStars - halfStar;
    final fullStarIcons = List<Widget>.filled(
      fullStars,
      const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
    final halfStarIcons = List<Widget>.filled(
      halfStar,
      const Icon(
        Icons.star_half,
        color: Colors.amber,
      ),
    );
    final emptyStarIcons = List<Widget>.filled(
      emptyStars,
      const Icon(
        Icons.star_border_outlined,
        color: Colors.amber,
      ),
    );
    return [...fullStarIcons, ...halfStarIcons, ...emptyStarIcons];
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
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).size.height * 0.25,
            20,
            10,
          ),
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
                    _scoreInHundreds.toStringAsFixed(0),
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
    );
  }
}
