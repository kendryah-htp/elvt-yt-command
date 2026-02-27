-- ═══════════════════════════════════════════════════
-- ELVT YouTube Command Center — Supabase Schema
-- Paste this into: https://supabase.com/dashboard/project/jajtyudbkyrqklbnaggm/sql/new
-- Click RUN. Done.
-- ═══════════════════════════════════════════════════

-- Clean slate
DROP TABLE IF EXISTS yt_calendar CASCADE;
DROP TABLE IF EXISTS yt_favorites CASCADE;
DROP TABLE IF EXISTS yt_briefs CASCADE;
DROP TABLE IF EXISTS yt_users CASCADE;

-- Users
CREATE TABLE yt_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    pw TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Content Briefs
CREATE TABLE yt_briefs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES yt_users(id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    brief_data JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Favorite Niches
CREATE TABLE yt_favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES yt_users(id) ON DELETE CASCADE,
    niche_id TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(user_id, niche_id)
);

-- Calendar Events
CREATE TABLE yt_calendar (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES yt_users(id) ON DELETE CASCADE,
    yr INT NOT NULL,
    mo INT NOT NULL,
    dy INT NOT NULL,
    event TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Site Content (admin-editable photos, text, trust factors)
CREATE TABLE yt_site_content (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Row Level Security
ALTER TABLE yt_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE yt_briefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE yt_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE yt_calendar ENABLE ROW LEVEL SECURITY;

ALTER TABLE yt_site_content ENABLE ROW LEVEL SECURITY;

-- Open policies (app-level auth handles access)
CREATE POLICY "yt_users_all" ON yt_users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "yt_briefs_all" ON yt_briefs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "yt_favorites_all" ON yt_favorites FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "yt_calendar_all" ON yt_calendar FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "yt_site_content_all" ON yt_site_content FOR ALL USING (true) WITH CHECK (true);

-- Indexes for speed
CREATE INDEX idx_briefs_user ON yt_briefs(user_id);
CREATE INDEX idx_favs_user ON yt_favorites(user_id);
CREATE INDEX idx_cal_user ON yt_calendar(user_id, yr, mo);
