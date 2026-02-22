-- Advanced Features Database Schema
-- BookMyEvent - Phase 2 Implementation
-- PostgreSQL 14+

-- ============================================================================
-- FEATURE 1: AI-POWERED BUDGET PREDICTIONS
-- ============================================================================

CREATE TABLE budget_predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    city_id UUID NOT NULL REFERENCES cities(id),
    guest_count_range VARCHAR(20) NOT NULL CHECK (guest_count_range IN ('0-100', '101-300', '301-500', '501-1000', '1000+')),
    season VARCHAR(10) NOT NULL CHECK (season IN ('spring', 'summer', 'fall', 'winter')),
    predicted_total DECIMAL(12,2) NOT NULL,
    category_breakdowns JSONB NOT NULL,
    confidence_score DECIMAL(3,2) NOT NULL CHECK (confidence_score BETWEEN 0 AND 1),
    generated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    algorithm_version VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_budget_predictions_wedding ON budget_predictions(wedding_project_id);
CREATE INDEX idx_budget_predictions_city_season ON budget_predictions(city_id, season);

CREATE TABLE historical_wedding_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID REFERENCES wedding_projects(id) ON DELETE SET NULL,
    city_id UUID NOT NULL REFERENCES cities(id),
    total_guests INTEGER NOT NULL CHECK (total_guests > 0),
    total_budget DECIMAL(12,2) NOT NULL CHECK (total_budget > 0),
    event_count INTEGER NOT NULL DEFAULT 1,
    season VARCHAR(10) NOT NULL CHECK (season IN ('spring', 'summer', 'fall', 'winter')),
    category_spending JSONB NOT NULL,
    vendor_ratings JSONB,
    anonymized BOOLEAN NOT NULL DEFAULT FALSE,
    consent_given BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    data_collection_date DATE NOT NULL
);

CREATE INDEX idx_historical_analytics_city_guests ON historical_wedding_analytics(city_id, total_guests);
CREATE INDEX idx_historical_analytics_season ON historical_wedding_analytics(season);
CREATE INDEX idx_historical_analytics_anonymized ON historical_wedding_analytics(anonymized) WHERE anonymized = TRUE;

CREATE TABLE smart_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    recommendation_type VARCHAR(50) NOT NULL CHECK (recommendation_type IN ('vendor', 'budget_allocation', 'timeline', 'guest_list_optimization')),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    action_data JSONB NOT NULL,
    priority_score INTEGER NOT NULL CHECK (priority_score BETWEEN 1 AND 10),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'dismissed', 'completed')),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_smart_recommendations_wedding_status ON smart_recommendations(wedding_project_id, status);
CREATE INDEX idx_smart_recommendations_priority ON smart_recommendations(priority_score DESC);

-- ============================================================================
-- FEATURE 2: VENDOR BIDDING MARKETPLACE
-- ============================================================================

CREATE TABLE vendor_bid_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES vendor_categories(id),
    title TEXT NOT NULL,
    requirements JSONB NOT NULL,
    budget_range_min DECIMAL(12,2),
    budget_range_max DECIMAL(12,2),
    preferred_date DATE,
    location GEOGRAPHY(POINT, 4326),
    location_address TEXT,
    special_requirements TEXT[],
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'closed', 'cancelled')),
    published_at TIMESTAMP,
    closes_at TIMESTAMP,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (budget_range_max IS NULL OR budget_range_max >= budget_range_min)
);

CREATE INDEX idx_bid_requests_status_closes ON vendor_bid_requests(status, closes_at);
CREATE INDEX idx_bid_requests_category ON vendor_bid_requests(category_id);
CREATE INDEX idx_bid_requests_location ON vendor_bid_requests USING GIST(location);

CREATE TABLE vendor_bids (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bid_request_id UUID NOT NULL REFERENCES vendor_bid_requests(id) ON DELETE CASCADE,
    vendor_id UUID NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
    submitted_by_vendor_user_id UUID NOT NULL REFERENCES users(id),
    bid_amount DECIMAL(12,2) NOT NULL CHECK (bid_amount > 0),
    original_bid_amount DECIMAL(12,2) NOT NULL CHECK (original_bid_amount > 0),
    bid_breakdown JSONB NOT NULL,
    package_details JSONB NOT NULL,
    terms_and_conditions TEXT,
    delivery_timeline TEXT,
    sample_images TEXT[],
    validity_period INTERVAL NOT NULL DEFAULT '30 days',
    status VARCHAR(20) NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'shortlisted', 'accepted', 'rejected', 'withdrawn')),
    rank_score DECIMAL(5,2),
    submitted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(bid_request_id, vendor_id)
);

