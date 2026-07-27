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
    description: 'مطلوب محاسب خبرة سنتين في إعداد الفواتير وتدقيق الحسابات والتعامل مع برنامج Excel.',
    requirements: ['بكالوريوس تجارة', 'إجادة برامج المحاسبة', 'التفرغ التام'],
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
    description: 'مطلوب شباب للبائعين داخل معرض أجهزة كهربائية وموبايلات بمهارات تواصل عالية.',
    requirements: ['مؤهل متوسط أو عالي', 'حسن المظهر', 'اللباقة والشغف بمجال التقنية'],
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
    description: 'انضم لأسطول توصيل EIOP بمدينة جرجا بدخل ممتاز وحوافز يومية مجزية.',
    requirements: ['يمتلك موتوسيكل / دراجة', 'رخصة قيادة سارية', 'معرفة بأحياء جرجا'],
    contactPhone: '01277665544',
    contactWhatsApp: '201277665544',
    publishedDate: 'اليوم',
    isUrgent: true,
  ),
];
