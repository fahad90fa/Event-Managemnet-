# Wedding OS → Celebration Services Marketplace
## Complete Frontend Redesign Implementation Plan

---

## 🎯 Product Vision Shift

**FROM:** Wedding-first event management platform  
**TO:** Premium Pakistan-first celebration services marketplace with optional wedding workspace

**Core Value Proposition:**
- **Primary:** "Find, compare, and book trusted wedding/celebration services in Pakistan"
- **Secondary:** "Organize bookings into your wedding timeline (optional)"

---

## 📐 New Information Architecture

### 1. Global Navigation Structure

#### Bottom Navigation (5 tabs)
```
┌─────────────────────────────────────────────────┐
│  🔍 Explore  │  📂 Categories  │  📅 Bookings  │
│  💬 Messages │  👤 Profile                      │
└─────────────────────────────────────────────────┘
```

#### Top App Bar (Contextual)
- Location selector (City/Area) - left
- Search icon - center/right
- Notifications bell - right

#### Floating Action Button
- Context-aware: "New Booking" / "Request Quote"
- Appears on Explore, Categories, Business Profile

#### Quick Filters Bar (Persistent on discovery)
- Budget slider
- Date picker
- Distance/Area chips
- Rating filter
- Gender filters: Ladies-only, Men-only, Unisex
- Service type: Home service, Verified

---

## 🚀 Phase 1: Core Foundation (Days 1-3)

### A. New Domain Models & Entities

**Business Entity** (replaces Vendor)
```dart
class BusinessEntity {
  String id;
  String name;
  BusinessCategory category;
  List<String> subcategories;
  BusinessType type; // salon, restaurant, studio, photographer, venue, etc.
  GenderPolicy genderPolicy; // womenOnly, menOnly, unisex, segregated
  Location location;
  ContactInfo contact;
  PriceRange priceRange;
  Rating rating;
  bool isVerified;
  bool hasPrivateRoom;
  bool hasParking;
  bool hasGenerator;
  List<String> amenities;
  AvailabilityCalendar availability;
  List<ServicePackage> services;
  Gallery gallery;
  BusinessHours hours;
  Policies policies;
}
```

**Booking Entity** (service-type specific)
```dart
abstract class BookingEntity {
  String id;
  String businessId;
  String userId;
  DateTime bookingDate;
  BookingStatus status;
  PaymentInfo payment;
  String? weddingWorkspaceId; // optional link
}

class SalonBooking extends BookingEntity {
  List<SalonService> services;
  String? preferredStaff;
  bool womenOnlyStaff;
  String? specialRequests;
}

class RestaurantBooking extends BookingEntity {
  int partySize;
  SeatingPreference seating;
  String? specialRequests;
}

class StudioBooking extends BookingEntity {
  String studioRoom;
  Duration duration;
  List<Equipment> addOns;
  List<String> references;
}

class PhotographerBooking extends BookingEntity {
  Duration coverage;
  List<Deliverable> deliverables;
  ShootStyle style;
  bool isQuoteRequest;
}

class VenueBooking extends BookingEntity {
  int guestCount;
  String hall;
  List<AddOn> addOns;
  PaymentSchedule schedule;
}
```

**Category System**
```dart
enum BusinessCategory {
  photographyVideo,
  womensSalon,
  mensSalon,
  unisexSalon,
  makeupArtist,
  marqueeHall,
  farmhouse,
  hotelBanquet,
  restaurant,
  cafe,
  catering,
  decor,
  wearDesigners,
  transport,
  photoVideoStudio,
}

enum GenderPolicy {
  womenOnly,
  menOnly,
  unisex,
  segregated,
}
```

### B. New Theme System (Premium Dark)

**Enhanced AppColors**
```dart
class AppColors {
  // Marketplace-specific colors
  static const Color marketplacePrimary = Color(0xFF6366F1); // Indigo
  static const Color marketplaceAccent = Color(0xFFEC4899); // Pink
  static const Color trustBadge = Color(0xFF10B981); // Green
  static const Color premiumGold = Color(0xFFFFD700);
  
  // Category colors
  static const Map<BusinessCategory, Color> categoryColors = {
    BusinessCategory.photographyVideo: Color(0xFF8B5CF6),
    BusinessCategory.womensSalon: Color(0xFFEC4899),
    BusinessCategory.mensSalon: Color(0xFF3B82F6),
    // ... etc
  };
  
  // Gender policy colors
  static const Color womenOnly = Color(0xFFDB2777);
  static const Color menOnly = Color(0xFF2563EB);
  static const Color unisex = Color(0xFF8B5CF6);
}
```