CREATE INDEX idx_vendor_bids_request_rank ON vendor_bids(bid_request_id, rank_score DESC NULLS LAST);
CREATE INDEX idx_vendor_bids_vendor ON vendor_bids(vendor_id);
CREATE INDEX idx_vendor_bids_status ON vendor_bids(status);

CREATE TABLE bid_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bid_id UUID NOT NULL REFERENCES vendor_bids(id) ON DELETE CASCADE,
    sender_type VARCHAR(10) NOT NULL CHECK (sender_type IN ('client', 'vendor')),
    sender_user_id UUID NOT NULL REFERENCES users(id),
    message TEXT NOT NULL,
    attachments JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_bid_messages_bid_time ON bid_messages(bid_id, created_at DESC);

CREATE TABLE bid_revisions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bid_id UUID NOT NULL REFERENCES vendor_bids(id) ON DELETE CASCADE,
    previous_amount DECIMAL(12,2) NOT NULL,
    new_amount DECIMAL(12,2) NOT NULL,
    revision_reason TEXT,
    revised_by_vendor_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_bid_revisions_bid ON bid_revisions(bid_id, created_at DESC);

-- ============================================================================
-- FEATURE 3: MULTI-LANGUAGE TRANSLATION
-- ============================================================================

CREATE TABLE translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    language_code VARCHAR(5) NOT NULL CHECK (language_code IN ('en', 'ur', 'pa')),
    translated_text TEXT NOT NULL,
    translation_source VARCHAR(20) NOT NULL DEFAULT 'auto' CHECK (translation_source IN ('user', 'auto', 'professional')),
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(entity_type, entity_id, field_name, language_code)
);

CREATE INDEX idx_translations_entity ON translations(entity_type, entity_id, language_code);

CREATE TABLE user_language_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    primary_language VARCHAR(5) NOT NULL DEFAULT 'en' CHECK (primary_language IN ('en', 'ur', 'pa')),
    secondary_languages VARCHAR(5)[] DEFAULT ARRAY['en'],
    auto_translate_messages BOOLEAN NOT NULL DEFAULT TRUE,
    translation_quality VARCHAR(20) NOT NULL DEFAULT 'balanced' CHECK (translation_quality IN ('fast', 'balanced', 'accurate')),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE translation_cache (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_text TEXT NOT NULL,
    source_language VARCHAR(5) NOT NULL,
    target_language VARCHAR(5) NOT NULL,
    translated_text TEXT NOT NULL,
    translation_provider VARCHAR(50) NOT NULL,
    quality_score DECIMAL(3,2) CHECK (quality_score BETWEEN 0 AND 1),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP NOT NULL DEFAULT (NOW() + INTERVAL '30 days')
);

CREATE INDEX idx_translation_cache_lookup ON translation_cache(md5(source_text), source_language, target_language);
CREATE INDEX idx_translation_cache_expires ON translation_cache(expires_at);

-- ============================================================================
-- FEATURE 4: ADVANCED ANALYTICS
-- ============================================================================

CREATE TABLE wedding_analytics_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    snapshot_date DATE NOT NULL,
    metrics JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(wedding_project_id, snapshot_date)
);

CREATE INDEX idx_analytics_snapshots_wedding_date ON wedding_analytics_snapshots(wedding_project_id, snapshot_date DESC);

CREATE TABLE guest_engagement_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_family_id UUID NOT NULL REFERENCES guest_families(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE CASCADE,
    action_type VARCHAR(30) NOT NULL CHECK (action_type IN ('invite_sent', 'invite_viewed', 'rsvp_submitted', 'rsvp_changed', 'reminded')),
    action_timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    channel VARCHAR(20) CHECK (channel IN ('whatsapp', 'sms', 'email', 'in_app')),
    device_info JSONB
);

CREATE INDEX idx_guest_engagement_family_time ON guest_engagement_tracking(guest_family_id, action_timestamp DESC);
CREATE INDEX idx_guest_engagement_event ON guest_engagement_tracking(event_id);

CREATE TABLE vendor_performance_metrics (
    vendor_id UUID PRIMARY KEY REFERENCES vendors(id) ON DELETE CASCADE,
    total_bids_submitted INTEGER NOT NULL DEFAULT 0,
    bids_won INTEGER NOT NULL DEFAULT 0,
    win_rate DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE WHEN total_bids_submitted > 0 
        THEN (bids_won::DECIMAL / total_bids_submitted * 100)
        ELSE 0 END
    ) STORED,
    average_bid_amount DECIMAL(12,2),
    average_response_time_minutes INTEGER,
    total_bookings INTEGER NOT NULL DEFAULT 0,
    total_revenue DECIMAL(14,2) NOT NULL DEFAULT 0,
    average_rating DECIMAL(3,2),
    total_reviews INTEGER NOT NULL DEFAULT 0,
    on_time_delivery_rate DECIMAL(5,2),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE daily_active_users (
    date DATE PRIMARY KEY,
    active_users INTEGER NOT NULL DEFAULT 0,
    new_users INTEGER NOT NULL DEFAULT 0,
    active_weddings INTEGER NOT NULL DEFAULT 0,
    new_weddings INTEGER NOT NULL DEFAULT 0,
    total_api_requests INTEGER NOT NULL DEFAULT 0,
    average_session_duration_minutes DECIMAL(8,2)
);

