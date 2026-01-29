import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// SSL Pinning implementation for secure API communication
/// This class provides certificate pinning to prevent man-in-the-middle attacks
class HttpSSLPinning {
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await createLEClient();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }

  /// Creates an HTTP client with SSL pinning enabled
  /// Loads the pinned certificate from assets and validates against it
  static Future<http.Client> createLEClient() async {
    // Load the pinned certificate from assets
    final sslCert = await rootBundle.load('assets/certificates/themoviedb.pem');

    // Create a SecurityContext WITHOUT system trusted roots
    // This ensures ONLY our pinned certificate is trusted
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);

    // Set the trusted certificate - ONLY this certificate will be accepted
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    // Create HttpClient with the pinned certificate
    HttpClient httpClient = HttpClient(context: securityContext);

    // Strict certificate validation - reject any certificate not matching our pinned cert
    // This is the core of SSL pinning: if the server presents a different certificate,
    // the connection will FAIL
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          // Always return false - never accept bad certificates
          return false;
        };

    return IOClient(httpClient);
  }
}
