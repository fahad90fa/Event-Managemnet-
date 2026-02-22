# TODO Implementation Guide - Wedding OS Marketplace

**Created:** 2026-02-04  
**Purpose:** Guide for implementing backend-dependent features

---

## 📋 Overview

The marketplace frontend is **100% complete**. The remaining 16 TODO comments are **intentional placeholders** for features that require backend integration. This document explains each TODO and provides implementation guidance.

---

## 🔧 TODO Items by Category

### 1️⃣ **Search & Discovery** (3 items)

#### `TODO: Perform search`
**Location:** `lib/features/search/presentation/pages/search_page.dart:121`  
**Purpose:** Execute search query against backend  
**Implementation:**
```dart
// Replace TODO with:
final results = await searchRepository.search(
  query: _searchController.text,
  filters: _currentFilters,
);
setState(() {
  _searchResults = results;
});
```

#### `TODO: Save business` (2 instances)
**Locations:** 
- `lib/features/search/presentation/widgets/search_result_card.dart:121`
- `lib/features/explore/presentation/widgets/curated_collection.dart:267`

**Purpose:** Bookmark/save business to user favorites  
**Implementation:**
```dart
// Replace TODO with:
await bookmarkRepository.toggleBookmark(businessId);
PremiumToast.success(context, 'Business saved to favorites');
```

---

### 2️⃣ **Booking Management** (3 items)

#### `TODO: Search bookings`
**Location:** `lib/features/bookings/presentation/pages/bookings_page.dart:117`  
**Purpose:** Search through user's bookings  
**Implementation:**
```dart
// Replace TODO with:
showSearch(
  context: context,
  delegate: BookingSearchDelegate(),
);
```

#### `TODO: Open chat`
**Location:** `lib/features/bookings/presentation/widgets/booking_card.dart:201`  
**Purpose:** Navigate to chat with business  
**Implementation:**
```dart
// Replace TODO with:
context.push('/messages/${booking['businessId']}');
```

#### `TODO: Cancel booking`
**Location:** `lib/features/bookings/presentation/widgets/booking_card.dart:211`  
**Purpose:** Cancel booking with confirmation  
**Implementation:**
```dart
// Replace TODO with:
final confirmed = await PremiumDialog.showConfirmation(
  context,
  title: 'Cancel Booking',
  message: 'Are you sure you want to cancel this booking?',
  isDangerous: true,
);

if (confirmed == true) {
  await bookingRepository.cancelBooking(booking['id']);
  PremiumToast.success(context, 'Booking cancelled');
}
```

#### `TODO: Navigate to booking flow`
**Location:** `lib/features/business/presentation/pages/business_profile_page.dart:598`  
**Purpose:** Start booking creation process  
**Implementation:**
```dart
// Replace TODO with:
context.push('/booking/create', extra: {
  'businessId': businessId,
  'businessName': businessName,
});
```

---

### 3️⃣ **Messages & Communication** (2 items)

#### `TODO: Show options`
**Location:** `lib/features/messages/presentation/pages/messages_page.dart:96`  
**Purpose:** Show conversation options (delete, mute, etc.)  
**Implementation:**
```dart
// Replace TODO with:
showModalBottomSheet(
  context: context,
  builder: (context) => ConversationOptionsSheet(
    conversationId: conversation['id'],
  ),
);
```

---

### 4️⃣ **Navigation & Filters** (2 items)

#### `TODO: Show category filter`
**Location:** `lib/features/navigation/presentation/widgets/contextual_fab.dart:110`  
**Purpose:** Show category filter bottom sheet  
**Implementation:**
```dart
// Replace TODO with:
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => CategoryFilterSheet(),
);
```

#### `TODO: Show business selector`
**Location:** `lib/features/navigation/presentation/widgets/contextual_fab.dart:116`  
**Purpose:** Show business selector for new message  
**Implementation:**
```dart
// Replace TODO with:
final business = await showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => BusinessSelectorSheet(),
);

if (business != null) {
  context.push('/messages/${business.id}');
}
```

---

### 5️⃣ **Notifications** (2 items)

#### `TODO: Mark all as read`
**Location:** `lib/features/notifications/presentation/pages/notifications_page.dart:35`  
**Purpose:** Mark all notifications as read  
**Implementation:**
```dart
// Replace TODO with:
await notificationRepository.markAllAsRead();
setState(() {
  // Update UI
});
PremiumToast.success(context, 'All notifications marked as read');
```

#### `TODO: Handle notification tap`
**Location:** `lib/features/notifications/presentation/pages/notifications_page.dart:183`  
**Purpose:** Navigate based on notification type  
**Implementation:**
```dart
// Replace TODO with:
switch (notification['type']) {
  case 'booking_confirmed':
    context.push('/bookings/${notification['bookingId']}');
    break;
  case 'new_message':
    context.push('/messages/${notification['conversationId']}');
    break;
  case 'deal':
    context.push('/business/${notification['businessId']}');
    break;
  // ... other types
}
```