-- ============================================================================
-- FEATURE 5: SOCIAL COLLABORATION
-- ============================================================================

CREATE TABLE social_feeds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    feed_type VARCHAR(20) NOT NULL CHECK (feed_type IN ('general', 'memories', 'countdown', 'polls', 'wishes')),
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    moderation_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_social_feeds_wedding ON social_feeds(wedding_project_id);

CREATE TABLE feed_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feed_id UUID NOT NULL REFERENCES social_feeds(id) ON DELETE CASCADE,
    posted_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    posted_by_guest_family_id UUID REFERENCES guest_families(id) ON DELETE SET NULL,
    post_type VARCHAR(20) NOT NULL CHECK (post_type IN ('text', 'image', 'video', 'poll', 'memory', 'wish')),
    content TEXT,
    media_urls TEXT[],
    metadata JSONB,
    visibility VARCHAR(20) NOT NULL DEFAULT 'public' CHECK (visibility IN ('public', 'family_only', 'private')),
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,
    reactions_count JSONB NOT NULL DEFAULT '{}',
    comments_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    edited_at TIMESTAMP,
    CHECK (posted_by_user_id IS NOT NULL OR posted_by_guest_family_id IS NOT NULL)
);

CREATE INDEX idx_feed_posts_feed_created ON feed_posts(feed_id, created_at DESC) WHERE is_approved = TRUE;
CREATE INDEX idx_feed_posts_approval ON feed_posts(is_approved) WHERE is_approved = FALSE;

CREATE TABLE feed_reactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES feed_posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    guest_family_id UUID REFERENCES guest_families(id) ON DELETE CASCADE,
    reaction_type VARCHAR(20) NOT NULL CHECK (reaction_type IN ('heart', 'love', 'laugh', 'wow', 'sad', 'celebrate')),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (user_id IS NOT NULL OR guest_family_id IS NOT NULL),
    UNIQUE(post_id, user_id),
    UNIQUE(post_id, guest_family_id)
);

CREATE INDEX idx_feed_reactions_post ON feed_reactions(post_id, reaction_type);

CREATE TABLE feed_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES feed_posts(id) ON DELETE CASCADE,
    parent_comment_id UUID REFERENCES feed_comments(id) ON DELETE CASCADE,
    commented_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    commented_by_guest_family_id UUID REFERENCES guest_families(id) ON DELETE SET NULL,
    comment_text TEXT NOT NULL,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (commented_by_user_id IS NOT NULL OR commented_by_guest_family_id IS NOT NULL)
);

CREATE INDEX idx_feed_comments_post ON feed_comments(post_id, created_at DESC);

CREATE TABLE wedding_polls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    feed_post_id UUID REFERENCES feed_posts(id) ON DELETE SET NULL,
    question TEXT NOT NULL,
    poll_type VARCHAR(20) NOT NULL CHECK (poll_type IN ('single_choice', 'multiple_choice', 'rating', 'open_text')),
    options JSONB NOT NULL,
    allows_guest_voting BOOLEAN NOT NULL DEFAULT TRUE,
    closes_at TIMESTAMP,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_wedding_polls_wedding ON wedding_polls(wedding_project_id);

CREATE TABLE poll_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES wedding_polls(id) ON DELETE CASCADE,
    voter_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    voter_guest_family_id UUID REFERENCES guest_families(id) ON DELETE CASCADE,
    selected_option_ids INTEGER[],
    open_text_response TEXT,
    voted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (voter_user_id IS NOT NULL OR voter_guest_family_id IS NOT NULL),
    UNIQUE(poll_id, voter_user_id),
    UNIQUE(poll_id, voter_guest_family_id)
);

CREATE INDEX idx_poll_votes_poll ON poll_votes(poll_id);

CREATE TABLE guest_wishes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    guest_family_id UUID NOT NULL REFERENCES guest_families(id) ON DELETE CASCADE,
    wish_text TEXT NOT NULL,
    is_video_message BOOLEAN NOT NULL DEFAULT FALSE,
    video_url TEXT,
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_guest_wishes_wedding ON guest_wishes(wedding_project_id);

CREATE TABLE collaborative_wishlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    list_type VARCHAR(20) NOT NULL CHECK (list_type IN ('gift_registry', 'shopping_list', 'ideas')),
    title TEXT NOT NULL,
    description TEXT,
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_wishlists_wedding ON collaborative_wishlists(wedding_project_id);