### C. New Routing Structure

```dart
// lib/core/config/router/app_router.dart
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Onboarding flow
    GoRoute(path: '/splash', builder: (context, state) => SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/choose-intent', builder: (context, state) => ChooseIntentPage()),
    GoRoute(path: '/personalization', builder: (context, state) => PersonalizationPage()),
    
    // Main app shell
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/explore', builder: (context, state) => ExplorePage()),
        GoRoute(path: '/categories', builder: (context, state) => CategoriesPage()),
        GoRoute(path: '/bookings', builder: (context, state) => BookingsPage()),
        GoRoute(path: '/messages', builder: (context, state) => MessagesPage()),
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
      ],
    ),
    
    // Business & booking flows
    GoRoute(path: '/business/:id', builder: (context, state) => BusinessProfilePage()),
    GoRoute(path: '/search', builder: (context, state) => SearchPage()),
    GoRoute(path: '/booking/:type/new', builder: (context, state) => BookingFlowPage()),
    
    // Optional Wedding Workspace
    GoRoute(path: '/workspace', builder: (context, state) => WeddingWorkspacePage()),
  ],
);
```

---

## 🎨 Phase 2: Onboarding Redesign (Days 4-5)

### Screens to Build

1. **Splash Screen** (Enhanced)
   - Premium dark animated background
   - Subtle depth with gradient orbs
   - Brand mark with elegant animation
   - Auto-navigate after 2s

2. **Login Screen** (Already done - enhance)
   - Add "Explore as guest" option
   - Make language toggle prominent
   - Premium phone input with +92 default

3. **Choose Intent Screen** (NEW)
   ```
   ┌─────────────────────────────────────┐
   │  What are you here for?             │
   │                                     │
   │  [📅 Book Services]                 │
   │  Find and book celebration services │
   │                                     │
   │  [💍 Plan a Wedding]                │
   │  Organize your complete wedding     │
   │                                     │
   │  [🏪 I'm a Business]                │
   │  Manage your business profile       │
   └─────────────────────────────────────┘
   ```

4. **Personalization Screen** (NEW)
   - Step 1: Select city + areas (chips)
   - Step 2: Select interests (category cards)
   - Step 3: Gender preference (optional)
   - Smooth progress indicator
   - Skip option

---

## 🏠 Phase 3: Explore Home (Days 6-8)

### Components to Build

1. **Hero Search Bar**
   - Animated placeholder suggestions
   - Voice search icon
   - Filter icon (opens filter drawer)

2. **Location Selector**
   - Current location chip
   - Change location modal

3. **Curated Collections** (Horizontal scrolls)
   - Premium card design with hero images
   - "Top rated photographers this week"
   - "Ladies-only salons with private rooms"
   - "Best cafés for dholki meetup"
   - "Hotels with wedding packages"
   - "Studios for bridal shoots"

4. **Featured Categories Grid**
   - 8-12 category tiles
   - Icon + name + count
   - Smooth press animation

5. **Near You Map Preview**
   - Mini map with business pins
   - "View all on map" CTA

6. **Trust Layer Strip**
   - "Verified businesses" badge
   - "Cash/IBFT supported" badge
   - "Women-only options" badge

7. **Recently Viewed**
   - Horizontal scroll of business cards

8. **Saved Shortlist**
   - Quick access to favorites

---

## 📂 Phase 4: Categories (Days 9-10)

### Category Structure

```dart
final categories = [
  Category(
    id: 'photography_video',
    name: 'Photography & Video',
    icon: Icons.camera_alt,
    subcategories: [
      'Wedding Photography',
      'Pre-wedding Shoots',
      'Videography',
      'Drone Coverage',
      'Album Design',
    ],
    bestFor: ['Bridal shoot', 'Mehndi coverage', 'Barat highlights'],
  ),
  Category(
    id: 'womens_salon',
    name: "Women's Salon",
    icon: Icons.face,
    subcategories: [
      'Bridal Makeup',
      'Hair Styling',
      'Mehndi/Henna',
      'Facial',
      'Manicure/Pedicure',
    ],
    filters: ['Private room', 'Female staff only', 'Home service'],
  ),
  // ... 10+ more categories
];
```

### Categories Page Layout
- Grid view with large category cards
- Each card: icon, name, business count, trending badge
- Quick filter chips at top
- Search within categories

---

## 🔍 Phase 5: Search & Discovery (Days 11-13)

### Search Results Page

**Features:**
- Map/List toggle with smooth animation
- Advanced filter drawer
- Sort options
- Premium result cards

