 <div align="center">

# 🌐 EIOP - Everything In One Place

### The All-in-One City Services Platform (Super App)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20Web-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)

**Everything you need in your city — all in one powerful and integrated application!**

Restaurants, supermarkets, pharmacies, electronics, fashion, real estate, jobs, and parcel delivery services, all in one place.

---

</div>

## 📌 Overview

**EIOP (Everything In One Place)** is an all-in-one Super App designed to serve city residents by bringing essential everyday services together in a single, unified platform.

Built with **Flutter** and **Material Design 3**, EIOP aims to deliver a smooth, fast, and modern user experience through an intuitive interface that connects users with local businesses and convenient city services.

Whether users want to order food, shop for groceries, browse electronics, find a property, search for a job, or request a parcel delivery, EIOP provides a centralized platform to access these services.

---

## 🌟 The 8 Core Services

| Service | Icon | Description and Features |
| :--- | :---: | :--- |
| **Restaurants & Food** | 🍔 | Explore local restaurants, fast food, and traditional meals, including available options and sizes. |
| **Supermarket & Groceries** | 🛒 | Browse groceries, dairy products, vegetables, and household essentials with quick add-to-cart functionality. |
| **Pharmacies & Healthcare** | 💊 | Browse medicines and healthcare supplies, with an option to take or upload a photo of a medical prescription. |
| **Electronics & Smartphones** | 📱 | Explore smartphones and accessories, with official warranty options and fast delivery. |
| **Fashion & Clothing** | 👗 | Discover clothing, shoes, and collections from local retailers, with an optional try-on-at-delivery feature. |
| **Real Estate & Properties** | 🏡 | Browse apartments, shops, and land for rent or sale, with direct phone and WhatsApp contact options. |
| **Jobs & Career Opportunities** | 💼 | Discover local job opportunities and contact employers directly. |
| **Parcel Delivery & Errands** | 📦 | Request an **EIOP Express** courier to deliver parcels, documents, and personal items. |

---

## ✨ Key Features

- **Quick Service Hub:** Access all eight service categories through a dedicated grid featuring custom cards and visually distinct colors.
- **Dynamic Dark and Light Modes:** Switch between elegant dark and light themes with smooth animations.
- **Universal Shopping Cart:** A unified shopping experience designed to bring products, meals, and purchases from multiple service categories together.
- **Live Order Tracking:** A floating bottom bar designed to display updates for food orders, grocery purchases, and courier deliveries in real time.
- **Direct Contact:** Integrated phone and WhatsApp contact options for real estate listings and job opportunities.
- **Cross-Platform Support:** Designed to support Android, iOS, Windows Desktop, and Web through Flutter.

---

## 📂 Project Structure

```text
EIOP/
├── assets/
│   └── images/                       # Images, backgrounds, and service icons
├── lib/
│   ├── models/                       # Data models
│   │   ├── service_type.dart         # The 8 service categories
│   │   ├── supermarket_item.dart     # Supermarket products and groceries
│   │   ├── pharmacy_item.dart        # Pharmacy items and prescriptions
│   │   ├── electronics_item.dart     # Electronics and smartphones
│   │   ├── fashion_item.dart         # Clothing and fashion products
│   │   ├── property_item.dart        # Real estate listings
│   │   ├── job_item.dart             # Jobs and career opportunities
│   │   └── parcel_delivery_request.dart
│   ├── screens/                      # Main and service-specific screens
│   │   ├── home_screen.dart          # Main home screen
│   │   ├── main_layout_screen.dart   # Main layout and navigation
│   │   ├── parcel_delivery_screen.dart
│   │   ├── supermarket_screen.dart  # Supermarket screen
│   │   ├── pharmacy_screen.dart     # Pharmacy and prescription screen
│   │   ├── electronics_screen.dart  # Electronics screen
│   │   ├── fashion_screen.dart      # Fashion screen
│   │   ├── real_estate_screen.dart  # Real estate screen
│   │   └── jobs_screen.dart         # Jobs screen
│   ├── theme/                        # Colors, gradients, and app themes
│   └── widgets/                      # Reusable UI components
│       ├── what_do_you_need_grid.dart
│       ├── property_card.dart        # Property listing card
│       ├── job_card.dart             # Job listing card
│       └── multi_service_product_card.dart
├── pubspec.yaml                      # Dependencies and package configuration
└── README.md                         # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have the following tools installed:

- **Flutter SDK** (version 3.11 or compatible with the project)
- **Dart SDK**
- **Android Studio** or **Visual Studio Code**
- **Windows C++ Build Tools** for Windows Desktop development
- A supported browser, such as Google Chrome, for Web development
- An Android emulator, iOS simulator, or physical device for mobile development

### Installation and Setup

**1. Clone the repository**

```bash
git clone https://github.com/khaledibrahim1/EIOP.git
cd EIOP
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Run the application**

For Windows Desktop:

```bash
flutter run -d windows
```

For Web:

```bash
flutter run -d chrome
```

For Android or an available mobile device:

```bash
flutter run
```

For iOS, use a supported macOS development environment with Xcode configured.

### Build the Application

Build an Android APK:

```bash
flutter build apk --release
```

Build for Windows Desktop:

```bash
flutter build windows --release
```

Build for Web:

```bash
flutter build web --release
```

---

## 🎨 Design System

EIOP follows a modern visual identity focused on consistency, clarity, and ease of use.

- **Primary Colors:**
  - Orange Sunset: `#FF5216`
  - Emerald Green: `#10B981`
  - Cyber Cyan: `#06B6D4`
  - Royal Violet: `#8B5CF6`
- **Typography:** Tajawal Arabic font through the `google_fonts` package, where configured.
- **UI Framework:** Flutter with Material Design 3.
- **Icons:** Material Design icons with curved and rounded visual elements.
- **Theming:** Dark and light modes with consistent colors and components.

---

## 🛠️ Technology Stack

| Technology | Purpose |
| :--- | :--- |
| **Flutter** | Cross-platform application development |
| **Dart** | Application programming language |
| **Material Design 3** | Modern UI components and design system |
| **Google Fonts** | Typography customization |
| **Android / iOS / Windows / Web** | Target deployment platforms |

---

## 🔮 Project Vision

The long-term vision of EIOP is to simplify everyday life by connecting residents, local businesses, service providers, and delivery couriers through a single digital platform.

By bringing essential services together, EIOP aims to improve convenience, support local businesses, and make accessing city services easier and more efficient.

---

## 📄 License

This project is intended to use the **MIT License**. Ensure that a `LICENSE` file containing the MIT License text is included in the repository before distributing the project under that license.

---

<div align="center">

**EIOP — Your City. Your Services. One Place. ❤️**

*Designed and developed with Flutter.*

</div>
