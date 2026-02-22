import 'package:equatable/equatable.dart';
import '../enums/marketplace_enums.dart';
import '../value_objects/marketplace_value_objects.dart';

/// Core business entity for the marketplace
class BusinessEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final BusinessCategory category;
  final List<String> subcategories;
  final BusinessType type;
  final GenderPolicy genderPolicy;
  final Location location;
  final ContactInfo contact;
  final PriceRange priceRange;
  final Rating rating;
  final bool isVerified;
  final bool hasPrivateRoom;
  final bool hasParking;
  final bool hasGenerator;
  final bool hasFemaleStaffOnly;
  final bool offersHomeService;
  final List<String> amenities;
  final AvailabilityCalendar availability;
  final List<ServicePackage> services;
  final Gallery gallery;
  final BusinessHours hours;
  final Policies policies;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? coverImage;
  final String? logoUrl;
  final int responseTimeMinutes;
  final bool hasDeals;
  final double? distanceKm; // Calculated based on user location

  const BusinessEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.subcategories,
    required this.type,
    required this.genderPolicy,
    required this.location,
    required this.contact,
    required this.priceRange,
    required this.rating,
    this.isVerified = false,
    this.hasPrivateRoom = false,
    this.hasParking = false,
    this.hasGenerator = false,
    this.hasFemaleStaffOnly = false,
    this.offersHomeService = false,
    required this.amenities,
    required this.availability,
    required this.services,
    required this.gallery,
    required this.hours,
    required this.policies,
    required this.createdAt,
    required this.updatedAt,
    this.coverImage,
    this.logoUrl,
    this.responseTimeMinutes = 60,
    this.hasDeals = false,
    this.distanceKm,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        subcategories,
        type,
        genderPolicy,
        location,
        contact,
        priceRange,
        rating,
        isVerified,
        hasPrivateRoom,
        hasParking,
        hasGenerator,
        hasFemaleStaffOnly,
        offersHomeService,
        amenities,
        availability,
        services,
        gallery,
        hours,
        policies,
        createdAt,
        updatedAt,
        coverImage,
        logoUrl,
        responseTimeMinutes,
        hasDeals,
        distanceKm,
      ];

  BusinessEntity copyWith({
    String? id,
    String? name,
    String? description,
    BusinessCategory? category,
    List<String>? subcategories,
    BusinessType? type,
    GenderPolicy? genderPolicy,
    Location? location,
    ContactInfo? contact,
    PriceRange? priceRange,
    Rating? rating,
    bool? isVerified,
    bool? hasPrivateRoom,
    bool? hasParking,
    bool? hasGenerator,
    bool? hasFemaleStaffOnly,
    bool? offersHomeService,
    List<String>? amenities,
    AvailabilityCalendar? availability,
    List<ServicePackage>? services,
    Gallery? gallery,
    BusinessHours? hours,
    Policies? policies,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImage,
    String? logoUrl,
    int? responseTimeMinutes,
    bool? hasDeals,
    double? distanceKm,
  }) {
    return BusinessEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      subcategories: subcategories ?? this.subcategories,
      type: type ?? this.type,
      genderPolicy: genderPolicy ?? this.genderPolicy,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      hasPrivateRoom: hasPrivateRoom ?? this.hasPrivateRoom,
      hasParking: hasParking ?? this.hasParking,
      hasGenerator: hasGenerator ?? this.hasGenerator,
      hasFemaleStaffOnly: hasFemaleStaffOnly ?? this.hasFemaleStaffOnly,
      offersHomeService: offersHomeService ?? this.offersHomeService,
      amenities: amenities ?? this.amenities,
      availability: availability ?? this.availability,
      services: services ?? this.services,
      gallery: gallery ?? this.gallery,
      hours: hours ?? this.hours,
      policies: policies ?? this.policies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImage: coverImage ?? this.coverImage,
      logoUrl: logoUrl ?? this.logoUrl,
      responseTimeMinutes: responseTimeMinutes ?? this.responseTimeMinutes,
      hasDeals: hasDeals ?? this.hasDeals,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}
