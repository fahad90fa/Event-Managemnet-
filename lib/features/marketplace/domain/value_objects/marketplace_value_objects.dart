import 'package:equatable/equatable.dart';

/// Location information for a business
class Location extends Equatable {
  final String address;
  final String city;
  final String area;
  final double latitude;
  final double longitude;
  final String? landmark;

  const Location({
    required this.address,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    this.landmark,
  });

  @override
  List<Object?> get props =>
      [address, city, area, latitude, longitude, landmark];
}

/// Contact information
class ContactInfo extends Equatable {
  final String phone;
  final String? whatsapp;
  final String? email;
  final String? website;
  final Map<String, String>? socialMedia; // instagram, facebook, etc.

  const ContactInfo({
    required this.phone,
    this.whatsapp,
    this.email,
    this.website,
    this.socialMedia,
  });

  @override
  List<Object?> get props => [phone, whatsapp, email, website, socialMedia];
}

/// Business rating information
class Rating extends Equatable {
  final double average;
  final int totalReviews;
  final Map<int, int> distribution; // 5: 100, 4: 50, etc.

  const Rating({
    required this.average,
    required this.totalReviews,
    required this.distribution,
  });

  @override
  List<Object?> get props => [average, totalReviews, distribution];
}

/// Business hours
class BusinessHours extends Equatable {
  final Map<String, DayHours> schedule; // Monday: DayHours(...)

  const BusinessHours({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}

class DayHours extends Equatable {
  final bool isOpen;
  final String? openTime;
  final String? closeTime;
  final List<TimeSlot>? breaks;

  const DayHours({
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.breaks,
  });

  @override
  List<Object?> get props => [isOpen, openTime, closeTime, breaks];
}

class TimeSlot extends Equatable {
  final String start;
  final String end;

  const TimeSlot({required this.start, required this.end});

  @override
  List<Object?> get props => [start, end];
}

/// Service package offered by business
class ServicePackage extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final Duration? duration;
  final List<String> inclusions;
  final List<String>? exclusions;
  final bool isPopular;
  final String? imageUrl;

  const ServicePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.duration,
    required this.inclusions,
    this.exclusions,
    this.isPopular = false,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        duration,
        inclusions,
        exclusions,
        isPopular,
        imageUrl,
      ];
}

/// Gallery for business
class Gallery extends Equatable {
  final List<String> photos;
  final List<String>? videos;
  final Map<String, List<String>>? albums; // "Bridal": [urls], "Mehndi": [urls]

  const Gallery({
    required this.photos,
    this.videos,
    this.albums,
  });

  @override
  List<Object?> get props => [photos, videos, albums];
}

/// Business policies
class Policies extends Equatable {
  final String? cancellationPolicy;
  final String? depositPolicy;
  final String? refundPolicy;
  final int? advanceBookingDays;
  final int? cancellationHours;

  const Policies({
    this.cancellationPolicy,
    this.depositPolicy,
    this.refundPolicy,
    this.advanceBookingDays,
    this.cancellationHours,
  });

  @override
  List<Object?> get props => [
        cancellationPolicy,
        depositPolicy,
        refundPolicy,
        advanceBookingDays,
        cancellationHours,
      ];
}

/// Availability calendar
class AvailabilityCalendar extends Equatable {
  final Map<DateTime, List<TimeSlot>> availableSlots;
  final List<DateTime> blockedDates;

  const AvailabilityCalendar({
    required this.availableSlots,
    required this.blockedDates,
  });

  @override
  List<Object?> get props => [availableSlots, blockedDates];
}

/// Payment information
class PaymentInfo extends Equatable {
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final PaymentMethod method;
  final PaymentStatus status;
  final List<PaymentTransaction>? transactions;

  const PaymentInfo({
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.method,
    required this.status,
    this.transactions,
  });

  @override
  List<Object?> get props => [
        totalAmount,
        paidAmount,
        pendingAmount,
        method,
        status,
        transactions,
      ];
}

enum PaymentMethod {
  cash,
  bankTransfer,
  easypaisa,
  jazzcash,
  card,
}

enum PaymentStatus {
  pending,
  partial,
  paid,
  refunded,
}

class PaymentTransaction extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final PaymentMethod method;
  final String? reference;

  const PaymentTransaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.method,
    this.reference,
  });

  @override
  List<Object?> get props => [id, amount, date, method, reference];
}
