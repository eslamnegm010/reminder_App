import 'package:flutter/material.dart';
import 'package:smart_draft/smart_draft.dart';

void main() {
  runApp(const SmartDraftTestApp());
}

class SmartDraftTestApp extends StatelessWidget {
  const SmartDraftTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDraft Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const LandingPage(),
    );
  }
}

/// ─── 1. Landing Page ───
/// A clean landing page with no SmartDraft or TextFields.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartDraft Demo'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.drafts_outlined, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              Text(
                'Welcome to SmartDraft',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'This demo tests multi-page persistence and draft clearing.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PageA()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Start Profile Setup'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Settings clicked')));
                },
                icon: const Icon(Icons.settings),
                label: const Text('Open Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─── 2. Page A: Personal Info ───
/// Wraps body in SmartDraft (id: registration_step_1).
class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 1: Personal Info')),
      body: SmartDraft(
        id: 'registration_step_1',
        child: Builder(
          builder: (innerContext) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Enter your basic details. These are saved automatically.'),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () {
                      debugPrint('SmartDraft: Navigating to Page B');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PageB()),
                      );
                    },
                    child: const Text('Next Step'),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () async {
                      debugPrint(
                        'SmartDraft: Clearing registration_step_1 via Builder context',
                      );
                      await SmartDraft.clear(innerContext);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Step 1 Draft Cleared')),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Clear This Page'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ─── 3. Page B: Professional Info ───
/// Wraps body in SmartDraft (id: registration_step_2).
class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 2: Professional Info')),
      body: SmartDraft(
        id: 'registration_step_2',
        child: Builder(
          builder: (innerContext) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Tell us about your work. Also saved automatically.'),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Job Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Years of Experience',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timeline),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () async {
                      debugPrint('SmartDraft: Simulating API Submit...');
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );

                      // Simulate 2-second delay
                      await Future.delayed(const Duration(seconds: 2));

                      // Clear both drafts
                      debugPrint('SmartDraft: Clearing registration_step_2 via context');
                      await SmartDraft.clear(innerContext);

                      debugPrint(
                        'SmartDraft: Clearing registration_step_1 via clearById',
                      );
                      // Use clearById to clear Page A's draft — if the widget
                      // is still mounted (back-stack), controllers are also
                      // cleared. Otherwise, only storage is wiped.
                      await SmartDraft.clearById('registration_step_1');

                      if (context.mounted) {
                        Navigator.pop(context); // Close loading dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration Finished & All Drafts Cleared!'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                        // Go back to Landing Page
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                    child: const Text('Submit & Finish'),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () async {
                      debugPrint(
                        'SmartDraft: Clearing registration_step_2 via Builder context',
                      );
                      await SmartDraft.clear(innerContext);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Step 2 Draft Cleared')),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Clear This Page'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
