# 🐔 CluckScout — FRC Scouting App

**Part of the Chicken Suite — Offline-First FRC Scouting Ecosystem**

CluckScout is the Android scouting app for FRC teams, designed to work completely offline with seamless data upload capabilities to RoostHub via USB. Built for the unpredictability of competition networks, it stores all match data locally while offering flexible upload options when needed.

## 🚧 Development Status

CluckScout is currently in active development. Recent improvements include:
- ✅ Enhanced USB upload capabilities
- 🚧 Firebase integration being improved
- 🚧 Code cleanup and optimization
- 🚧 UI/UX enhancements

**Note**: Most active development is happening in [RoostHub](https://github.com/team/roosthub) - the central command center for the Chicken Suite ecosystem.

## 🐔 About Chicken Suite

Chicken Suite is a comprehensive scouting platform built for flexibility, offline compatibility, and ease of use. Designed with the unpredictability of competition networks in mind, it allows teams to scout and manage match data completely offline—or sync data across devices when Wi-Fi is available.

### 📱 CluckScout — Scouting Made Simple

CluckScout is the Android-friendly scouting app in the Chicken Suite ecosystem.

**Key Features:**
- **Device Assignment**: Assign tablets to specific match positions, scouters, and teams
- **Offline-first Data Storage**: Every match is saved to a local SQLite database
- **Flexible Upload Options**:
  - **QR Code Sync**: Generate QR codes per match for quick manual uploads
  - **USB Sync to RoostHub**: Plug in the tablet and let RoostHub automatically detect and upload data

### 🖥️ RoostHub — The Central Command Center

RoostHub serves as the data hub of the suite, optimized for both live events and post-match analysis. It seamlessly receives data from CluckScout tablets via USB.

**Current Features:**
- **Automatic USB Sync**: Seamlessly receives data from connected CluckScout tablets
- **Match Data Management**: Store and organize scouting data locally
- **Match Analytics**: View data visualizations, team rankings, and performance metrics

**Planned Features:**
- **Picklist Tool**: Build, sort, and update your picklist dynamically with integrated data
- **Export Options**: Export all scouting data to .csv or Excel format for external analysis

### ☁️ CoopCloud — Optional Cloud Sync

For teams that want cross-device syncing or cloud backups, CoopCloud will provide:
- **Multi-device Sync**: Connect multiple RoostHub instances
- **Data Privacy First**: Opt-in cloud sync with complete data privacy
- **Offline Compatibility**: Manual sync options without internet access

*Note: CoopCloud is still in development*

## 🚀 Getting Started

### Prerequisites

**Flutter Development Environment**: CluckScout is built with Flutter for Android deployment.

- **Flutter SDK**: Download and install [Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio**: Required for Android development and device debugging
- **USB Debugging**: Enable developer options on Android tablets for deployment

### Development Setup

First, ensure Flutter is properly installed and configured:

```bash
flutter doctor
```

Then get dependencies and run the app:

```bash
flutter pub get
flutter run
```

### Building for Production

```bash
flutter build apk --release
```

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Database**: SQLite (via sqflite)
- **State Management**: Provider
- **Platform**: Android tablets

## 📊 FRC Integration

CluckScout is designed specifically for FRC (FIRST Robotics Competition) scouting workflows, with features tailored to:
- Real-time match data collection
- Team performance tracking on tablets
- Offline-first data storage
- Seamless data upload to RoostHub
- Position-based scouting assignments
