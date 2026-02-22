# API Endpoint Specifications - BookMyEvent

> **Version**: 1.0  
> **Base URL**: `https://api.weddingos.com/v1`  
> **Authentication**: Bearer Token (JWT)

---

## Table of Contents

1. [Authentication](#authentication)
2. [Analytics Endpoints](#analytics-endpoints)
3. [Bidding System Endpoints](#bidding-system-endpoints)
4. [Translation Endpoints](#translation-endpoints)
5. [Social Features Endpoints](#social-features-endpoints)
6. [Live Event Endpoints](#live-event-endpoints)
7. [Seating Management](#seating-management)
8. [Payments & Finance](#payments--finance)
9. [Notifications System](#notifications-system)

---

## Authentication

All endpoints require authentication via Bearer token in the Authorization header:

```
Authorization: Bearer {access_token}
```

### Error Responses

All endpoints follow this error format:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {}
  },
  "timestamp": "2024-03-20T10:30:00Z"
}
```

**Common Error Codes**:
- `UNAUTHORIZED` (401): Invalid or expired token
- `FORBIDDEN` (403): Insufficient permissions
- `NOT_FOUND` (404): Resource not found
- `VALIDATION_ERROR` (422): Invalid input data
- `INTERNAL_ERROR` (500): Server error

---

## Analytics Endpoints

### GET /analytics/wedding/{wedding_id}/dashboard

Get comprehensive analytics dashboard for a wedding project.

**Path Parameters**:
- `wedding_id` (UUID, required): Wedding project ID

**Query Parameters**:
- `date_from` (ISO 8601 date, optional): Start date for time-series data
- `date_to` (ISO 8601 date, optional): End date for time-series data

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "overview": {
      "wedding_id": "uuid-123",
      "wedding_title": "Ahmed & Fatima Wedding",
      "planning_start_date": "2023-12-01",
      "first_event_date": "2024-06-10",
      "days_until_first_event": 75,
      "overall_progress": 62.5,
      "health_score": 87,
      "alerts": [
        {
          "type": "warning",
          "category": "budget",
          "message": "You've spent 58% of budget with 75 days remaining",
          "action": "Review upcoming expenses",
          "priority": 7
        }
      ]
    },
    "guest_analytics": {
      "summary": {
        "total_invited": 450,
        "confirmed": 320,
        "declined": 15,
        "pending": 115,
        "confirmation_rate": 71.1
      },
      "by_side": {
        "bride": {
          "invited": 220,
          "confirmed": 165,
          "rate": 75.0
        },
        "groom": {
          "invited": 230,
          "confirmed": 155,
          "rate": 67.4
        }
      },
      "by_event": [
        {
          "event_id": "uuid-event-1",
          "event_name": "Mehndi",
          "invited": 200,
          "confirmed": 145,
          "rate": 72.5
        }
      ],
      "predictions": {
        "expected_final_attendance": 385,
        "confidence": 0.82
      }
    },
    "budget_analytics": {
      "summary": {
        "total_budget": 1500000,
        "spent": 875000,
        "committed": 450000,
        "remaining": 175000,
        "percent_spent": 58.3
      },
      "by_category": [
        {
          "category": "venue",
          "category_name": "Venue",
          "budgeted": 350000,
          "spent": 300000,
          "committed": 50000,
          "remaining": 0,
          "percent_used": 100,
          "status": "on_budget"
        }
      ],
      "forecast": {
        "projected_final_cost": 1475000,
        "under_over_budget": -25000,
        "confidence": 0.78
      }
    },
    "vendor_analytics": {
      "summary": {
        "vendors_contacted": 34,
        "quotes_received": 18,
        "vendors_booked": 7,
        "pending_decisions": 3
      },
      "by_category": [
        {
          "category": "venue",
          "contacted": 8,
          "quotes": 5,
          "booked": 1,
          "average_quote": 320000,
          "your_booking": 300000,
          "savings_vs_average": 20000
        }
      ]
    },
    "task_analytics": {
      "summary": {
        "total_tasks": 89,
        "completed": 45,
        "in_progress": 23,
        "not_started": 21,
        "overdue": 5,
        "completion_rate": 50.6
      },
      "critical_path": [
        {
          "task_id": "uuid-task-1",
          "task": "Book Barat venue",
          "due_date": "2024-04-01",
          "days_remaining": 15,
          "blocking": ["task-2", "task-3"],
          "priority": "critical"
        }
      ]
    }
  },
  "timestamp": "2024-03-20T10:30:00Z"
}
```

**Errors**:
- `404`: Wedding not found
- `403`: User doesn't have access to this wedding

---

### GET /analytics/wedding/{wedding_id}/guest-engagement

Get detailed guest engagement metrics.

**Path Parameters**:
- `wedding_id` (UUID, required)

**Query Parameters**:
- `event_id` (UUID, optional): Filter by specific event
- `period` (string, optional): `7d`, `30d`, `90d`, `all` (default: `30d`)

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "engagement_timeline": [
      {
        "date": "2024-03-01",
        "invites_sent": 50,
        "invites_viewed": 42,
        "rsvp_submitted": 35,
        "view_rate": 84.0,
        "response_rate": 70.0
      }
    ],
    "response_time_analysis": {
      "average_days_to_respond": 3.2,
      "fastest_response_hours": 2,
      "slowest_response_days": 21,
      "median_days": 2.5
    },
    "channel_performance": {
      "whatsapp": {
        "sent": 200,
        "delivered": 198,
        "viewed": 180,
        "responded": 165,
        "response_rate": 82.5
      },
      "sms": {
        "sent": 150,
        "delivered": 148,
        "viewed": 120,
        "responded": 95,
        "response_rate": 63.3
      }
    },
    "top_engaged_families": [
      {
        "family_id": "uuid-family-1",
        "family_name": "Khan Family",
        "engagement_score": 95,
        "actions": ["viewed_invite", "rsvp_confirmed", "shared_photos"]
      }
    ]
  }
}
```

---

### GET /analytics/wedding/{wedding_id}/budget-trends

Get budget spending trends over time.

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "spending_timeline": [
      {
        "month": "2024-01",
        "budgeted": 200000,
        "actual": 175000,
        "variance": -25000,
        "variance_percent": -12.5
      }
    ],
    "category_trends": {
      "venue": {
        "budget": 350000,
        "spent_to_date": 300000,
        "projected_final": 350000,
        "on_track": true
      }
    },
    "burn_rate": {
      "daily_average": 12500,
      "weekly_average": 87500,
      "days_until_budget_exhausted": 14,
      "warning_level": "high"
    }
  }
}
```

---

### POST /analytics/wedding/{wedding_id}/export

Generate and download analytics report.

**Request Body**:

```json
{
  "format": "pdf",
  "sections": ["overview", "guests", "budget", "vendors", "tasks"],
  "date_range": {
    "from": "2024-01-01",
    "to": "2024-03-20"
  },
  "include_charts": true
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "report_id": "uuid-report-123",
    "download_url": "https://api.weddingos.com/downloads/reports/uuid-report-123.pdf",
    "expires_at": "2024-03-21T10:30:00Z",
    "file_size_bytes": 2415360,
    "file_size_mb": 2.3
  }
}
```

---

## Bidding System Endpoints

### POST /marketplace/bid-requests

Create a new bid request for vendors.

**Request Body**:

```json
{
  "wedding_project_id": "uuid-wedding",
  "event_id": "uuid-event",
  "category": "catering",
  "title": "Walima Dinner Catering for 500 Guests",
  "requirements": {
    "guest_count": 500,
    "meal_type": "dinner",
    "cuisine_preferences": ["pakistani", "bbq", "desserts"],
    "dietary_requirements": ["halal", "vegetarian_option"],
    "service_style": "buffet"
  },
  "budget_range": {
    "min": 400000,
    "max": 600000
  },
  "event_date": "2024-06-15",
  "event_time": "20:00:00",
  "location": {
    "address": "ABC Banquet Hall, DHA Phase 5, Lahore",
    "latitude": 31.4697,
    "longitude": 74.4084
  },
  "bidding_closes_at": "2024-04-15T23:59:59Z"
}
```

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "bid_request_id": "uuid-bid-req",
    "status": "published",
    "closes_in_seconds": 2592000,
    "notified_vendors_count": 23,
    "created_at": "2024-03-20T10:30:00Z"
  }
}
```

---

### GET /marketplace/bid-requests/{request_id}/bids

Get all bids for a specific request.

**Path Parameters**:
- `request_id` (UUID, required)

**Query Parameters**:
- `sort_by` (string, optional): `price_asc`, `price_desc`, `rating`, `recommended` (default)
- `status` (string, optional): `submitted`, `shortlisted`, `accepted`, `rejected`

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "bid_request": {
      "id": "uuid-bid-req",
      "title": "Walima Dinner Catering for 500 Guests",
      "status": "published",
      "closes_at": "2024-04-15T23:59:59Z",
      "bids_received": 8
    },
    "bids": [
      {
        "id": "uuid-bid-1",
        "vendor": {
          "id": "uuid-vendor-1",
          "name": "Royal Caterers",
          "rating": 4.7,
          "total_reviews": 134,
          "completed_weddings": 89,
          "verified": true,
          "logo_url": "https://..."
        },
        "bid_amount": 475000,
        "per_head_cost": 950,
        "rank": 1,
        "breakdown": {
          "food_cost": 400000,
          "service_charges": 50000,
          "equipment_rental": 25000
        },
        "included_services": [
          "500 guests buffet setup",
          "10 main dishes + desserts",
          "8 waiters for 4 hours"
        ],
        "status": "submitted",
        "submitted_at": "2024-03-18T14:30:00Z",
        "valid_until": "2024-04-20T23:59:59Z"
      }
    ],
    "comparison": {
      "lowest_bid": 450000,
      "highest_bid": 580000,
      "average_bid": 505000,
      "recommended_bid_id": "uuid-bid-1"
    }
  }
}
```

---

### POST /marketplace/bids/{bid_id}/accept

Accept a vendor's bid.

**Path Parameters**:
- `bid_id` (UUID, required)

**Request Body**:

```json
{
  "deposit_amount": 100000,
  "payment_method": "bank_transfer",
  "accept_terms": true,
  "notes": "Please confirm availability for setup at 2 PM"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "booking_id": "uuid-booking",
    "bid_id": "uuid-bid-1",
    "status": "accepted",
    "deposit_required": 100000,
    "payment_deadline": "2024-03-27T23:59:59Z",
    "next_steps": [
      "Complete deposit payment",
      "Sign contract",
      "Schedule menu tasting"
    ]
  }
}
```

---

## Translation Endpoints

### POST /translate

Translate text to target language.

**Request Body**:

```json
{
  "text": "Welcome to our wedding celebration",
  "source_language": "en",
  "target_language": "ur",
  "context": "wedding_invitation",
  "preserve_formatting": true
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "translated_text": "ہماری شادی کی تقریب میں خوش آمدید",
    "source_language": "en",
    "target_language": "ur",
    "confidence": 0.96,
    "from_cache": false,
    "alternative_translations": [
      "ہماری شادی کے جشن میں خوش آمدید"
    ]
  }
}
```

---

### POST /users/me/language-preferences

Update user's language preferences.

**Request Body**:

```json
{
  "primary_language": "ur",
  "secondary_languages": ["en"],
  "auto_translate_messages": true,
  "translation_quality": "accurate"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "user_id": "uuid-user",
    "primary_language": "ur",
    "auto_translate_messages": true,
    "updated_at": "2024-03-20T10:30:00Z"
  }
}
```

---

## Social Features Endpoints

### POST /social/feeds

Create a social feed for wedding.

**Request Body**:

```json
{
  "wedding_project_id": "uuid-wedding",
  "feed_type": "memories",
  "title": "Share Your Memories",
  "description": "Upload photos from pre-wedding events",
  "is_public": false,
  "moderation_enabled": true
}
```

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "feed_id": "uuid-feed",
    "feed_type": "memories",
    "is_public": false,
    "created_at": "2024-03-20T10:30:00Z"
  }
}
```

---

### GET /social/feeds/{feed_id}/posts

Get posts from a feed (paginated).

**Query Parameters**:
- `page` (integer, default: 1)
- `limit` (integer, default: 20, max: 50)
- `filter` (string, optional): `approved`, `pending`, `all`

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "posts": [
      {
        "id": "uuid-post-1",
        "author": {
          "type": "guest_family",
          "name": "Khan Family",
          "avatar_url": null
        },
        "post_type": "image",
        "content": "Had such a great time at the Dholki!",
        "media": [
          {
            "type": "image",
            "url": "https://cdn.weddingos.com/...",
            "thumbnail": "https://cdn.weddingos.com/..."
          }
        ],
        "reactions": {
          "heart": 23,
          "love": 45,
          "total": 68
        },
        "user_reaction": "heart",
        "comments_count": 12,
        "created_at": "2024-03-15T19:30:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_posts": 94,
      "per_page": 20
    }
  }
}
```

---

### POST /social/posts/{post_id}/react

React to a post.

**Request Body**:

```json
{
  "reaction_type": "love"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "post_id": "uuid-post-1",
    "reaction_type": "love",
    "total_reactions": 69
  }
}
```

---

## Live Event Endpoints

### POST /events/{event_id}/live/activate

Activate live event mode.

**Request Body**:

```json
{
  "session_name": "Mehndi Night - Live",
  "enabled_features": {
    "live_feed": true,
    "announcements": true,
    "qr_scanning": true,
    "issue_reporting": true,
    "photo_stream": true
  }
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "session_id": "uuid-session",
    "status": "active",
    "activated_at": "2024-06-15T19:00:00Z",
    "websocket_url": "wss://live.weddingos.com/session/uuid-session"
  }
}
```

---

### POST /live/{session_id}/announce

Broadcast announcement to attendees.

**Request Body**:

```json
{
  "announcement_type": "program_update",
  "priority": "high",
  "title": "Program Update",
  "message": "Mehndi ceremony will begin in 15 minutes",
  "target_audience": "all"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "announcement_id": "uuid-announcement",
    "delivered_to": 312,
    "announced_at": "2024-06-15T20:15:00Z"
  }
}
```

---

### GET /live/{session_id}/attendance

Get real-time attendance statistics.

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "total_expected": 450,
    "checked_in": 312,
    "percentage": 69.3,
    "breakdown_by_side": {
      "bride": {
        "expected": 220,
        "checked_in": 165
      },
      "groom": {
        "expected": 230,
        "checked_in": 147
      }
    },
    "recent_checkins": [
      {
        "family_name": "Khan Family",
        "headcount": 6,
        "checked_in_at": "2024-06-15T20:28:00Z"
      }
    ]
  }
}
```

---

## WebSocket Events

For real-time features, connect to WebSocket endpoint:

```
wss://live.weddingos.com/session/{session_id}?token={access_token}
```

### Client → Server Events

```json
{
  "event": "subscribe",
  "data": {
    "channels": ["announcements", "attendance", "photos"]
  }
}
```

### Server → Client Events

**New Announcement**:
```json
{
  "event": "announcement",
  "data": {
    "id": "uuid-announcement",
    "title": "Program Update",
    "message": "...",
    "priority": "high"
  }
}
```

**Guest Check-in**:
```json
{
  "event": "checkin",
  "data": {
    "family_name": "Khan Family",
    "headcount": 6,
    "total_checked_in": 312
  }
}
```

---

## Seating Management

### Post /seating/layouts

Create seating layout for event.

**Request Body**:

```json
{
  "event_id": "uuid-event",
  "layout_name": "Mehndi Main Hall",
  "layout_type": "banquet_rounds",
  "room_dimensions": {
    "width_feet": 80,
    "length_feet": 100,
    "shape": "rectangle",
    "entry_points": [
      {"x": 0, "y": 50, "label": "Main Entrance"},
      {"x": 80, "y": 50, "label": "Side Door"}
    ],
    "fixed_elements": [
      {"type": "stage", "x": 40, "y": 5, "width": 20, "height": 8},
      {"type": "buffet", "x": 70, "y": 30, "width": 10, "height": 15}
    ]
  },
  "total_capacity": 400
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "layout_id": "uuid-layout",
    "canvas_url": "https://api.weddingos.com/seating/canvas/uuid-layout",
    "default_sections_created": 3,
    "next_step": "Add tables to sections"
  }
}
```

---

### POST /seating/sections/{id}/tables/auto-generate

Automatically generate tables for a section.

**Request Body**:

```json
{
  "table_shape": "round",
  "table_capacity": 10,
  "spacing_feet": 4,
  "arrangement": "grid"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "tables_created": 12,
    "total_capacity": 120,
    "tables": [
      {
        "id": "uuid-table-1",
        "table_number": "L-VIP-1",
        "position_x": 12.5,
        "position_y": 15.0,
        "capacity": 10
      }
    ]
  }
}
```

---

### POST /seating/auto-assign

Automatically assign all unassigned guests using ML algorithm.

**Request Body**:

```json
{
  "layout_id": "uuid-layout",
  "rules_to_apply": [
    "family_together",
    "side_separation",
    "vip_priority",
    "respect_preferences"
  ],
  "optimization_goal": "maximize_satisfaction"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "total_guests_assigned": 380,
    "unassigned_count": 20,
    "assignment_quality_score": 87,
    "preference_satisfaction": {
      "must_have_met": 42,
      "must_have_unmet": 3,
      "preferred_met": 28,
      "preferred_unmet": 12
    },
    "conflicts_detected": [
      {
        "type": "relationship_conflict",
        "severity": "warning",
        "description": "Ahmed Family and Khan Family assigned to adjacent tables.",
        "affected_tables": ["T-12", "T-13"],
        "suggested_action": "Move Khan Family to T-20"
      }
    ]
  }
}
```

---

## Payments & Finance

### POST /payments/gateways/jazzcash/initiate

Initiate JazzCash payment.

**Request Body**:

```json
{
  "payment_id": "uuid-payment",
  "amount": 50000,
  "currency": "PKR",
  "payer_mobile": "03001234567",
  "description": "Advance payment for catering - Khan Wedding"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "transaction_id": "uuid-txn",
    "payment_url": "https://sandbox.jazzcash.com.pk/payment/uuid",
    "expires_in": 900,
    "instructions": "You will be redirected to JazzCash app to complete payment"
  }
}
```

---

### POST /payments/split

Configure payment split between families.

**Request Body**:

```json
{
  "payment_id": "uuid-payment",
  "total_amount": 500000,
  "splits": [
    {
      "payer_label": "Bride's Family",
      "payer_user_id": "uuid-user-bride-parent",
      "split_percentage": 40,
      "due_date": "2024-04-01"
    },
    {
      "payer_label": "Groom's Family",
      "payer_user_id": "uuid-user-groom-parent",
      "split_percentage": 60,
      "due_date": "2024-04-01"
    }
  ]
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "splits_created": 2,
    "split_details": [
      {
        "id": "uuid-split-1",
        "payer": "Bride's Family",
        "amount": 200000,
        "status": "pending"
      },
      {
        "id": "uuid-split-2",
        "payer": "Groom's Family",
        "amount": 300000,
        "status": "pending"
      }
    ]
  }
}
```

---

## Notifications System

### POST /notifications/send

Send notification to user(s).

**Request Body**:

```json
{
  "template_code": "payment_reminder",
  "recipients": [
    {"user_id": "uuid-user-1"}
  ],
  "variables": {
    "vendor_name": "Royal Caterers",
    "amount": "400000",
    "due_date": "May 1, 2024"
  },
  "channels": ["push", "sms"],
  "priority": "high",
  "actions": [
    {
      "label": "Pay Now",
      "type": "deep_link",
      "data": {"screen": "payment_detail", "payment_id": "uuid"}
    }
  ]
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "notification_ids": ["uuid-notif-1"],
    "total_recipients": 1,
    "channels_used": {
      "push": 1,
      "sms": 1
    },
    "estimated_delivery_time": "within 30 seconds"
  }
}
```

---

### POST /notifications/preferences

Update notification preferences.

**Request Body**:

```json
{
  "user_id": "uuid-user",
  "preferences": {
    "guest_updates": {
      "push": true,
      "sms": false,
      "email": true
    },
    "payment_reminders": {
      "push": true,
      "sms": true,
      "email": true
    }
  },
  "quiet_hours_enabled": true,
  "quiet_hours_start": "22:00",
  "quiet_hours_end": "08:00",
  "timezone": "Asia/Karachi"
}
```

---

## Rate Limiting

All endpoints are rate-limited:

- **Standard**: 100 requests/minute
- **Analytics**: 20 requests/minute
- **Translation**: 50 requests/minute
- **Live Events**: 200 requests/minute

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1679308800
```

---

## Pagination

All list endpoints support pagination:

**Query Parameters**:
- `page` (integer, default: 1)
- `limit` (integer, default: 20, max: 100)

**Response includes**:
```json
{
  "pagination": {
    "current_page": 1,
    "total_pages": 10,
    "total_items": 200,
    "per_page": 20,
    "has_next": true,
    "has_prev": false
  }
}
```

---

## Changelog

### Version 1.0 (2024-03-20)
- Initial API specification
- Analytics endpoints
- Bidding system endpoints
- Translation endpoints
- Social features endpoints
- Live event endpoints

---

**For Backend Implementation Questions**: Contact backend team lead  
**For API Support**: api-support@weddingos.com
