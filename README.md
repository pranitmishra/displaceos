# DisplaceOS - Disaster Relief Assistance Platform

A mobile-first emergency relief progressive web application built with **React**, **Tailwind CSS**, **Supabase (PostgreSQL, Storage, Auth)**, and **Leaflet / OpenStreetMap**.

Designed for rapid, intuitive civilian emergency reporting during natural disasters, floods, earthquakes, and humanitarian crises.

---

## 🌟 Key Features

### 1. Mobile-First Civilian Homepage (Matching Visual Mockup)
- **Top Header**: Custom brand logo with `DisplaceOS`, sub-caption `Disaster relief assistance`, and multi-language globe icon.
- **Pictograph Grid**: Large pictograph buttons designed for urgent tap selection:
  - 🍲 **Food**: Steaming pot icon
  - 💧 **Water**: Vivid water droplet icon
  - 🩺 **Medicine**: Medical stethoscope icon
  - 🛟 **Rescue**: Lifebuoy ring icon
  - ⛺ **Shelter**: Camping tent icon
  - 🚨 **Other (SOS)**: Emergency badge icon
- **Prominent Photo Attachment**:
  - Direct camera trigger with `capture="environment"`
  - Live photo preview with file details and remove option
- **Dynamic White Pill Action Button**:
  - `Continue with [Selected Category] →` or `Send Photo Report →`
- **Official Login Button**:
  - Bottom shortcut to access official operations.

### 2. Device Geolocation & Geofencing Restriction
- Automatically requests device GPS location on launch.
- **Inside Disaster Zone**: Citizen can tap any category, attach photos, and dispatch assistance requests.
- **Outside Disaster Zone**: All request buttons and camera uploads are automatically locked with an informative safety alert explaining that submissions are restricted to the active disaster perimeter.
- **Instant Simulator Toggle**: A top bar allows testers and officials to switch between **Inside Zone** and **Far Away (Outside Zone)** with a single click.

### 3. Redirection Flows
1. **Photo Report Flow**:
   - Tap "Add photo feature" -> select/capture photo.
   - Click `Send Photo Report →` -> redirects to verification page -> sends to Supabase Storage & Database.
   - Displays confirmation: **"Photo submitted successfully"** with a 3-second auto-redirect back to Page 1.
2. **Category Assistance Flow**:
   - Select Food, Water, Medicine, Rescue, Shelter, or SOS.
   - Click `Continue with [Category] →` -> redirects to Request Details & GPS Leaflet Map confirmation.
   - Specify number of people and optional landmark notes.
   - Click `Confirm & Send Request →` -> inserts record into Supabase PostgreSQL.
   - Displays confirmation: **"Request submitted, we will reach as soon as possible"** with emergency beacon ID and 3-second countdown redirect back to Page 1.

### 4. Official Command Center (`Password: 1234`)
- Click **Official Login** from homepage -> enter passkey `1234`.
- **Live Interactive Map (Leaflet + OpenStreetMap)**:
  - Shows the active Disaster Zone circle and radius in km.
  - Color-coded pins for every incoming emergency beacon.
  - Click any pin to view victim details, contact notes, and photos.
- **Emergency Dispatch Queue**:
  - Real-time queue filtered by category and urgency.
  - 1-click status actions: `Dispatch Team`, `Mark Resolved`.
- **Photo Incident Feed**:
  - Gallery of damage photos with full-screen lightbox modal.
- **Geofence Controller**:
  - Officials can adjust the disaster epicenter coordinates and perimeter radius (1 - 100 km).

---

## 🚀 How to Run the Application

### Option A: Instant Run (No Node.js or Setup Required)
You can directly open `index.html` in any browser:
```powershell
# Double-click index.html or run in PowerShell:
Start-Process "d:\DisplaceOS\index.html"
```
Or start the included local HTTP server:
```powershell
.\start_server.ps1
```
Open **`http://localhost:3000`** in your browser or test on your mobile phone on the same Wi-Fi!

---

### Option B: Modern Vite + React Toolchain (If Node.js is installed)
```bash
# 1. Install dependencies
npm install

# 2. Start dev server
npm run dev

# 3. Build for production
npm run build
```

---

## 🗄️ Supabase PostgreSQL & Storage Setup

1. Create a free project at [supabase.com](https://supabase.com).
2. Go to the **SQL Editor** in your Supabase dashboard and run the provided SQL script:
   - **`supabase_schema.sql`**
3. Create a public storage bucket named **`disaster-photos`**:
   - Go to **Storage** -> **New Bucket** -> Name: `disaster-photos` -> Check **Public bucket**.
4. Configure your credentials:
   - Copy your `Project URL` and `anon public key` from **Project Settings** -> **API**.
   - Either add them to `.env`:
     ```env
     VITE_SUPABASE_URL=https://your-project.supabase.co
     VITE_SUPABASE_ANON_KEY=your-anon-key
     ```
   - OR enter them directly inside the **Official Operations Dashboard -> Geofence & Supabase Settings** tab!

