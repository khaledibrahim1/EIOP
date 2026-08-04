class JobItem {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;
  final String jobType; // Full-Time, Part-Time, Shift
  final String description;
  final List<String> requirements;
  final String contactPhone;
  final String contactWhatsApp;
  final String publishedDate;
  final bool isUrgent;

  const JobItem({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
    required this.jobType,
    required this.description,
    required this.requirements,
    required this.contactPhone,
    required this.contactWhatsApp,
    required this.publishedDate,
    this.isUrgent = false,
  });
}

final List<JobItem> sampleJobs = [
  const JobItem(
    id: 'job_1',
    title: 'محاسب مالي وشؤون مبيعات',
    companyName: 'مجموعة المروة للمواد الغذائية',
    location: 'جرجا - شارع المحطة',
    salaryRange: '4,500 - 6,000 ج.م',
    jobType: 'دوام كامل',
    description: 'مطلوب محاسب خبرة سنتين في إعداد الفواتير وتدقيق الحسابات والتعامل مع برنامج Excel وبرامج المحاسبة المالية.',
    requirements: ['بكالوريوس تجارة شعبة محاسبة', 'إجادة برامج المحاسبة وإكسيل', 'الالتزام والتفرغ التام'],
    contactPhone: '01099887766',
    contactWhatsApp: '201099887766',
    publishedDate: 'اليوم',
    isUrgent: true,
  ),
  const JobItem(
    id: 'job_2',
    title: 'مسؤول مبيعات ومعرض إلكترونيات',
    companyName: 'تكنو ستور جرجا',
    location: 'جرجا - الشارع التجاري',
    salaryRange: '3,800 - 5,000 ج.م + عمولة',
    jobType: 'دوام كامل',
    description: 'مطلوب شباب للبائعين داخل معرض أجهزة كهربائية وموبايلات بمهارات تواصل عالية وإجادة البيع المباشر.',
    requirements: ['مؤهل متوسط أو عالي', 'حسن المظهر واللباقة', 'الشغف بمجال التقنية والأجهزة'],
    contactPhone: '01188776655',
    contactWhatsApp: '201188776655',
    publishedDate: 'منذ أمس',
    isUrgent: false,
  ),
  const JobItem(
    id: 'job_3',
    title: 'كابتن توصيل ومرسول (طيار)',
    companyName: 'شركة EIOP Express للتوصيل',
    location: 'جرجا - جميع الأحياء',
    salaryRange: '6,000 - 9,000 ج.م',
    jobType: 'دوام مرن / ورديات',
    description: 'انضم لأسطول توصيل EIOP بمدينة جرجا بدخل ممتاز وحوافز يومية مجزية مع توفير زي عمل رسمي.',
    requirements: ['يمتلك موتوسيكل أو دراجة نارية', 'رخصة قيادة سارية', 'معرفة ممتازة بأحياء وشوارع جرجا'],
    contactPhone: '01277665544',
    contactWhatsApp: '201277665544',
    publishedDate: 'اليوم',
    isUrgent: true,
  ),
  const JobItem(
    id: 'job_4',
    title: 'مساعد صيدلي / صيدلي ثانٍ',
    companyName: 'صيدليات مصر الكبرى - فرع جرجا',
    location: 'جرجا - ميدان النهضة',
    salaryRange: '5,000 - 7,500 ج.م',
    jobType: 'ورديات',
    description: 'مطلوب مساعد صيدلي خبرة في صرف الروشتات والتعامل مع الأدوية والأجهزة الطبية بوردية مسائية.',
    requirements: ['مؤهل طب / صيدلة / علوم / تمريض', 'خبرة لا تقل عن سنة بالصيدليات', 'إجادة استخدام الكمبيوتر'],
    contactPhone: '01011223344',
    contactWhatsApp: '201011223344',
    publishedDate: 'اليوم',
    isUrgent: true,
  ),
  const JobItem(
    id: 'job_5',
    title: 'شيف وجبات سريعة ومعجنات',
    companyName: 'مطعم وجبتي - Girga Branch',
    location: 'جرجا - شارع الجمهوريه',
    salaryRange: '5,500 - 8,000 ج.م',
    jobType: 'دوام كامل',
    description: 'مطلوب شيف خبرة في تجهيز السندوتشات والبيتزا والوجبات السريعة للعمل ببيئة احترافية ونظيفة.',
    requirements: ['خبرة في المطاعم والوجبات السريعة', 'الالتزام بمعايير النظافة والسرعة', 'شهادة صحية سارية'],
    contactPhone: '01144556677',
    contactWhatsApp: '201144556677',
    publishedDate: 'منذ يومين',
    isUrgent: false,
  ),
  const JobItem(
    id: 'job_6',
    title: 'مدرس لغة إنجليزية للسنتر التعليمي',
    companyName: 'أكاديمية التفوق اللغوي',
    location: 'جرجا - بالقرب من موقف سوهاج',
    salaryRange: '4,000 - 6,500 ج.م',
    jobType: 'دوام جزئي',
    description: 'فرصة لمدرسي ومدرسات اللغة الإنجليزية لإعطاء كورسات وتحفيظ المناهج للمراحل الإعدادية والثانوية.',
    requirements: ['بكالوريوس آداب / تربية إنجليزي', 'أسلوب شرح تفاعلي وممتاز', 'خبرة في التدريس'],
    contactPhone: '01299887711',
    contactWhatsApp: '201299887711',
    publishedDate: 'منذ 3 أيام',
    isUrgent: false,
  ),
];
