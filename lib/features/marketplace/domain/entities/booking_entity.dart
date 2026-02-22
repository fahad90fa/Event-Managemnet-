import 'package:equatable/equatable.dart';
import '../enums/marketplace_enums.dart';
import '../value_objects/marketplace_value_objects.dart';

/// Base booking entity
abstract class BookingEntity extends Equatable {
  final String id;
  final String businessId;
  final String businessName;
  final String userId;
  final DateTime bookingDate;
  final BookingStatus status;
  final PaymentInfo payment;
  final String? weddingWorkspaceId; // Optional link to wedding project
  final String? eventId; // Optional link to specific event (Mehndi/Barat/etc)
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cancellationReason;
  final String? specialRequests;

  const BookingEntity({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.userId,
    required this.bookingDate,
    required this.status,
    required this.payment,
    this.weddingWorkspaceId,
    this.eventId,
    required this.createdAt,
    required this.updatedAt,
    this.cancellationReason,
    this.specialRequests,
  });

  @override
  List<Object?> get props => [
        id,
        businessId,
        businessName,
        userId,
        bookingDate,
        status,
        payment,
        weddingWorkspaceId,
        eventId,
        createdAt,
        updatedAt,
        cancellationReason,
        specialRequests,
      ];
}

/// Salon booking entity
class SalonBooking extends BookingEntity {
  final List<SalonService> services;
  final String? preferredStaff;
  final bool womenOnlyStaff;
  final TimeSlot timeSlot;

  const SalonBooking({
    required super.id,
    required super.businessId,
    required super.businessName,
    required super.userId,
    required super.bookingDate,
    required super.status,
    required super.payment,
    super.weddingWorkspaceId,
    super.eventId,
    required super.createdAt,
    required super.updatedAt,
    super.cancellationReason,
    super.specialRequests,
    required this.services,
    this.preferredStaff,
    this.womenOnlyStaff = false,
    required this.timeSlot,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        services,
        preferredStaff,
        womenOnlyStaff,
        timeSlot,
      ];
}

class SalonService extends Equatable {
  final String id;
  final String name;
  final double price;
  final Duration duration;

  const SalonService({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, name, price, duration];
}

/// Restaurant booking entity
class RestaurantBooking extends BookingEntity {
  final int partySize;
  final SeatingPreference seating;
  final TimeSlot timeSlot;
  final String? dietaryRestrictions;

  const RestaurantBooking({
    required super.id,
    required super.businessId,
    required super.businessName,
    required super.userId,
    required super.bookingDate,
    required super.status,
    required super.payment,
    super.weddingWorkspaceId,
    super.eventId,
    required super.createdAt,
    required super.updatedAt,
    super.cancellationReason,
    super.specialRequests,
    required this.partySize,
    required this.seating,
    required this.timeSlot,
    this.dietaryRestrictions,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        partySize,
        seating,
        timeSlot,
        dietaryRestrictions,
      ];
}

/// Studio booking entity
class StudioBooking extends BookingEntity {
  final String studioRoom;
  final Duration duration;
  final TimeSlot timeSlot;
  final List<Equipment> equipment;
  final List<String> references;

  const StudioBooking({
    required super.id,
    required super.businessId,
    required super.businessName,
    required super.userId,
    required super.bookingDate,
    required super.status,
    required super.payment,
    super.weddingWorkspaceId,
    super.eventId,
    required super.createdAt,
    required super.updatedAt,
    super.cancellationReason,
    super.specialRequests,
    required this.studioRoom,
    required this.duration,
    required this.timeSlot,
    required this.equipment,
    required this.references,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        studioRoom,
        duration,
        timeSlot,
        equipment,
        references,
      ];
}

class Equipment extends Equatable {
  final String id;
  final String name;
  final double price;

  const Equipment({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
}

/// Photographer booking entity
class PhotographerBooking extends BookingEntity {
  final Duration coverage;
  final List<Deliverable> deliverables;
  final ShootStyle style;
  final bool isQuoteRequest;
  final String? negotiatedPrice;
  final bool includeDrone;

  const PhotographerBooking({
    required super.id,
    required super.businessId,
    required super.businessName,
    required super.userId,
    required super.bookingDate,
    required super.status,
    required super.payment,
    super.weddingWorkspaceId,
    super.eventId,
    required super.createdAt,
    required super.updatedAt,
    super.cancellationReason,
    super.specialRequests,
    required this.coverage,
    required this.deliverables,
    required this.style,
    this.isQuoteRequest = false,
    this.negotiatedPrice,
    this.includeDrone = false,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        coverage,
        deliverables,
        style,
        isQuoteRequest,
        negotiatedPrice,
        includeDrone,
      ];
}

class Deliverable extends Equatable {
  final String type; // photos, video, album, etc.
  final int quantity;
  final String format;

  const Deliverable({
    required this.type,
    required this.quantity,
    required this.format,
  });

  @override
  List<Object?> get props => [type, quantity, format];
}

/// Venue booking entity
class VenueBooking extends BookingEntity {
  final int guestCount;
  final String hall;
  final List<VenueAddOn> addOns;
  final PaymentSchedule schedule;
  final bool needsAccommodation;
  final int? roomsRequired;

  const VenueBooking({
    required super.id,
    required super.businessId,
    required super.businessName,
    required super.userId,
    required super.bookingDate,
    required super.status,
    required super.payment,
    super.weddingWorkspaceId,
    super.eventId,
    required super.createdAt,
    required super.updatedAt,
    super.cancellationReason,
    super.specialRequests,
    required this.guestCount,
    required this.hall,
    required this.addOns,
    required this.schedule,
    this.needsAccommodation = false,
    this.roomsRequired,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        guestCount,
        hall,
        addOns,
        schedule,
        needsAccommodation,
        roomsRequired,
      ];
}

class VenueAddOn extends Equatable {
  final String id;
  final String name;
  final double price;
  final String category; // catering, decor, etc.

  const VenueAddOn({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, price, category];
}

class PaymentSchedule extends Equatable {
  final double advancePercentage;
  final double midPercentage;
  final double finalPercentage;
  final DateTime? advanceDueDate;
  final DateTime? midDueDate;
  final DateTime? finalDueDate;

  const PaymentSchedule({
    required this.advancePercentage,
    required this.midPercentage,
    required this.finalPercentage,
    this.advanceDueDate,
    this.midDueDate,
    this.finalDueDate,
  });

  @override
  List<Object?> get props => [
        advancePercentage,
        midPercentage,
        finalPercentage,
        advanceDueDate,
        midDueDate,
        finalDueDate,
      ];
}
