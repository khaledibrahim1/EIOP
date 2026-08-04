import 'package:flutter/material.dart';

class JobItem {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;
  final String jobType; // Full-Time, Part-Time, Shift, Remote
  final String description;
  final List<String> requirements;
  final List<String> responsibilities;
  final String contactPhone;
  final String contactWhatsApp;
  final String publishedDate;
  final bool isUrgent;
  final bool isFeatured;
  final int applicationsCount;
  final double companyRating;
  final int companyReviewPercent;
  final IconData companyLogoIcon;
  final Color companyLogoBg;

  const JobItem({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
    required this.jobType,
    required this.description,
    required this.requirements,
    this.responsibilities = const [],
    required this.contactPhone,
    required this.contactWhatsApp,
    required this.publishedDate,
    this.isUrgent = false,
    this.isFeatured = false,
    this.applicationsCount = 12,
    this.companyRating = 4.8,
    this.companyReviewPercent = 88,
    this.companyLogoIcon = Icons.store_rounded,
    this.companyLogoBg = const Color(0xFF10B981),
  });
}

final List<JobItem> sampleJobs = [
  const JobItem(
    id: 'job_1',
    title: 'مصمم واجهات وتجربة المستخدم (UI/UX)',
    companyName: 'شركة إيوب للتقنية - EIOP Tech',
    location: 'جرجا - برج التجاريين',
    salaryRange: '8,000 - 12,000 ج.م',
    jobType: 'دوام كامل / عن بُعد',
    description: 'نبحث عن مصمم واجهات شغوف لتصميم تطبيقات الهاتف والمواقع الإلكترونية وتحديد رحلة المستخدم بكفاءة عالية.',
    requirements: [
      'خبرة لا تقل عن سنتين في تصميم تطبيقات الموبايل (Figma)',
      'إجادة إعداد الـ Wireframes و Prototyping',
      'فهم كامل لمبادئ التجاوب وتصميم الأنظمة (Design Systems)'
    ],
    responsibilities: [
      'تصميم الواجهات الرسومية للتطبيقات والمواقع',
      'إجراء أبحاث المستخدم واختبارات القابلية للاستخدام',
      'التعاون مع فريق التطوير لضمان دقة التنفيذ'
    ],
    contactPhone: '01099887766',
    contactWhatsApp: '201099887766',
    publishedDate: 'منذ ساعتين',
    isUrgent: true,
    isFeatured: true,
    applicationsCount: 24,
    companyRating: 4.9,
    companyReviewPercent: 94,
    companyLogoIcon: Icons.design_services_rounded,
    companyLogoBg: Color(0xFF10B981),
  ),
  const JobItem(
    id: 'job_2',
    title: 'محاسب مالي وشؤون مبيعات',
    companyName: 'مجموعة المروة للمواد الغذائية',
    location: 'جرجا - شارع المحطة',
    salaryRange: '4,500 - 6,000 ج.م',
    jobType: 'دوام كامل',
    description: 'مطلوب محاسب خبرة سنتين في إعداد الفواتير وتدقيق الحسابات والتعامل مع برنامج Excel وبرامج المحاسبة المالية.',
    requirements: ['بكالوريوس تجارة شعبة محاسبة', 'إجادة برامج المحاسبة وإكسيل', 'الالتزام والتفرغ التام'],
    responsibilities: ['مراجعة القيود اليومية', 'إعداد التقارير الشهرية', 'متابعة حسابات الموردين والعملاء'],
    contactPhone: '01099887766',
    contactWhatsApp: '201099887766',
    publishedDate: 'اليوم',
    isUrgent: true,
    isFeatured: false,
    applicationsCount: 18,
    companyRating: 4.6,
    companyReviewPercent: 86,
    companyLogoIcon: Icons.account_balance_wallet_rounded,
    companyLogoBg: Color(0xFF059669),
  ),
  const JobItem(
    id: 'job_3',
    title: 'مسؤول مبيعات ومعرض إلكترونيات',
    companyName: 'تكنو ستور جرجا',
    location: 'جرجا - الشارع التجاري',
    salaryRange: '3,800 - 5,000 ج.م + عمولة',
    jobType: 'دوام كامل',
    description: 'مطلوب شباب للبائعين داخل معرض أجهزة كهربائية وموبايلات بمهارات تواصل عالية وإجادة البيع المباشر.',
    requirements: ['مؤهل متوسط أو عالي', 'حسن المظهر واللباقة', 'الشغف بمجال التقنية والأجهزة'],
    responsibilities: ['استقبال العملاء بالمعرض', 'عرض المنتجات وشرح المواصفات', 'إقفال عمليات البيع وتحقيق التارجت'],
    contactPhone: '01188776655',
    contactWhatsApp: '201188776655',
    publishedDate: 'منذ أمس',
    isUrgent: false,
    isFeatured: false,
    applicationsCount: 9,
    companyRating: 4.5,
    companyReviewPercent: 82,
    companyLogoIcon: Icons.devices_other_rounded,
    companyLogoBg: Color(0xFF2563EB),
  ),
  const JobItem(
    id: 'job_4',
    title: 'كابتن توصيل ومرسول (طيار)',
    companyName: 'شركة EIOP Express للتوصيل',
    location: 'جرجا - جميع الأحياء',
    salaryRange: '6,000 - 9,000 ج.م',
    jobType: 'دوام مرن / ورديات',
    description: 'انضم لأسطول توصيل EIOP بمدينة جرجا بدخل ممتاز وحوافز يومية مجزية مع توفير زي عمل رسمي.',
    requirements: ['يمتلك موتوسيكل أو دراجة نارية', 'رخصة قيادة سارية', 'معرفة ممتازة بأحياء وشوارع جرجا'],
    responsibilities: ['توصيل الطلبات للعملاء بسرعة وأمان', 'التعامل الرفيع مع الزبائن', 'تسليم المبالغ للشركة يومياً'],
    contactPhone: '01277665544',
    contactWhatsApp: '201277665544',
    publishedDate: 'اليوم',
    isUrgent: true,
    isFeatured: true,
    applicationsCount: 31,
    companyRating: 4.8,
    companyReviewPercent: 91,
    companyLogoIcon: Icons.two_wheeler_rounded,
    companyLogoBg: Color(0xFFF59E0B),
  ),
  const JobItem(
    id: 'job_5',
    title: 'مساعد صيدلي / صيدلي ثانٍ',
    companyName: 'صيدليات مصر الكبرى - فرع جرجا',
    location: 'جرجا - ميدان النهضة',
    salaryRange: '5,000 - 7,500 ج.م',
    jobType: 'ورديات',
    description: 'مطلوب مساعد صيدلي خبرة في صرف الروشتات والتعامل مع الأدوية والأجهزة الطبية بوردية مسائية.',
    requirements: ['مؤهل طب / صيدلة / علوم / تمريض', 'خبرة لا تقل عن سنة بالصيدليات', 'إجادة استخدام الكمبيوتر'],
    responsibilities: ['صرف الروشتات الطبية للعملاء', 'ترتيب وفحص تواريخ صلاحية الدواء', 'إدارة المخزون والصيدلية'],
    contactPhone: '01011223344',
    contactWhatsApp: '201011223344',
    publishedDate: 'اليوم',
    isUrgent: true,
    isFeatured: false,
    applicationsCount: 15,
    companyRating: 4.7,
    companyReviewPercent: 89,
    companyLogoIcon: Icons.medical_services_rounded,
    companyLogoBg: Color(0xFF06B6D4),
  ),
  const JobItem(
    id: 'job_6',
    title: 'شيف وجبات سريعة ومعجنات',
    companyName: 'مطعم وجبتي - Girga Branch',
    location: 'جرجا - شارع الجمهوريه',
    salaryRange: '5,500 - 8,000 ج.م',
    jobType: 'دوام كامل',
    description: 'مطلوب شيف خبرة في تجهيز السندوتشات والبيتزا والوجبات السريعة للعمل ببيئة احترافية ونظيفة.',
    requirements: ['خبرة في المطاعم والوجبات السريعة', 'الالتزام بمعايير النظافة والسرعة', 'شهادة صحية سارية'],
    responsibilities: ['تحضير الطلبات وفق معايير الجودة', 'الحفاظ على نظافة المطبخ والمعدات', 'متابعة المكونات الطازجة'],
    contactPhone: '01144556677',
    contactWhatsApp: '201144556677',
    publishedDate: 'منذ يومين',
    isUrgent: false,
    isFeatured: false,
    applicationsCount: 11,
    companyRating: 4.4,
    companyReviewPercent: 80,
    companyLogoIcon: Icons.fastfood_rounded,
    companyLogoBg: Color(0xFFEC4899),
  ),
];

