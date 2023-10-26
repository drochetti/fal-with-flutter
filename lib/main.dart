import 'package:fal_with_flutter/client/client.dart';
import 'package:fal_with_flutter/client/config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const DEFAULT_PROMPT =
    'a city landscape of a cyberpunk metropolis, raining, purple, pink and teal neon lights, highly detailed, uhd';

final fal =
    FalClient(config: Config(proxyUrl: 'http://localhost:3333/api/_fal/proxy'));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter with fal.ai',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TextToImageScreen(),
    );
  }
}

class TextToImageScreen extends StatefulWidget {
  const TextToImageScreen({super.key});

  @override
  _TextToImageScreenState createState() => _TextToImageScreenState();
}

class _TextToImageScreenState extends State<TextToImageScreen> {
  bool _isLoading = false;
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('fal.ai/text-to-image'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _fetchImage,
            child: const Text('Fetch Image'),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          if (!_isLoading && _imageUrl != null) Image.network(_imageUrl!),
        ],
      ),
    );
  }

  Future<void> _fetchImage() async {
    setState(() {
      _isLoading = true;
    });

    final result = await fal.subscribe('110602490-lora', input: {
      'prompt': DEFAULT_PROMPT,
      'model_name': 'stabilityai/stable-diffusion-xl-base-1.0',
      'image_size': 'square_hd',
    });

    setState(() {
      _isLoading = false;
      _imageUrl = result['images'][0]['url'];
    });
  }
}
