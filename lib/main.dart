import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const LegalWebsiteApp());
}

class LegalWebsiteApp extends StatelessWidget {
  const LegalWebsiteApp({super.key});

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (BuildContext context, GoRouterState state) =>
            const DocumentScreen(
              title: 'Privacy Policy',
              assetPath: 'assets/privacy_policy.html',
            ),
      ),
      GoRoute(
        path: '/terms',
        builder: (BuildContext context, GoRouterState state) =>
            const DocumentScreen(
              title: 'Terms & Conditions',
              assetPath: 'assets/term_and_conditions.html',
            ),
      ),
      GoRoute(
        path: '/child-safety',
        builder: (BuildContext context, GoRouterState state) =>
            const DocumentScreen(
              title: 'Child Safety Standards',
              assetPath: 'assets/child_safety.html',
            ),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        NotFoundScreen(path: state.uri.toString()),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Hayaa Legal Information',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A7B79)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFE6F4F3), Color(0xFFF8FBFB)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hayaa Legal Center',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please review our legal documents below.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: () => context.go('/privacy'),
                            icon: const Icon(Icons.privacy_tip_outlined),
                            label: const Text('Privacy Policy'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => context.go('/terms'),
                            icon: const Icon(Icons.description_outlined),
                            label: const Text('Terms & Conditions'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => context.go('/child-safety'),
                            icon: const Icon(Icons.child_care_outlined),
                            label: const Text('Child Safety Standards'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
            label: const Text('Home'),
          ),
          const SizedBox(width: 8),
        ],
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
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

class NotFoundScreen extends StatelessWidget {
  final String path;

  const NotFoundScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 52),
              const SizedBox(height: 16),
              const Text(
                'The requested page is not available.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                path,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
