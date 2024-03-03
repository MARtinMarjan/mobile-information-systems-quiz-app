import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/screens/sounds/platform_options.dart';
import 'package:soundpool/soundpool.dart';

class SoundpoolInitializer extends StatefulWidget {
  const SoundpoolInitializer({super.key});

  @override
  _SoundpoolInitializerState createState() => _SoundpoolInitializerState();
}

class _SoundpoolInitializerState extends State<SoundpoolInitializer> {
  Soundpool? _pool;
  SoundpoolOptions _soundpoolOptions = const SoundpoolOptions();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initPool(_soundpoolOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pool == null) {
      return Material(
        child: Center(
          child: ElevatedButton(
            onPressed: () => _initPool(_soundpoolOptions),
            child: const Text("Init Soundpool"),
          ),
        ),
      );
    } else {
      return SimpleApp(
        pool: _pool!,
        onOptionsChange: _initPool,
      );
    }
  }

  void _initPool(SoundpoolOptions soundpoolOptions) {
    _pool?.dispose();
    setState(() {
      _soundpoolOptions = soundpoolOptions;
      _pool = Soundpool.fromOptions(options: _soundpoolOptions);
      print('pool updated: $_pool');
    });
  }
}

class SimpleApp extends StatefulWidget {
  final Soundpool pool;
  final ValueSetter<SoundpoolOptions> onOptionsChange;
  const SimpleApp({super.key, required this.pool, required this.onOptionsChange});

  @override
  _SimpleAppState createState() => _SimpleAppState();
}

class _SimpleAppState extends State<SimpleApp> {
  int? _alarmSoundStreamId;
  int _cheeringStreamId = -1;

  String get _cheeringUrl => kIsWeb
      ? '/c-c-1.mp3'
      : 'https://raw.githubusercontent.com/ukasz123/soundpool/feature/web_support/example/web/c-c-1.mp3';

  Soundpool get _soundpool => widget.pool;

  @override
  void initState() {
    super.initState();

    _loadSounds();
  }

  void _loadSounds() {
    _soundId = _loadSound();
    _cheeringId = _loadCheering();
  }

  @override
  void didUpdateWidget(SimpleApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pool != widget.pool) {
      _loadSounds();
    }
  }

  double _volume = 1.0;
  double _rate = 1.0;
  late Future<int> _soundId;
  late Future<int> _cheeringId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final newOptions = await Navigator.of(context).push<
                    SoundpoolOptions>(
                    MaterialPageRoute(builder: (context) => const PlatformOptions()));
                if (newOptions != null) {
                  widget.onOptionsChange(newOptions);
                }
              },
              icon: const Icon(
                Icons.access_alarms,
              ))
        ],
      ),
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 450 : double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rolling dices'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _playSound,
                    child: const Text("Play"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _pauseSound,
                    child: const Text("Pause"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _stopSound,
                    child: const Text("Stop"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _playCheering,
                child: const Text("Play cheering"),
              ),
              const SizedBox(height: 4),
              const Text('Set rate '),
              Row(children: [
                Expanded(
                  child: Slider.adaptive(
                    min: 0.5,
                    max: 2.0,
                    value: _rate,
                    onChanged: (newRate) {
                      setState(() {
                        _rate = newRate;
                      });
                      _updateCheeringRate();
                    },
                  ),
                ),
                Text(_rate.toStringAsFixed(3)),
              ]),
              const SizedBox(height: 8.0),
              const Text('Volume'),
              Slider.adaptive(
                  value: _volume,
                  onChanged: (newVolume) {
                    setState(() {
                      _volume = newVolume;
                    });
                    _updateVolume(newVolume);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load('assets/sounds/success.mp3');
    return await _soundpool.load(asset);
  }

  Future<int> _loadCheering() async {
    return await _soundpool.loadUri(_cheeringUrl);
  }

  Future<void> _playSound() async {
    var alarmSound = await _soundId;
    _alarmSoundStreamId = await _soundpool.play(alarmSound);
  }

  Future<void> _pauseSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool.pause(_alarmSoundStreamId!);
    }
  }

  Future<void> _stopSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool.stop(_alarmSoundStreamId!);
    }
  }

  Future<void> _playCheering() async {
    var sound = await _cheeringId;
    _cheeringStreamId = await _soundpool.play(
      sound,
      rate: _rate,
    );
  }

  Future<void> _updateCheeringRate() async {
    if (_cheeringStreamId > 0) {
      await _soundpool.setRate(
          streamId: _cheeringStreamId, playbackRate: _rate);
    }
  }

  Future<void> _updateVolume(newVolume) async {
    // if (_alarmSound >= 0){
    var cheeringSound = await _cheeringId;
    _soundpool.setVolume(soundId: cheeringSound, volume: newVolume);
    // }
  }
}