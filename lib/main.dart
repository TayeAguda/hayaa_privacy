import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';


void main() {
  usePathUrlStrategy(); 
  runApp(const LegalWebsiteApp());
}

class LegalWebsiteApp extends StatelessWidget {
  const LegalWebsiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hayaa Legal Information',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3498db)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/privacy': (context) => const DocumentScreen(
              title: 'Privacy Policy',
              assetPath: 'assets/privacy_policy.html',
            ),
        '/terms': (context) => const DocumentScreen(
              title: 'Terms & Conditions',
              assetPath: 'assets/term_and_conditions.html',
            ),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hayaa Mobile Application'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please review our legal documents and policies below.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 280,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/privacy'),
                  icon: const Icon(Icons.privacy_tip),
                  label: const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 280,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/terms'),
                  icon: const Icon(Icons.description),
                  label: const Text(
                    'Terms & Conditions',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final String title;
  final String assetPath;

  const DocumentScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading document.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Html(
                  data: snapshot.data,
                  style: {
                    "body": Style(
                      fontSize: FontSize(16.0),
                      lineHeight: LineHeight(1.6),
                      color: Colors.black87,
                    ),
                    "h1": Style(
                      fontSize: FontSize(28.0),
                      margin: Margins.only(bottom: 16.0),
                    ),
                    "h2": Style(
                      fontSize: FontSize(22.0),
                      margin: Margins.only(top: 24.0, bottom: 8.0),
                      color: const Color(0xFF2C3E50),
                    ),
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
