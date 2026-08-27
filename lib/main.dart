import 'package:flutter/material.dart';
import 'dart:convert';
import 'services/tts_service.dart';
import 'screens/home_screen.dart';
import 'screens/flow_selection_screen.dart';
import 'screens/progress_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize TTS and load Teochew audio mapping
  final ttsService = TtsService();
  await ttsService.init();
  
  try {
    final audioJson = await DefaultAssetBundle.loadString('assets/audio/teochew/audio_mapping.json');
    final audioMap = jsonDecode(audioJson) as Map<String, dynamic>;
    ttsService.setTeochewAudioMap(audioMap);
  } catch (e) {
    debugPrint('Could not load Teochew audio mapping: $e');
  }
  
  runApp(const TeoLearnApp());
}

class TeoLearnApp extends StatelessWidget {
  const TeoLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeoLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE17076),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

/// Main navigation scaffold with bottom nav bar: Home, Flows, Progress.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FlowSelectionScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Flows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Progress',
          ),
        ],
        selectedItemColor: Color(0xFFE17076),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16,
        unselectedFontSize: 14,
      ),
    );
  }
}
