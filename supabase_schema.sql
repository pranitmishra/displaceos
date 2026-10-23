-- ==============================================================================
-- DisplaceOS - Disaster Relief Assistance Database Schema
-- Supabase PostgreSQL Setup Script
-- ==============================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Create Disaster Zones Table
CREATE TABLE IF NOT EXISTS public.disaster_zones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL DEFAULT 'Primary Disaster Area',
    latitude NUMERIC(10, 7) NOT NULL,
    longitude NUMERIC(10, 7) NOT NULL,
    radius_km NUMERIC(6, 2) NOT NULL DEFAULT 25.00,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 3. Create Relief Requests Table
CREATE TABLE IF NOT EXISTS public.relief_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category TEXT NOT NULL CHECK (category IN ('food', 'water', 'medicine', 'rescue', 'shelter', 'sos', 'photo_report', 'other')),
    latitude NUMERIC(10, 7) NOT NULL,
    longitude NUMERIC(10, 7) NOT NULL,
    photo_url TEXT,
    notes TEXT,
    people_count INTEGER DEFAULT 1,
    urgency TEXT DEFAULT 'high' CHECK (urgency IN ('critical', 'high', 'medium', 'low')),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'dispatched', 'resolved')),
    contact_info TEXT,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Create Indexes for performance
CREATE INDEX IF NOT EXISTS idx_relief_requests_category ON public.relief_requests(category);
CREATE INDEX IF NOT EXISTS idx_relief_requests_status ON public.relief_requests(status);
CREATE INDEX IF NOT EXISTS idx_relief_requests_created_at ON public.relief_requests(created_at DESC);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.relief_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.disaster_zones ENABLE ROW LEVEL SECURITY;

-- 5. Policies for relief_requests
-- Anyone (victims in affected zone) can insert emergency relief requests
CREATE POLICY "Allow public insert to relief_requests" 
    ON public.relief_requests 
    FOR INSERT 
    WITH CHECK (true);

-- Anyone can read requests (for officials and live status tracking)
CREATE POLICY "Allow public select on relief_requests" 
    ON public.relief_requests 
    FOR SELECT 
    USING (true);

-- Allow updates (e.g., status changes to dispatched/resolved by officials)
CREATE POLICY "Allow public update on relief_requests" 
    ON public.relief_requests 
    FOR UPDATE 
    USING (true)
    WITH CHECK (true);

-- 6. Policies for disaster_zones
CREATE POLICY "Allow public select on disaster_zones" 
    ON public.disaster_zones 
    FOR SELECT 
    USING (true);

CREATE POLICY "Allow public update on disaster_zones" 
    ON public.disaster_zones 
    FOR ALL 
    USING (true);

-- 7. Insert Initial Active Disaster Zone
INSERT INTO public.disaster_zones (name, latitude, longitude, radius_km, is_active)
VALUES ('Disaster Operations Area Alpha', 28.6139000, 77.2090000, 30.00, true)
ON CONFLICT DO NOTHING;

-- 8. Insert Sample Demonstration Emergency Requests
INSERT INTO public.relief_requests (category, latitude, longitude, notes, people_count, urgency, status)
VALUES 
    ('rescue', 28.6145000, 77.2105000, 'Water level rising, elderly family trapped on 2nd floor terrace', 4, 'critical', 'pending'),
    ('food', 28.6180000, 77.2060000, 'Need dry food rations and baby formula urgently', 3, 'high', 'dispatched'),
    ('medicine', 28.6110000, 77.2150000, 'Diabetic insulin and clean bandages needed', 2, 'critical', 'in_progress'),
    ('water', 28.6220000, 77.2010000, 'Contaminated local supply, need clean drinking water cans', 6, 'high', 'pending'),
    ('shelter', 28.6080000, 77.2120000, 'Roof collapsed, need tarp and emergency tent shelter', 5, 'high', 'pending')
ON CONFLICT DO NOTHING;

-- ==============================================================================
-- Storage Bucket Setup for Photos
-- In Supabase dashboard:
-- 1. Go to Storage -> Create bucket named: "disaster-photos"
-- 2. Mark the bucket as "Public"
-- Or run this in SQL editor if storage schema is accessible:
-- ==============================================================================
INSERT INTO storage.buckets (id, name, public) 
VALUES ('disaster-photos', 'disaster-photos', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Public disaster photos can be uploaded" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'disaster-photos');

CREATE POLICY "Public disaster photos can be viewed" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'disaster-photos');