CREATE TABLE wishlist_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wishlist_id UUID NOT NULL REFERENCES collaborative_wishlists(id) ON DELETE CASCADE,
    item_name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    estimated_price DECIMAL(12,2),
    priority VARCHAR(20) NOT NULL DEFAULT 'nice_to_have' CHECK (priority IN ('must_have', 'nice_to_have', 'optional')),
    quantity_needed INTEGER NOT NULL DEFAULT 1 CHECK (quantity_needed > 0),
    quantity_pledged INTEGER NOT NULL DEFAULT 0 CHECK (quantity_pledged >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'needed' CHECK (status IN ('needed', 'pledged', 'purchased', 'received')),
    added_by_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (quantity_pledged <= quantity_needed)
);

CREATE INDEX idx_wishlist_items_list ON wishlist_items(wishlist_id);

CREATE TABLE wishlist_pledges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wishlist_item_id UUID NOT NULL REFERENCES wishlist_items(id) ON DELETE CASCADE,
    pledged_by_guest_family_id UUID REFERENCES guest_families(id) ON DELETE CASCADE,
    pledged_by_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    quantity_pledged INTEGER NOT NULL CHECK (quantity_pledged > 0),
    message TEXT,
    pledged_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (pledged_by_guest_family_id IS NOT NULL OR pledged_by_user_id IS NOT NULL)
);

CREATE INDEX idx_wishlist_pledges_item ON wishlist_pledges(wishlist_item_id);

-- ============================================================================
-- FEATURE 6: LIVE EVENT MODE
-- ============================================================================

CREATE TABLE live_event_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    session_name TEXT NOT NULL,
    activated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deactivated_at TIMESTAMP,
    coordinator_user_id UUID NOT NULL REFERENCES users(id),
    status VARCHAR(20) NOT NULL DEFAULT 'preparing' CHECK (status IN ('preparing', 'active', 'paused', 'ended')),
    live_features_enabled JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_live_sessions_event_status ON live_event_sessions(event_id, status);

CREATE TABLE live_announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    live_session_id UUID NOT NULL REFERENCES live_event_sessions(id) ON DELETE CASCADE,
    announcement_type VARCHAR(20) NOT NULL CHECK (announcement_type IN ('general', 'food_ready', 'program_update', 'emergency', 'celebration')),
    priority VARCHAR(10) NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    target_audience VARCHAR(20) NOT NULL DEFAULT 'all' CHECK (target_audience IN ('all', 'family_only', 'vip', 'vendors', 'staff')),
    media_url TEXT,
    announced_by_user_id UUID NOT NULL REFERENCES users(id),
    announced_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP,
    delivered_count INTEGER NOT NULL DEFAULT 0,
    read_count INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_live_announcements_session_time ON live_announcements(live_session_id, announced_at DESC);

CREATE TABLE live_program_schedule (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    live_session_id UUID NOT NULL REFERENCES live_event_sessions(id) ON DELETE CASCADE,
    program_item TEXT NOT NULL,
    scheduled_time TIMESTAMP NOT NULL,
    actual_time TIMESTAMP,
    duration_minutes INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'in_progress', 'completed', 'delayed', 'cancelled')),
    assigned_coordinator_id UUID REFERENCES users(id),
    notes TEXT,
    sort_order INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_live_program_session_order ON live_program_schedule(live_session_id, sort_order);

CREATE TABLE live_guest_checkins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    live_session_id UUID NOT NULL REFERENCES live_event_sessions(id) ON DELETE CASCADE,
    guest_family_id UUID NOT NULL REFERENCES guest_families(id) ON DELETE CASCADE,
    checked_in_at TIMESTAMP NOT NULL DEFAULT NOW(),
    checked_in_by_user_id UUID NOT NULL REFERENCES users(id),
    actual_headcount INTEGER NOT NULL CHECK (actual_headcount > 0),
    table_assigned TEXT,
    notes TEXT,
    UNIQUE(live_session_id, guest_family_id)
);

CREATE INDEX idx_live_checkins_session_time ON live_guest_checkins(live_session_id, checked_in_at DESC);

CREATE TABLE live_issues_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    live_session_id UUID NOT NULL REFERENCES live_event_sessions(id) ON DELETE CASCADE,
    reported_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    reported_by_guest_family_id UUID REFERENCES guest_families(id) ON DELETE SET NULL,
    issue_type VARCHAR(30) NOT NULL CHECK (issue_type IN ('food_quality', 'seating', 'temperature', 'sound', 'other')),
    description TEXT NOT NULL,
    location TEXT,
    priority VARCHAR(10) NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    status VARCHAR(20) NOT NULL DEFAULT 'reported' CHECK (status IN ('reported', 'acknowledged', 'in_progress', 'resolved')),
    assigned_to_user_id UUID REFERENCES users(id),
    reported_at TIMESTAMP NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMP,
    CHECK (reported_by_user_id IS NOT NULL OR reported_by_guest_family_id IS NOT NULL)
);