**Filter Drawer Structure:**
```dart
class SearchFilters {
  List<String> areas;
  PriceRange budget;
  DateTime? availabilityDate;
  double? minRating;
  bool verifiedOnly;
  bool hasDeals;
  GenderPolicy? genderPolicy;
  
  // Category-specific
  Map<String, dynamic> categoryFilters; // e.g., for salons: services, privateRoom
}
```

**Result Card Design:**
- Hero image with gradient overlay
- Business name + category
- Rating + review count
- Starting price
- Distance + response time
- Trust badges (verified, women-only, etc.)
- Quick actions: Book, Quote, Call, WhatsApp, Save

---

## 🏪 Phase 6: Business Profile (Days 14-16)

### Business Profile Page (Storefront)

**Layout:**
```
┌─────────────────────────────────────┐
│  [Hero Gallery - Parallax]          │
│                                     │
│  Business Name ⭐ 4.8 (234)         │
│  Category • Distance • ₨₨₨         │
│  [Verified] [Women-only] [Private]  │
│                                     │
│  [Book] [Quote] [Message] [Save]    │
│                                     │
│  ┌─ Tabs ─────────────────────┐    │
│  │ Overview │ Services │ ...   │    │
│  └───────────────────────────┘    │
│                                     │
│  Tab Content Area                   │
└─────────────────────────────────────┘
```

**Tabs:**
1. **Overview**
   - Story/About
   - Highlights (amenities)
   - Policies (cancellation, deposit)
   - Operating hours

2. **Services/Packages**
   - Structured service cards
   - Price comparison
   - "Add to booking" CTA

3. **Portfolio**
   - Gallery albums
   - Video showreel
   - Before/After (for salons)

4. **Availability**
   - Calendar view
   - Available slots
   - Booking density indicator

5. **Reviews**
   - Verified reviews
   - Photo reviews
   - Filter by rating
   - Response from business

6. **Location**
   - Interactive map
   - Directions
   - Nearby landmarks

---

## 📅 Phase 7: Booking Flows (Days 17-20)

### Service-Specific Booking Flows

#### A. Salon Booking Flow
```
Step 1: Choose Services
  ├─ Hair styling ₨2000
  ├─ Bridal makeup ₨15000
  └─ Mehndi ₨3000

Step 2: Choose Staff (optional)
  ├─ Any available
  └─ Specific stylist (+₨500)

Step 3: Date & Time
  └─ Calendar + time slots

Step 4: Add Notes
  └─ Allergies, preferences

Step 5: Confirm & Pay
  └─ Deposit/Full payment
```

#### B. Restaurant Booking Flow
```
Step 1: Party Details
  ├─ Party size: 20 people
  └─ Date & time

Step 2: Seating Preference
  ├─ Family area
  ├─ Private room (+₨2000)
  └─ Outdoor

Step 3: Special Requests
  └─ Dietary restrictions, decorations

Step 4: Confirm Reservation
  └─ No payment required (or deposit)
```

#### C. Studio Booking Flow
```
Step 1: Choose Studio Room
  ├─ Studio A (White cyclorama)
  └─ Studio B (Vintage setup)

Step 2: Time Block
  └─ 4 hours (₨8000)

Step 3: Equipment Add-ons
  ├─ Softbox lighting
  └─ Backdrop options

Step 4: Upload References
  └─ Inspiration photos

Step 5: Confirm & Pay
```

#### D. Photographer Booking Flow
```
Step 1: Event Coverage
  ├─ Duration: 8 hours
  └─ Events: Mehndi + Barat

Step 2: Deliverables
  ├─ Edited photos: 500
  ├─ Video highlights: 10 min
  └─ Album design

Step 3: Style Preference
  ├─ Traditional
  ├─ Cinematic
  └─ Candid

Step 4: Date Hold (optional)
  └─ Reserve date with deposit

Step 5: Request Quote
  └─ Negotiation flow
```

#### E. Venue Booking Flow
```
Step 1: Event Details
  ├─ Date
  └─ Guest count: 500

Step 2: Hall Selection
  └─ Grand Hall (₨200,000)

Step 3: Add-ons
  ├─ Catering (₨1500/person)
  ├─ Décor package
  └─ Guest rooms

Step 4: Quote Comparison
  └─ Multiple package options

Step 5: Booking + Payment Schedule
  ├─ Advance: 30%
  ├─ Mid: 40%
  └─ Final: 30%
```

---

## 📋 Phase 8: Bookings Hub (Days 21-22)

### Bookings Page

**Views:**
- Calendar view (month/week)
- List view (grouped by status)

