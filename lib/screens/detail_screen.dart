import 'dart:convert';

import 'package:fasum1/l10n/app_localizations.dart';
import 'package:fasum1/screens/full_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.imageBase64,
    required this.description,
    required this.createdAt,
    required this.fullName,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.heroTag,
  });

  final String imageBase64;
  final String description;
  final DateTime createdAt;
  final String fullName;
  final double latitude;
  final double longitude;
  final String category;
  final String heroTag;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void> openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}',
    );
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.unableToOpenMaps)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final createdAtFormatted = DateFormat(
      'dd MMMM yyyy, HH:mm',
      localizations.localeName, // supaya format tanggal sesuai locale
    ).format(widget.createdAt);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.reportDetail)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: Image.memory(
                    base64Decode(widget.imageBase64),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FullscreenImageScreen(
                                imageBase64: widget.imageBase64,
                              ),
                        ),
                      );
                    },
                    tooltip: localizations.viewFullImage,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kiri: Kategori & Waktu
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  // Ambil kategori terjemahan sesuai key ARB
                                  localizationsCategory(
                                    widget.category,
                                    localizations,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  createdAtFormatted,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Kanan: Icon map
                      IconButton(
                        onPressed: openMap,
                        icon: const Icon(
                          Icons.map,
                          size: 38,
                          color: Colors.lightGreen,
                        ),
                        tooltip: localizations.openInGoogleMaps,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fungsi untuk mapping kategori dari key ke terjemahan yang ada di ARB.
/// Contoh key: "categoryJalanRusak", value: "Damaged Road"
String localizationsCategory(
  String categoryKey,
  AppLocalizations localizations,
) {
  switch (categoryKey) {
    case 'categoryJalanRusak':
      return localizations.categoryJalanRusak;
    case 'categoryMarkaPudar':
      return localizations.categoryMarkaPudar;
    case 'categoryLampuMati':
      return localizations.categoryLampuMati;
    case 'categoryTrotoarRusak':
      return localizations.categoryTrotoarRusak;
    case 'categoryRambuRusak':
      return localizations.categoryRambuRusak;
    case 'categoryJembatanRusak':
      return localizations.categoryJembatanRusak;
    case 'categorySampahMenumpuk':
      return localizations.categorySampahMenumpuk;
    case 'categorySaluranTersumbat':
      return localizations.categorySaluranTersumbat;
    case 'categorySungaiTercemar':
      return localizations.categorySungaiTercemar;
    case 'categorySampahSungai':
      return localizations.categorySampahSungai;
    case 'categoryPohonTumbang':
      return localizations.categoryPohonTumbang;
    case 'categoryTamanRusak':
      return localizations.categoryTamanRusak;
    case 'categoryFasilitasRusak':
      return localizations.categoryFasilitasRusak;
    case 'categoryPipaBocor':
      return localizations.categoryPipaBocor;
    case 'categoryVandalisme':
      return localizations.categoryVandalisme;
    case 'categoryBanjir':
      return localizations.categoryBanjir;
    case 'categoryLainnya':
      return localizations.categoryLainnya;
    default:
      return categoryKey; // fallback: tampilkan apa adanya
  }
}