CREATE INDEX idx_live_issues_session_status ON live_issues_reports(live_session_id, status);

CREATE TABLE live_photo_stream (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    live_session_id UUID NOT NULL REFERENCES live_event_sessions(id) ON DELETE CASCADE,
    uploaded_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    uploaded_by_guest_family_id UUID REFERENCES guest_families(id) ON DELETE SET NULL,
    photo_url TEXT NOT NULL,
    thumbnail_url TEXT NOT NULL,
    caption TEXT,
    taken_at TIMESTAMP NOT NULL,
    uploaded_at TIMESTAMP NOT NULL DEFAULT NOW(),
    moderation_status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (moderation_status IN ('pending', 'approved', 'rejected')),
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    CHECK (uploaded_by_user_id IS NOT NULL OR uploaded_by_guest_family_id IS NOT NULL)
);

CREATE INDEX idx_live_photos_session_time ON live_photo_stream(live_session_id, uploaded_at DESC);
CREATE INDEX idx_live_photos_featured ON live_photo_stream(live_session_id, is_featured) WHERE is_featured = TRUE;

CREATE TABLE live_vendor_coordination (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    live_session_id UUID NOT NULL REFERENCES live_event_sessions(id) ON DELETE CASCADE,
    vendor_id UUID NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
    vendor_contact_person TEXT NOT NULL,
    vendor_phone TEXT NOT NULL,
    arrival_time TIMESTAMP,
    departure_time TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'expected' CHECK (status IN ('expected', 'arrived', 'working', 'completed', 'departed')),
    location_at_venue TEXT,
    notes TEXT,
    last_updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(live_session_id, vendor_id)
);

CREATE INDEX idx_live_vendors_session_status ON live_vendor_coordination(live_session_id, status);

-- ============================================================================
-- TRIGGERS FOR AUTO-UPDATING TIMESTAMPS
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at column
CREATE TRIGGER update_budget_predictions_updated_at BEFORE UPDATE ON budget_predictions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vendor_bid_requests_updated_at BEFORE UPDATE ON vendor_bid_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vendor_bids_updated_at BEFORE UPDATE ON vendor_bids
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_smart_recommendations_updated_at BEFORE UPDATE ON smart_recommendations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_translations_updated_at BEFORE UPDATE ON translations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_language_preferences_updated_at BEFORE UPDATE ON user_language_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on sensitive tables
ALTER TABLE budget_predictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendor_bid_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendor_bids ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_event_sessions ENABLE ROW LEVEL SECURITY;

-- Example policies (adjust based on your auth system)
-- Users can only see their own wedding's budget predictions
CREATE POLICY budget_predictions_select_policy ON budget_predictions
    FOR SELECT
    USING (
        wedding_project_id IN (
            SELECT id FROM wedding_projects 
            WHERE owner_user_id = current_setting('app.current_user_id')::UUID
        )
    );

-- Vendors can only see bids they submitted
CREATE POLICY vendor_bids_select_policy ON vendor_bids
    FOR SELECT
    USING (
        vendor_id IN (
            SELECT id FROM vendors 
            WHERE owner_user_id = current_setting('app.current_user_id')::UUID
        )
        OR
        bid_request_id IN (
            SELECT id FROM vendor_bid_requests vbr
            JOIN wedding_projects wp ON vbr.wedding_project_id = wp.id
            WHERE wp.owner_user_id = current_setting('app.current_user_id')::UUID
        )
    );

-- ============================================================================
-- SAMPLE DATA FOR TESTING (Optional)
-- ============================================================================

-- Insert sample guest count ranges for reference
COMMENT ON COLUMN budget_predictions.guest_count_range IS 'Guest count ranges: 0-100, 101-300, 301-500, 501-1000, 1000+';

-- Insert sample seasons
COMMENT ON COLUMN budget_predictions.season IS 'Seasons: spring (Mar-May), summer (Jun-Aug), fall (Sep-Nov), winter (Dec-Feb)';

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- View for active bid requests with bid counts
CREATE VIEW active_bid_requests_with_stats AS
SELECT 
    vbr.*,
    COUNT(vb.id) as total_bids,
    MIN(vb.bid_amount) as lowest_bid,
    MAX(vb.bid_amount) as highest_bid,
    AVG(vb.bid_amount) as average_bid
FROM vendor_bid_requests vbr
LEFT JOIN vendor_bids vb ON vbr.id = vb.bid_request_id AND vb.status != 'withdrawn'
WHERE vbr.status = 'published'
GROUP BY vbr.id;

