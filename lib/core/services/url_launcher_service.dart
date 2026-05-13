import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

abstract class UrlLauncherService {
  static Future<void> launchExternalUrl(String url) async {
    // Normalize: add https:// if the URL has no scheme (e.g. "www.facebook.com")
    final normalized = url.contains('://') ? url : 'https://$url';
    final uri = Uri.parse(normalized);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      log('launchExternalUrl failed: $e');
    }
  }

  static Future<void> launchWhatsApp(String phone) async {
    final sanitized = phone.replaceAll(RegExp(r'[\s+\-()]'), '');
    await launchExternalUrl('https://wa.me/$sanitized');
  }

  static Future<void> launchEmail(String email) async {
    await launchUrl(Uri.parse('mailto:$email'), mode: LaunchMode.externalApplication);
  }

  static Future<void> launchMaps(String address) async {
    final encoded = Uri.encodeComponent(address);
    await launchExternalUrl('https://maps.google.com/?q=$encoded');
  }

  static Future<void> launchCall(String phone) async {
    final sanitized = phone.replaceAll(RegExp(r'[\s+\-()]'), '');
    await launchUrl(Uri.parse('tel:$sanitized'), mode: LaunchMode.externalApplication);
  }
}
