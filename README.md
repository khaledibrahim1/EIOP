<div align="center">

# 🌐 EIOP - Everything In One Place

### منصة خدمات المدينة الشاملة (Super App)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20Web-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)

<p align="center">
  <b>كل ما تحتاجه في مدينتك... في تطبيق واحد فريد ومتكامل!</b>
  <br />
  تطبيقات المأكولات، السوبرماركت، الصيدليات، الإلكترونيات، الأزياء، العقارات، الوظائف، وتوصيل الطرود في مكان واحد.
</p>

---

</div>

## 📌 عن المشروع (Overview)

تطبيق **EIOP (Everything In One Place)** هو منصة سوبر-أب (Super App) مخصصة لخدمة أهالي وسكان المدينة، تم تصميمها وتطويرها بأحدث تقنيات Flutter و Material Design 3، لتوفير تجربة مستخدم سلسة وفائقة السرعة تجمع كل متطلبات الحياة اليومية في واجهة موحدة وفاخرة.

---

## 🌟 الخدمات 8 الرئيسية المتاحة (Core Services Hub)

<div align="center">

| الخدمة                  | الشعار | الوصف والخصائص                                                            |
| :---------------------- | :----: | :------------------------------------------------------------------------ |
| **مطاعم ومأكولات**      |   🍔   | تصفح قائمة المطاعم المحلية، الوجبات السريعة والشرقية، الخيارات والأحجام   |
| **سوبر ماركت ومؤن**     |   🛒   | البقالة، الألبان، الخضروات، والمؤن المنزلية مع إضافة سريعة للسلة          |
| **صيدليات ورعاية صحية** |   💊   | تصفح الأدوية والمستلزمات + **خدمة تصوير ورفع صورة الروشتة الطبية**        |
| **إلكترونيات وهواتف**   |   📱   | أحدث الموبايلات والإكسسوارات بضمان رسمي وتوصيل فوري                       |
| **أزياء وموضة**         |   👗   | تشكيلات الملابس والأحذية من أشهر المعارض مع خيار التجربة عند الاستلام     |
| **عقارات وأملاك**       |   🏡   | شقق ومحلات وأراضي (للإيجار والبيع) مع أزرار **الاتصال والواتساب المباشر** |
| **وظائف وفرص عمل**      |   💼   | استعراض فرص العمل اليومية بالمدينة والتواصل المباشر مع أصحاب الأعمال      |
| **توصيل طرود ومرسول**   |   📦   | خدمة استدعاء مندوب خاص **EIOP Express** ونقل الأمانات والطرود فوراً       |

</div>

---

## ✨ المميزات التنافسية (Key Features)

- **شبكة "ماذا تريد الآن؟" (Featured Quick Hub Grid):** وصول خاطف لجميع الأقسام بكروت مخصصة وألوان بصرية مريحة.
- **الوضع الداكن والفاتح (Dynamic Dark & Light Mode):** دعم كامل للثيم الليلي الفاخر بمفاتيح تبديل أنيميشن سلسة.
- **سلة تسوق موحدة (Universal Cart):** تجمع المنتجات والوجبات والمشتريات من كافة القطاعات في طلب واحد.
- **تتبع الطلبات الحية (Live Order Tracking Bar):** شريط سفلي عائم يتابع طلبات الوجبات والمشتريات وشحنات المرسول لحظة بلحظة.
- **تواصل مباشر بدون وسيط (Direct Contact):** ربط أزرار الاتصال الهاتفي ومحادثات الواتساب المباشرة في شاشتي العقارات والوظائف.
- **دعم متعدد المنصات (Cross-Platform):** يعمل بكفاءة عالية على Android و iOS و Windows Desktop و Web.

---

## 📂 هيكل المشروع (Project Structure)

```text
EIOP/
├── assets/
│   └── images/                # الصور والخلفيات وأيقونات الخدمات
├── lib/
│   ├── models/                # نماذج البيانات (Data Models)
│   │   ├── service_type.dart           # أنواع الخدمات الـ 8
│   │   ├── supermarket_item.dart       # المنتجات والبقالة
│   │   ├── pharmacy_item.dart          # الصيدلية والروشتة
│   │   ├── electronics_item.dart       # الإلكترونيات والهواتف
│   │   ├── fashion_item.dart           # الملابس والأزياء
│   │   ├── property_item.dart          # العقارات والأملاك
│   │   ├── job_item.dart               # الوظائف والفرص
│   │   └── parcel_delivery_request.dart # توصيل مرسول والطرود
│   ├── screens/               # الشاشات الرئيسية والتفصيلية
│   │   ├── home_screen.dart            # الصفحة الرئيسية الشاملة
│   │   ├── main_layout_screen.dart     # الهيكل وشريط التنقل
│   │   ├── parcel_delivery_screen.dart # شاشة طلب توصيل طرد
│   │   ├── supermarket_screen.dart     # شاشة السوبرماركت
│   │   ├── pharmacy_screen.dart        # شاشة الصيدلية والروشتة
│   │   ├── electronics_screen.dart     # شاشة الإلكترونيات
│   │   ├── fashion_screen.dart         # شاشة الأزياء
│   │   ├── real_estate_screen.dart     # شاشة العقارات والأملاك
│   │   └── jobs_screen.dart            # شاشة الوظائف
│   ├── theme/                 # ثيمات الألوان والجرادينت (AppColors)
│   └── widgets/               # المكونات الكروت والشبكات التفاعلية
│       ├── what_do_you_need_grid.dart  # شبكة "ماذا تريد الآن؟"
│       ├── property_card.dart          # كارت العقارات والتواصل
│       ├── job_card.dart               # كارت الوظائف والتقديم
│       └── multi_service_product_card.dart # كارت منتجات التسوق
├── pubspec.yaml               # ملف الحزم والاعتمادات
└── README.md                  # توثيق المشروع
```

---

## 🚀 كيفية تشغيل المشروع (Getting Started)

### المتطلبات الأساسية (Prerequisites)

- بيئة تطوير **Flutter SDK (v3.11+)**
- حزمة **Dart SDK**
- بيئة تشغيل (Android Studio / VS Code / Windows C++ Build Tools)

### خطوات التشغيل (Run Steps)

1. **استنساخ المستودع (Clone Repository):**

   ```bash
   git clone https://github.com/khaledibrahim1/EIOP.git
   cd EIOP
   ```

2. **تحميل الاعتمادات والحزم (Get Dependencies):**

   ```bash
   flutter pub get
   ```

3. **تشغيل التطبيق (Run Application):**
   - **على الويندوز (Windows Desktop):**
     ```bash
     flutter run -d windows
     ```
   - **على المتصفح (Web):**
     ```bash
     flutter run -d chrome
     ```
   - **على الجوال (Android/iOS):**
     ```bash
     flutter run
     ```

---

## 🎨 الهوية والتصميم (Design System)

- **الألوان الرئيسية:** Orange Sunset (`#FFFF5216`), Emerald Green (`#10B981`), Cyber Cyan (`#06B6D4`), Royal Violet (`#8B5CF6`).
- **الخطوط (Typography):** خط Tajawal العربي الفاخر عبر `google_fonts`.
- **الأيقونات (Icons):** Material 3 Curved Icons.

---

<div align="center">

**تطوير وتصميم منصة EIOP Super App بكل فخر ❤️**

</div>