-- View for wedding analytics summary
CREATE VIEW wedding_analytics_summary AS
SELECT 
    wp.id as wedding_project_id,
    wp.title as wedding_title,
    (SELECT COUNT(*) FROM guest_families WHERE wedding_project_id = wp.id) as total_families,
    (SELECT SUM(confirmed_headcount) FROM guest_families WHERE wedding_project_id = wp.id AND rsvp_status = 'confirmed') as confirmed_guests,
    (SELECT COUNT(*) FROM vendors v JOIN bookings b ON v.id = b.vendor_id WHERE b.wedding_project_id = wp.id) as booked_vendors,
    (SELECT SUM(amount) FROM budget_items WHERE wedding_project_id = wp.id AND status = 'paid') as total_spent
FROM wedding_projects wp;

-- ============================================================================
-- MATERIALIZED VIEW FOR PERFORMANCE (Refresh periodically)
-- ============================================================================

CREATE MATERIALIZED VIEW vendor_performance_summary AS
SELECT 
    v.id as vendor_id,
    v.business_name,
    COUNT(DISTINCT vb.id) as total_bids,
    COUNT(DISTINCT CASE WHEN vb.status = 'accepted' THEN vb.id END) as won_bids,
    AVG(vb.bid_amount) as avg_bid_amount,
    AVG(EXTRACT(EPOCH FROM (vb.submitted_at - vbr.published_at))/3600) as avg_response_hours
FROM vendors v
LEFT JOIN vendor_bids vb ON v.id = vb.vendor_id
LEFT JOIN vendor_bid_requests vbr ON vb.bid_request_id = vbr.id
GROUP BY v.id, v.business_name;

CREATE UNIQUE INDEX ON vendor_performance_summary (vendor_id);

-- Refresh command (run periodically via cron job):
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vendor_performance_summary;

-- ============================================================================
-- FEATURE 11: ADVANCED SEATING MANAGEMENT
-- ============================================================================

CREATE TABLE seating_layouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    layout_name TEXT NOT NULL,
    layout_type VARCHAR(50) NOT NULL CHECK (layout_type IN ('banquet_rounds', 'long_tables', 'theater_rows', 'custom_shapes', 'mixed')),
    total_capacity INTEGER NOT NULL CHECK (total_capacity > 0),
    room_dimensions JSONB NOT NULL,
    canvas_data JSONB,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_seating_layouts_event ON seating_layouts(event_id);

CREATE TABLE seating_sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seating_layout_id UUID NOT NULL REFERENCES seating_layouts(id) ON DELETE CASCADE,
    section_name TEXT NOT NULL,
    section_type VARCHAR(50) NOT NULL CHECK (section_type IN ('vip', 'family', 'ladies_only', 'gents_only', 'mixed', 'children', 'elderly', 'stage_proximity')),
    color_code VARCHAR(10) NOT NULL,
    position_coordinates JSONB NOT NULL,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    special_amenities TEXT[],
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_seating_sections_layout ON seating_sections(seating_layout_id);

CREATE TABLE seating_tables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seating_section_id UUID NOT NULL REFERENCES seating_sections(id) ON DELETE CASCADE,
    table_number VARCHAR(20) NOT NULL,
    table_shape VARCHAR(20) NOT NULL CHECK (table_shape IN ('round', 'rectangle', 'square', 'oval', 'custom')),
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    position_x DECIMAL(10,2) NOT NULL,
    position_y DECIMAL(10,2) NOT NULL,
    rotation_degrees DECIMAL(5,2) DEFAULT 0,
    current_occupied INTEGER NOT NULL DEFAULT 0,
    table_status VARCHAR(20) NOT NULL DEFAULT 'empty' CHECK (table_status IN ('empty', 'partial', 'full', 'reserved')),
    special_features TEXT[],
    notes TEXT,
    UNIQUE(seating_section_id, table_number)
);

CREATE INDEX idx_seating_tables_section ON seating_tables(seating_section_id);

CREATE TABLE table_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seating_table_id UUID NOT NULL REFERENCES seating_tables(id) ON DELETE CASCADE,
    guest_family_id UUID REFERENCES guest_families(id) ON DELETE SET NULL,
    guest_person_id UUID REFERENCES guest_people(id) ON DELETE SET NULL,
    seat_count INTEGER NOT NULL CHECK (seat_count > 0),
    assignment_type VARCHAR(20) NOT NULL DEFAULT 'confirmed' CHECK (assignment_type IN ('confirmed', 'tentative', 'placeholder')),
    assigned_by_user_id UUID NOT NULL REFERENCES users(id),
    assigned_at TIMESTAMP NOT NULL DEFAULT NOW(),
    preferences_notes TEXT,
    CHECK (guest_family_id IS NOT NULL OR guest_person_id IS NOT NULL),
    UNIQUE(seating_table_id, guest_family_id, guest_person_id)
);