**Status Filters:**
- Upcoming
- Pending confirmation
- Confirmed
- Completed
- Cancelled

**Booking Card:**
```
┌─────────────────────────────────────┐
│  [Business Photo]                   │
│  Business Name                      │
│  📅 Feb 15, 2026 • 3:00 PM         │
│  📍 DHA Phase 5, Lahore            │
│  💰 ₨15,000 (Deposit paid)         │
│                                     │
│  [Message] [Call] [Directions]      │
│  [Attach to Wedding Workspace]      │
└─────────────────────────────────────┘
```

**Quick Actions:**
- Filter by date range
- Search bookings
- Export calendar
- Bulk actions

---

## 💬 Phase 9: Messages (Days 23-24)

### Chat Redesign

**Features:**
- Threads grouped by business
- Rich message cards (booking summaries, quotes, invoices)
- Voice notes support
- Quick actions (Confirm slot, Request revision, Send location, Share photo)

**Message Thread:**
```
┌─────────────────────────────────────┐
│  ← Studio XYZ                       │
│                                     │
│  [Booking Summary Card]             │
│  Studio A • Feb 15 • 4 hours        │
│  ₨8,000                            │
│                                     │
│  You: Can I add backdrop?           │
│  Studio: Yes, +₨500                │
│                                     │
│  [Quick Actions]                    │
│  ✓ Confirm slot                     │
│  📍 Send location                   │
│  📷 Share inspiration               │
│                                     │
│  [Type message...]                  │
└─────────────────────────────────────┘
```

---

## 👤 Phase 10: Profile & Wallet (Days 25-26)

### Profile Page

**Sections:**
1. User Info
   - Name, phone, email
   - Edit profile

2. Preferences
   - Gender filter preference (Women-only/Men-only/All)
   - Language (English/Urdu)
   - Notifications

3. Saved Businesses
   - Shortlist/favorites
   - Collections

4. Reviews
   - My reviews
   - Pending reviews

5. Wedding Workspace (Optional)
   - Entry point to organizer mode
   - "Create Wedding Project" CTA

6. Support
   - Help center
   - Contact support
   - FAQs

### Wallet Page

**Features:**
- Transaction history
- Pending deposits
- Refunds
- Receipts vault
- Payment methods

**Layout:**
```
┌─────────────────────────────────────┐
│  Balance: ₨0                        │
│  [Add Money] [Withdraw]             │
│                                     │
│  Recent Transactions                │
│  ├─ Studio XYZ • -₨8,000           │
│  ├─ Salon ABC • -₨15,000           │
│  └─ Refund • +₨2,000               │
│                                     │
│  [View All] [Receipts]              │
└─────────────────────────────────────┘
```

---

## 💍 Phase 11: Wedding Workspace (Optional) (Days 27-30)

### Wedding Workspace Entry

**From Profile:**
- "My Wedding Workspace" card
- "Create Wedding Project" CTA

**Workspace Features:**
1. Wedding Project Dashboard
   - Events timeline (Mehndi, Barat, Walima)
   - Attached bookings per event
   - Budget tracker
   - Guest list

2. Event Management
   - Create custom events
   - Attach bookings to events
   - Timeline view

3. Guest List & QR Entry
   - Import/export guests
   - QR code generation
   - Check-in tracking

4. Media Vault
   - Private albums
   - Ladies-only vault
   - Shared family albums

5. Budget Tracker
   - Link bookings to budget
   - Category-wise breakdown
   - Payment schedule

**UI Treatment:**
- Feels like an "organizer layer" on top of marketplace
- Not the default homepage
- Accessible via Profile or subtle Home chip
- Premium workspace aesthetic

---

## 🎨 Phase 12: Premium UI Components (Days 31-35)

### Component Library

1. **BusinessCard**
   - Horizontal & vertical variants
   - Hero image with gradient overlay
   - Trust badges
   - Quick actions

2. **CategoryTile**
   - Large icon
   - Name + count
   - Trending indicator
   - Press animation

3. **FilterChip**
   - Active/inactive states
   - Count badge
   - Smooth toggle

4. **BookingCard**
   - Status indicator
   - Business info
   - Date/time/location
   - Quick actions

5. **ReviewCard**
   - User avatar
   - Rating stars
   - Review text
   - Photos
   - Business response

6. **ServicePackageCard**
   - Package details
   - Price
   - Inclusions
   - "Add to booking" CTA

7. **AvailabilityCalendar**
   - Month/week view
   - Available/booked slots
   - Booking density heatmap

8. **PremiumButton**
   - Gradient variants
   - Loading states
   - Success animation
   - Disabled states

