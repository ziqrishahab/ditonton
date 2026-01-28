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
  /// Loads the pinned certificates from assets and validates against them
  /// Uses both leaf certificate and root CA for reliable pinning
  static Future<http.Client> createLEClient() async {
    // Load the pinned certificates from assets
    // Leaf certificate for themoviedb.org
    final leafCert = await rootBundle.load('assets/certificates/themoviedb.pem');
    // Amazon Root CA for certificate chain validation
    final rootCert = await rootBundle.load('assets/certificates/amazon_root_ca.pem');
    
    // Create a SecurityContext WITHOUT system trusted roots
    // This ensures ONLY our pinned certificates are trusted
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    
    // Add both certificates to trusted store
    securityContext.setTrustedCertificatesBytes(leafCert.buffer.asUint8List());
    securityContext.setTrustedCertificatesBytes(rootCert.buffer.asUint8List());

    // Create HttpClient with the pinned certificates
    HttpClient httpClient = HttpClient(context: securityContext);
    
    // Strict certificate validation - reject any certificate not in our trusted store
    // This is the core of SSL pinning: if the server presents a certificate
    // that doesn't chain to our pinned certificates, the connection FAILS
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // Always return false - never accept bad certificates
      // A "bad certificate" here means one not validated by our pinned certs
      return false;
    };

    return IOClient(httpClient);
  }
}
