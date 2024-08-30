import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(TTSApp());
}

class TTSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        hintColor: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      home: TTSHomePage(),
    );
  }
}

class TTSHomePage extends StatefulWidget {
  @override
  _TTSHomePageState createState() => _TTSHomePageState();
}

class _TTSHomePageState extends State<TTSHomePage> {
  String selectedLanguage = 'en-US';
  final TextEditingController textController = TextEditingController();

  // List of language names and codes
  final List<Map<String, String>> languages = [
    {'name': 'English (US)', 'code': 'en-US'},
    {'name': 'English (UK)', 'code': 'en-GB'},
    {'name': 'Spanish', 'code': 'es-ES'},
    {'name': 'French', 'code': 'fr-FR'},
    {'name': 'German', 'code': 'de-DE'},
    {'name': 'Japanese', 'code': 'ja-JP'},
    {'name': 'Chinese (Mandarin)', 'code': 'zh-CN'},
    {'name': 'Portuguese (Portugal)', 'code': 'pt-PT'},
    {'name': 'Portuguese (Brazil)', 'code': 'pt-BR'},
    {'name': 'Russian', 'code': 'ru-RU'},
    {'name': 'Korean', 'code': 'ko-KR'},
    {'name': 'Italian', 'code': 'it-IT'},
    {'name': 'Dutch', 'code': 'nl-NL'},
    {'name': 'Swedish', 'code': 'sv-SE'},
    {'name': 'Norwegian', 'code': 'no-NO'},
    {'name': 'Finnish', 'code': 'fi-FI'},
    {'name': 'Danish', 'code': 'da-DK'},
    {'name': 'Arabic', 'code': 'ar-SA'},
    {'name': 'Hindi', 'code': 'hi-IN'},
    {'name': 'Bengali', 'code': 'bn-BD'},
    {'name': 'Turkish', 'code': 'tr-TR'},
    {'name': 'Greek', 'code': 'el-GR'},
    {'name': 'Hebrew', 'code': 'he-IL'},
    {'name': 'Thai', 'code': 'th-TH'},
    {'name': 'Polish', 'code': 'pl-PL'},
    {'name': 'Hungarian', 'code': 'hu-HU'},
    {'name': 'Czech', 'code': 'cs-CZ'},
    {'name': 'Romanian', 'code': 'ro-RO'},
    {'name': 'Vietnamese', 'code': 'vi-VN'},
    {'name': 'Indonesian', 'code': 'id-ID'},
  ];

  List<String> savedFilesNames = [];
  List<String> savedFilesText = [];

  void _speak(String text) {
    final speechSynthesis = html.window.speechSynthesis;
    final utterance = html.SpeechSynthesisUtterance(text)
      ..lang = selectedLanguage
      ..rate = 1.0
      ..pitch = 1.0;

    speechSynthesis?.speak(utterance);
  }

  void _download(String text) {
    final blob = html.Blob(
        [text]); // Placeholder: Replace with actual audio data if available
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '${DateTime.now().millisecondsSinceEpoch}.mp3')
      ..click();

    html.Url.revokeObjectUrl(url);

    setState(() {
      savedFilesNames.add('${DateTime.now().millisecondsSinceEpoch}.mp3');
      savedFilesText.add(text);
    });
  }

  void _speakAndDownload(String text) {
    _speak(text);
    _download(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter TTS'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                items: languages.map<DropdownMenuItem<String>>(
                    (Map<String, String> language) {
                  return DropdownMenuItem<String>(
                    value: language['code'],
                    child: Text(language['name']!),
                  );
                }).toList(),
                dropdownColor: Colors.deepPurple,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.amber,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: textController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  labelStyle: TextStyle(color: Colors.amber),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final text = textController.text;
                if (text.isNotEmpty) {
                  _speakAndDownload(text);
                }
              },
              child: Text('Speak'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                backgroundColor: Colors.amber,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: savedFilesNames.length,
                itemBuilder: (context, index) {
                  final fileName = savedFilesNames[index];
                  final fileText = savedFilesText[index];
                  return ListTile(
                    title: Text(fileName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.play_arrow, color: Colors.amber),
                          onPressed: () {
                            _speak(fileText);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.download, color: Colors.amber),
                          onPressed: () {
                            final url = html.Url.createObjectUrlFromBlob(
                                html.Blob([fileText]));
                            final anchor = html.AnchorElement(href: url)
                              ..setAttribute('download', fileName)
                              ..click();
                            html.Url.revokeObjectUrl(url);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