9. **GlassCard**
   - Backdrop blur
   - Border glow
   - Shadow depth

10. **AnimatedOrb**
    - Background decoration
    - Pulsing animation
    - Gradient radial

---

## 🌍 Phase 13: Localization & RTL (Days 36-37)

### Urdu Support

**Typography:**
- Use Noto Nastaliq Urdu for Urdu text
- Increase line height for readability
- Proper RTL layout support

**Translations:**
- All marketplace strings
- Category names
- UI labels
- Error messages
- Success messages

**RTL Layout:**
- Mirror navigation
- Reverse card layouts
- Flip icons where appropriate
- Test all flows in Urdu

---

## 🚀 Phase 14: Performance & Polish (Days 38-40)

### Performance Optimizations

1. **Image Loading**
   - Lazy loading
   - Progressive images
   - Cached network images
   - Placeholder shimmer

2. **List Performance**
   - Virtualized lists
   - Pagination
   - Infinite scroll
   - Smooth scroll physics

3. **Animation Performance**
   - 60fps target
   - Lightweight animations
   - GPU acceleration
   - Reduce overdraw

4. **State Management**
   - Efficient BLoC patterns
   - Selective rebuilds
   - Debounced search
   - Optimistic updates

### Polish Items

1. **Micro-interactions**
   - Button press depth
   - Card hover effects
   - Smooth transitions
   - Spring animations

2. **Error States**
   - Elegant error pages
   - Retry mechanisms
   - Helpful messages

3. **Empty States**
   - Illustrative graphics
   - Clear CTAs
   - Helpful suggestions

4. **Loading States**
   - Skeleton screens
   - Progress indicators
   - Shimmer effects

---

## 📦 Deliverables Checklist

### Screens (60+)
- [ ] Splash
- [ ] Login/OTP
- [ ] Choose Intent
- [ ] Personalization
- [ ] Explore Home
- [ ] Categories
- [ ] Category Detail
- [ ] Search Results
- [ ] Business Profile
- [ ] Salon Booking Flow (5 steps)
- [ ] Restaurant Booking Flow (4 steps)
- [ ] Studio Booking Flow (5 steps)
- [ ] Photographer Booking Flow (5 steps)
- [ ] Venue Booking Flow (5 steps)
- [ ] Bookings Hub
- [ ] Booking Detail
- [ ] Messages
- [ ] Chat Thread
- [ ] Profile
- [ ] Wallet
- [ ] Saved Businesses
- [ ] Reviews
- [ ] Wedding Workspace (10+ screens)

### Components (50+)
- [ ] BusinessCard (variants)
- [ ] CategoryTile
- [ ] FilterChip
- [ ] BookingCard
- [ ] ReviewCard
- [ ] ServicePackageCard
- [ ] AvailabilityCalendar
- [ ] PremiumButton
- [ ] GlassCard
- [ ] AnimatedOrb
- [ ] SearchBar
- [ ] FilterDrawer
- [ ] LocationSelector
- [ ] QuickFilters
- [ ] TrustBadge
- [ ] GenderPolicyBadge
- [ ] PriceRangeIndicator
- [ ] RatingDisplay
- [ ] BottomNavBar
- [ ] FloatingActionButton
- [ ] ... and more

### Features
- [ ] Multi-category marketplace
- [ ] Service-specific booking flows
- [ ] Advanced search & filters
- [ ] Gender-based filtering
- [ ] Location-based discovery
- [ ] Map integration
- [ ] Chat system
- [ ] Wallet & payments
- [ ] Reviews & ratings
- [ ] Optional Wedding Workspace
- [ ] Guest list & QR entry
- [ ] Media vault
- [ ] Budget tracking
- [ ] Urdu/RTL support

---

## 🎯 Success Metrics

1. **Performance**
   - 60fps on mid-range Android
   - < 3s initial load
   - < 1s screen transitions

2. **User Experience**
   - < 3 taps to book
   - Clear category discovery
   - Intuitive navigation
   - Smooth animations

3. **Accessibility**
   - Proper contrast ratios
   - Touch target sizes (48x48)
   - Screen reader support
   - RTL layout support

---

## 📝 Notes

- This is a **complete architectural shift** from wedding-first to marketplace-first
- Wedding features become **optional workspace mode**
- Focus on **premium, fast, beautiful** marketplace experience
- Gender separation and privacy are **first-class UI primitives**
- All animations must be **lightweight and performant**
- Urdu support must feel **native and polished**

---

**Estimated Timeline:** 40 days for complete redesign
**Team Size:** 2-3 developers + 1 designer
**Priority:** High - This is a fundamental product pivot
