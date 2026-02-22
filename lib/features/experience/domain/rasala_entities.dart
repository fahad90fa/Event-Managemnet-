import 'package:equatable/equatable.dart';

class CeremonyTradition extends Equatable {
  final String title;
  final String description;
  final String? culturalSignificance;
  final List<String>? photos;

  const CeremonyTradition({
    required this.title,
    required this.description,
    this.culturalSignificance,
    this.photos,
  });

  @override
  List<Object?> get props => [title, description, culturalSignificance, photos];
}

class RasalaGuide extends Equatable {
  final String id;
  final String ceremonyName; // Mehndi, Baraat, Walima
  final String ceremonyDate;
  final String venueName;
  final String description;
  final List<CeremonyTradition> traditions;
  final List<String> dos;
  final List<String> donts;
  final String? premiumBackgroundUrl;

  const RasalaGuide({
    required this.id,
    required this.ceremonyName,
    required this.ceremonyDate,
    required this.venueName,
    required this.description,
    required this.traditions,
    required this.dos,
    required this.donts,
    this.premiumBackgroundUrl,
  });

  @override
  List<Object?> get props => [
        id,
        ceremonyName,
        ceremonyDate,
        venueName,
        description,
        traditions,
        dos,
        donts,
        premiumBackgroundUrl
      ];
}