CREATE INDEX idx_table_assignments_table ON table_assignments(seating_table_id);
CREATE INDEX idx_table_assignments_guest ON table_assignments(guest_family_id);

CREATE TABLE seating_conflicts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seating_layout_id UUID NOT NULL REFERENCES seating_layouts(id) ON DELETE CASCADE,
    conflict_type VARCHAR(50) NOT NULL CHECK (conflict_type IN ('over_capacity', 'segregation_violation', 'accessibility_issue', 'relationship_conflict', 'distance_too_far')),
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('critical', 'warning', 'suggestion')),
    description TEXT NOT NULL,
    affected_table_ids UUID[],
    affected_guest_ids UUID[],
    suggested_resolution TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'acknowledged', 'resolved', 'ignored')),
    detected_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_seating_conflicts_layout ON seating_conflicts(seating_layout_id, status);

CREATE TABLE seating_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    guest_family_id UUID NOT NULL REFERENCES guest_families(id) ON DELETE CASCADE,
    preference_type VARCHAR(50) NOT NULL CHECK (preference_type IN ('sit_with', 'sit_near', 'avoid', 'accessibility_needed', 'section_preference')),
    related_guest_family_id UUID REFERENCES guest_families(id) ON DELETE SET NULL,
    preferred_section_type VARCHAR(50),
    accessibility_requirements TEXT[],
    priority VARCHAR(20) NOT NULL DEFAULT 'preferred' CHECK (priority IN ('must_have', 'preferred', 'nice_to_have')),
    reason TEXT,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_seating_prefs_wedding ON seating_preferences(wedding_project_id);

CREATE TABLE auto_seating_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    rule_type VARCHAR(50) NOT NULL CHECK (rule_type IN ('family_together', 'side_separation', 'vip_priority', 'elderly_proximity', 'children_grouping', 'balance_tables')),
    rule_parameters JSONB NOT NULL DEFAULT '{}',
    is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    priority_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- FEATURE 12: MULTI-CURRENCY & PAYMENT GATEWAY INTEGRATION
-- ============================================================================

CREATE TABLE payment_gateways (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gateway_name TEXT NOT NULL,
    gateway_code VARCHAR(50) UNIQUE NOT NULL,
    supported_currencies TEXT[] NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    processing_fee_percentage DECIMAL(5,2) DEFAULT 0,
    processing_fee_fixed DECIMAL(12,2) DEFAULT 0,
    settlement_time_days INTEGER DEFAULT 1,
    logo_url TEXT,
    configuration JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE payment_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID REFERENCES wedding_projects(id) ON DELETE CASCADE,
    account_type VARCHAR(50) NOT NULL CHECK (account_type IN ('jazzcash_wallet', 'easypaisa_wallet', 'bank_account', 'credit_card')),
    account_holder_name TEXT NOT NULL,
    account_details JSONB NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    verification_method VARCHAR(50) CHECK (verification_method IN ('manual', 'otp', 'document_upload')),
    added_by_user_id UUID NOT NULL REFERENCES users(id),
    added_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payment_accounts_wedding ON payment_accounts(wedding_project_id);

CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    payment_id UUID, -- Links to existing payments table if present
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('deposit', 'advance_payment', 'final_payment', 'refund', 'salami_gift')),
    amount DECIMAL(14,2) NOT NULL CHECK (amount > 0),
    currency VARCHAR(3) NOT NULL DEFAULT 'PKR',
    exchange_rate DECIMAL(10,6) DEFAULT 1,
    amount_in_base_currency DECIMAL(14,2) NOT NULL,
    gateway_id UUID REFERENCES payment_gateways(id),
    gateway_transaction_id TEXT,
    payer_account_id UUID REFERENCES payment_accounts(id) ON DELETE SET NULL,
    payee_type VARCHAR(20) CHECK (payee_type IN ('vendor', 'wedding_project', 'external')),
    payee_vendor_id UUID REFERENCES vendors(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'refunded', 'disputed')),
    initiated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMP,
    failure_reason TEXT,
    receipt_url TEXT,
    metadata JSONB
);

CREATE INDEX idx_payment_tx_wedding ON payment_transactions(wedding_project_id);
CREATE INDEX idx_payment_tx_status ON payment_transactions(status);

CREATE TABLE payment_splits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID, -- Links to core payments table or transaction
    payment_transaction_id UUID REFERENCES payment_transactions(id) ON DELETE SET NULL,
    split_type VARCHAR(20) NOT NULL CHECK (split_type IN ('percentage', 'fixed_amount')),
    payer_label TEXT NOT NULL,
    payer_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    split_percentage DECIMAL(5,2),
    split_amount DECIMAL(14,2),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue')),
    due_date DATE,
    paid_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payment_splits_payer ON payment_splits(payer_user_id);

