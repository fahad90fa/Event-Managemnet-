/// Business categories for the marketplace
enum BusinessCategory {
  photographyVideo('Photography & Video', '📸'),
  womensSalon("Women's Salon", '💅'),
  mensSalon("Men's Salon", '✂️'),
  unisexSalon('Unisex Salon', '💇'),
  makeupArtist('Makeup Artist', '💄'),
  marqueeHall('Marquee/Hall', '🏛️'),
  farmhouse('Farmhouse', '🏡'),
  hotelBanquet('Hotel Banquet', '🏨'),
  restaurant('Restaurant', '🍽️'),
  cafe('Café', '☕'),
  catering('Catering', '🍱'),
  decor('Décor & Florals', '🌸'),
  wearDesigners('Wear & Designers', '👗'),
  transport('Transport', '🚗'),
  photoVideoStudio('Photo/Video Studio', '🎬');

  final String label;
  final String emoji;
  const BusinessCategory(this.label, this.emoji);
}

/// Gender policy for businesses
enum GenderPolicy {
  womenOnly('Women Only'),
  menOnly('Men Only'),
  unisex('Unisex'),
  segregated('Segregated/Family');

  final String label;
  const GenderPolicy(this.label);
}

/// Business type classification
enum BusinessType {
  salon,
  restaurant,
  cafe,
  studio,
  photographer,
  videographer,
  venue,
  hotel,
  catering,
  decor,
  designer,
  transport,
  makeupArtist,
}

/// Price range indicator
enum PriceRange {
  budget('₨', 'Budget-friendly'),
  moderate('₨₨', 'Moderate'),
  premium('₨₨₨', 'Premium'),
  luxury('₨₨₨₨', 'Luxury');

  final String symbol;
  final String label;
  const PriceRange(this.symbol, this.label);
}

/// Booking status
enum BookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  refunded('Refunded');

  final String label;
  const BookingStatus(this.label);
}

/// Booking type for different services
enum BookingType {
  salon,
  restaurant,
  studio,
  photographer,
  venue,
  catering,
  decor,
  transport,
}

/// Seating preference for restaurants
enum SeatingPreference {
  familyArea('Family Area'),
  privateRoom('Private Room'),
  outdoor('Outdoor'),
  regular('Regular');

  final String label;
  const SeatingPreference(this.label);
}

/// Photography/videography style
enum ShootStyle {
  traditional('Traditional'),
  cinematic('Cinematic'),
  candid('Candid'),
  documentary('Documentary');

  final String label;
  const ShootStyle(this.label);
}