---

### 6️⃣ **Onboarding & Settings** (3 items)

#### `TODO: Navigate to vendor app`
**Location:** `lib/features/onboarding/presentation/pages/choose_intent_page.dart:101`  
**Purpose:** Switch to vendor/business mode  
**Implementation:**
```dart
// Replace TODO with:
// Option 1: Separate app
await launchUrl(Uri.parse('weddingos://vendor'));

// Option 2: Same app, different mode
context.go('/vendor/dashboard');
```

#### `TODO: Save to local storage or backend`
**Location:** `lib/features/onboarding/presentation/pages/personalization_page.dart:581`  
**Purpose:** Persist user preferences  
**Implementation:**
```dart
// Replace TODO with:
await userRepository.updatePreferences(
  city: _selectedCity,
  areas: _selectedAreas,
  interests: _selectedInterests,
  genderPreference: _genderPreference,
);

// Also save locally for offline access
await localStorageService.savePreferences({...});

context.go('/explore');
```

#### `TODO: Navigate to settings`
**Location:** `lib/features/profile/presentation/pages/profile_page.dart:148`  
**Purpose:** Navigate to settings page  
**Implementation:**
```dart
// Replace TODO with:
context.push('/settings');
```

#### `TODO: Navigate to wallet`
**Location:** `lib/features/profile/presentation/pages/profile_page.dart:181`  
**Purpose:** Navigate to wallet details  
**Implementation:**
```dart
// Replace TODO with:
context.push('/wallet');
```

---

## 🚀 Implementation Priority

### **Phase 1: Critical** (Implement First)
1. ✅ Save to local storage (onboarding)
2. ✅ Perform search
3. ✅ Navigate to booking flow
4. ✅ Cancel booking

### **Phase 2: Important** (Implement Second)
1. ✅ Save business (bookmarks)
2. ✅ Open chat
3. ✅ Handle notification tap
4. ✅ Mark all as read

### **Phase 3: Nice to Have** (Implement Last)
1. ✅ Search bookings
2. ✅ Show options (messages)
3. ✅ Show category filter
4. ✅ Show business selector
5. ✅ Navigate to settings
6. ✅ Navigate to wallet
7. ✅ Navigate to vendor app

---

## 📦 Required Backend APIs

To implement these TODOs, you'll need these backend endpoints:

### **Search & Discovery**
- `POST /api/search` - Search businesses
- `POST /api/bookmarks` - Save/unsave business
- `GET /api/bookmarks` - Get user bookmarks

### **Bookings**
- `GET /api/bookings/search?q={query}` - Search bookings
- `POST /api/bookings/{id}/cancel` - Cancel booking
- `POST /api/bookings` - Create booking

### **Messages**
- `GET /api/conversations` - Get conversations
- `POST /api/conversations/{id}/options` - Update conversation settings
- `DELETE /api/conversations/{id}` - Delete conversation

### **Notifications**
- `GET /api/notifications` - Get notifications
- `POST /api/notifications/mark-all-read` - Mark all as read
- `POST /api/notifications/{id}/read` - Mark single as read

### **User Preferences**
- `POST /api/users/preferences` - Save preferences
- `GET /api/users/preferences` - Get preferences
- `PUT /api/users/preferences` - Update preferences

---

## 🔗 Related Files

When implementing these TODOs, you may need to create:

1. **Repositories** (for API calls)
   - `lib/features/search/data/repositories/search_repository.dart`
   - `lib/features/bookings/data/repositories/booking_repository.dart`
   - `lib/features/messages/data/repositories/message_repository.dart`
   - etc.

2. **Models** (for API responses)
   - `lib/features/search/domain/models/search_result.dart`
   - `lib/features/bookings/domain/models/booking_detail.dart`
   - etc.

3. **Additional Pages**
   - `lib/features/settings/presentation/pages/settings_page.dart`
   - `lib/features/wallet/presentation/pages/wallet_page.dart`
   - `lib/features/booking/presentation/pages/create_booking_page.dart`

---

## ⚠️ Important Notes

1. **Don't Remove TODOs Yet** - Keep them until backend is ready
2. **Test Each Feature** - Add unit tests when implementing
3. **Error Handling** - Add proper error handling for API calls
4. **Loading States** - Show loading indicators during API calls
5. **Offline Support** - Cache data locally where appropriate

---

## ✅ Checklist for Backend Integration

- [ ] Set up API client with authentication
- [ ] Implement repository pattern for each feature
- [ ] Add error handling and retry logic
- [ ] Implement loading states
- [ ] Add offline caching
- [ ] Write unit tests for repositories
- [ ] Write integration tests for flows
- [ ] Update TODO comments with actual implementations
- [ ] Test all features end-to-end
- [ ] Update documentation

---

**Last Updated:** 2026-02-04 09:23 AM  
**Status:** Ready for Backend Integration
