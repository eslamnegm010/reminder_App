import 'package:url_launcher/url_launcher.dart';

Future<void> launchEmail({required String email, String subject = 'App Feedback'}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: 'subject=${Uri.encodeQueryComponent(subject)}',
  );

  final bool launched = await launchUrl(
    emailLaunchUri,
    mode: LaunchMode.externalApplication,
  );

  if (!launched) {
    throw Exception('Could not launch email app');
  }
}

Future<void> launchURL({required String url}) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
