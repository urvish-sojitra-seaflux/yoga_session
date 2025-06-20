import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class YogaScreen extends StatefulWidget {
  const YogaScreen({super.key});

  @override
  State<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  final _formKey = GlobalKey<FormState>();
  int _rounds = 3;
  int _inhale = 4;
  int _hold = 4;
  int _exhale = 4;
  bool _sessionStarted = false;
  int _currentRound = 1;
  String _phase = '';
  int _timeLeft = 0;
  Timer? _timer;
  final FlutterTts _tts = FlutterTts();

  Future _speak(String text) async {
    await _tts.speak(text);
  }

  void _startSession() {
    setState(() {
      _sessionStarted = true;
      _currentRound = 1;
    });
    _startRound();
  }

  void _startRound() async {
    await _speak('Round $_currentRound start');
    _startPhase('Inhale', _inhale, () async {
      _startPhase('Hold', _hold, () async {
        _startPhase('Exhale', _exhale, () async {
          if (_currentRound < _rounds) {
            await _speak('Round $_currentRound complete');
            _startPhase('Pause for 10 seconds', 10, () {
              setState(() {
                _currentRound++;
              });
              _startRound();
            });
          } else {
            _speak('All rounds complete');
            setState(() {
              _sessionStarted = false;
            });
          }
        });
      });
    });
  }

  void _startPhase(String phase, int seconds, VoidCallback onComplete) {
    setState(() {
      _phase = phase;
      _timeLeft = seconds;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        onComplete();
      }
    });
    _speak(phase);
  }

  @override
  void initState() {
    super.initState();
    _setFemaleVoice();
  }

  Future<void> _setFemaleVoice() async {
    List<dynamic> voices = await _tts.getVoices;
    // Try to find a female English voice
    final femaleVoice = voices.firstWhere(
      (v) =>
          ((v['gender']?.toString().toLowerCase() == 'female')) &&
          (v['locale']?.toString().toLowerCase().contains('en-US') ?? false),
      orElse: () => null,
    );
    final femaleVoices = voices
        .where((v) =>
            ((v['gender']?.toString().toLowerCase() == 'female')) &&
            (v['locale']?.toString().toLowerCase().contains('en-US') ?? false))
        .toList();
    print(femaleVoices);
    if (femaleVoice != null) {
      final Map<String, String> stringVoice = Map.fromEntries(
        (femaleVoice as Map)
            .entries
            .where((e) => e.key is String && e.value is String)
            .map((e) => MapEntry(e.key as String, e.value as String)),
      );

      await _tts.setVoice(stringVoice);
    } else {
      // fallback: set language to English and hope for female default
      await _tts.setLanguage('en-US');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yoga Session')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            color: Colors.grey[200],
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth < 600 ? 400 : 600,
            ),
            child: _sessionStarted ? _sessionWidget(context) : _getDetails(),
          );
        },
      ),
    );
  }

  Column _sessionWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Round $_currentRound / $_rounds',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(_phase, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text('$_timeLeft s', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF232526), // dark grey
                Color(0xFF414345), // darker grey
                Color(0xFF000000), // black
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              _timer?.cancel();
              setState(() {
                _sessionStarted = false;
              });
            },
            child: const Text(
              'Stop Session',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Form _getDetails() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _rounds.toString(),
            decoration: commonInputDecoration('Rounds'),
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || int.tryParse(v) == null || int.parse(v) < 1)
                    ? 'Enter valid rounds'
                    : null,
            onSaved: (v) => _rounds = int.parse(v!),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _inhale.toString(),
            decoration: commonInputDecoration('Inhale seconds'),
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || int.tryParse(v) == null || int.parse(v) < 1)
                    ? 'Enter valid seconds'
                    : null,
            onSaved: (v) => _inhale = int.parse(v!),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _hold.toString(),
            decoration: commonInputDecoration('Hold seconds'),
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || int.tryParse(v) == null || int.parse(v) < 0)
                    ? 'Enter valid seconds'
                    : null,
            onSaved: (v) => _hold = int.parse(v!),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _exhale.toString(),
            decoration: commonInputDecoration('Exhale seconds'),
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || int.tryParse(v) == null || int.parse(v) < 1)
                    ? 'Enter valid seconds'
                    : null,
            onSaved: (v) => _exhale = int.parse(v!),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF232526), // dark grey
                  Color(0xFF414345), // darker grey
                  Color(0xFF000000), // black
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _startSession();
                }
              },
              child: const Text(
                'Start Session',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration commonInputDecoration(String label) {
    return InputDecoration(
      fillColor: Colors.white,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2, color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2, color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2, color: Colors.blue),
      ),
    );
  }
}