CREATE TABLE currency_exchange_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_currency VARCHAR(3) NOT NULL,
    to_currency VARCHAR(3) NOT NULL,
    rate DECIMAL(10,6) NOT NULL,
    effective_date DATE NOT NULL,
    source TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(from_currency, to_currency, effective_date)
);

CREATE TABLE payment_reminders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID,
    reminder_type VARCHAR(50) NOT NULL CHECK (reminder_type IN ('upcoming_due', 'overdue', 'final_notice')),
    scheduled_for TIMESTAMP NOT NULL,
    sent_at TIMESTAMP,
    recipient_user_ids UUID[],
    message_template TEXT,
    notification_channels TEXT[],
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'sent', 'failed'))
);

CREATE INDEX idx_payment_reminders_status ON payment_reminders(status, scheduled_for);

CREATE TABLE payment_disputes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_transaction_id UUID NOT NULL REFERENCES payment_transactions(id) ON DELETE CASCADE,
    dispute_type VARCHAR(50) NOT NULL CHECK (dispute_type IN ('amount_mismatch', 'service_not_delivered', 'double_charge', 'fraud')),
    disputed_by_user_id UUID NOT NULL REFERENCES users(id),
    disputed_amount DECIMAL(14,2) NOT NULL,
    description TEXT NOT NULL,
    evidence_urls TEXT[],
    status VARCHAR(20) NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'investigating', 'resolved_refund', 'resolved_no_action', 'closed')),
    opened_at TIMESTAMP NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMP,
    resolution_notes TEXT
);

-- ============================================================================
-- FEATURE 13: COMPREHENSIVE NOTIFICATION SYSTEM
-- ============================================================================

CREATE TABLE notification_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_code VARCHAR(100) UNIQUE NOT NULL,
    template_name TEXT NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('guest_updates', 'payment_reminders', 'vendor_communication', 'event_alerts', 'system_notifications')),
    default_title TEXT NOT NULL,
    default_body TEXT NOT NULL,
    variables TEXT[],
    supported_channels TEXT[] NOT NULL DEFAULT ARRAY['in_app'],
    default_priority VARCHAR(20) NOT NULL DEFAULT 'low',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE notification_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    wedding_project_id UUID REFERENCES wedding_projects(id) ON DELETE CASCADE,
    preferences JSONB NOT NULL DEFAULT '{}',
    quiet_hours_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    timezone VARCHAR(50) NOT NULL DEFAULT 'UTC',
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    wedding_project_id UUID REFERENCES wedding_projects(id) ON DELETE CASCADE,
    template_code VARCHAR(100) REFERENCES notification_templates(template_code),
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data_payload JSONB,
    channels TEXT[],
    priority VARCHAR(20) NOT NULL DEFAULT 'low' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    category VARCHAR(50),
    scheduled_for TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP
);

CREATE INDEX idx_notifications_recipient ON notifications(recipient_user_id, created_at DESC);
CREATE INDEX idx_notifications_schedule ON notifications(scheduled_for) WHERE scheduled_for IS NOT NULL;

CREATE TABLE notification_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID NOT NULL REFERENCES notifications(id) ON DELETE CASCADE,
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'sms', 'email', 'in_app')),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'delivered', 'failed', 'clicked', 'dismissed')),
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    clicked_at TIMESTAMP,
    failure_reason TEXT,
    external_provider_id TEXT,
    retry_count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE notification_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID NOT NULL REFERENCES notifications(id) ON DELETE CASCADE,
    action_type VARCHAR(20) NOT NULL CHECK (action_type IN ('deep_link', 'api_call', 'dismiss')),
    action_label TEXT NOT NULL,
    action_data JSONB,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE scheduled_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_project_id UUID NOT NULL REFERENCES wedding_projects(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE SET NULL,
    schedule_type VARCHAR(20) NOT NULL CHECK (schedule_type IN ('one_time', 'recurring', 'event_based')),
    trigger_condition JSONB NOT NULL,
    template_code VARCHAR(100) NOT NULL REFERENCES notification_templates(template_code),
    recipients_filter JSONB NOT NULL,
    next_execution_at TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE notification_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_name TEXT NOT NULL,
    total_recipients INTEGER NOT NULL DEFAULT 0,
    sent_count INTEGER NOT NULL DEFAULT 0,
    delivered_count INTEGER NOT NULL DEFAULT 0,
    failed_count INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'preparing' CHECK (status IN ('preparing', 'sending', 'completed', 'failed')),
    started_at TIMESTAMP NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMP
);

-- ============================================================================
-- AUTO-UPDATE TRIGGERS FOR NEW TABLES
-- ============================================================================

CREATE TRIGGER update_seating_layouts_updated_at BEFORE UPDATE ON seating_layouts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_notification_preferences_updated_at BEFORE UPDATE ON notification_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

