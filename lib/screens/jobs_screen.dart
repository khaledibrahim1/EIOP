import 'package:flutter/material.dart';
import '../models/job_item.dart';
import '../theme/app_colors.dart';
import '../widgets/job_card.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  String _searchQuery = '';

  final List<String> _categories = [
    'الكل',
    '⚡ عاجل',
    'دوام كامل',
    'دوام جزئي',
    'ورديات',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JobItem> get _filteredJobs {
    return sampleJobs.where((job) {
      // Category Filter
      bool matchesCategory = true;
      if (_selectedCategory == '⚡ عاجل') {
        matchesCategory = job.isUrgent;
      } else if (_selectedCategory != 'الكل') {
        matchesCategory = job.jobType.contains(_selectedCategory);
      }

      // Search Filter
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch = job.title.toLowerCase().contains(query) ||
            job.companyName.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query) ||
            job.description.toLowerCase().contains(query);
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showJobDetailsModal(BuildContext context, JobItem job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 12,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle indicator bar
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Top Header: Icon + Title + Urgent badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: job.isUrgent
                            ? const Color(0xFFFEE2E2)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        Icons.work_rounded,
                        color: job.isUrgent
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFF59E0B),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job.companyName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (job.isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: const Text(
                          '⚡ عاجل جداً',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Key Info Chips (Location, Salary, JobType)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.payments_rounded, 'الراتب المتوقع',
                          job.salaryRange, const Color(0xFF10B981)),
                      const Divider(height: 18, thickness: 0.5),
                      _buildDetailRow(Icons.access_time_filled_rounded,
                          'نوع الدوام', job.jobType, const Color(0xFF3B82F6)),
                      const Divider(height: 18, thickness: 0.5),
                      _buildDetailRow(Icons.location_on_rounded,
                          'موقع العمل', job.location, const Color(0xFFEF4444)),
                      const Divider(height: 18, thickness: 0.5),
                      _buildDetailRow(Icons.calendar_today_rounded,
                          'تاريخ النشر', job.publishedDate, AppColors.textSecondary),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Job Description
                Text(
                  'تفاصيل الوظيفة:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job.description,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Requirements
                Text(
                  'المتطلبات والشروط:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: job.requirements.map((req) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFEF3C7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              req,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Contact & Apply Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('جاري الاتصال بـ ${job.contactPhone}...'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone_rounded,
                            size: 18, color: Color(0xFF10B981)),
                        label: const Text(
                          'اتصال',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF10B981)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('فتح واتساب على الرقم ${job.contactWhatsApp}...'),
                              backgroundColor: const Color(0xFF25D366),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_rounded,
                            size: 18, color: Color(0xFF25D366)),
                        label: const Text(
                          'واتساب',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF25D366),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF25D366)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Main Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showJobApplicationDialog(context, job);
                    },
                    icon: const Icon(Icons.assignment_turned_in_rounded,
                        size: 20, color: Colors.white),
                    label: const Text(
                      'ملء استمارة التقديم الآن',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showJobApplicationDialog(BuildContext context, JobItem job) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final qualificationController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'استمارة التقديم',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل *',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى إدخال الاسم بالكامل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف / الواتساب *',
                      prefixIcon: const Icon(Icons.phone_iphone_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: qualificationController,
                    decoration: InputDecoration(
                      labelText: 'المؤهل العلمي / سنوات الخبرة',
                      prefixIcon: const Icon(Icons.school_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'نبذة عنك أو ملاحظات إضافية',
                      prefixIcon: const Icon(Icons.notes_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  _showSuccessConfirmation(context, job.companyName);
                }
              },
              icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
              label: const Text(
                'إرسال الطلب',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessConfirmation(BuildContext context, String company) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 50,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'تم إرسال طلبك بنجاح! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تم إرسال بيانات التقديم إلى $company. وسيتم التواصل معك في أقرب وقت عبر الهاتف أو الواتساب.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'ممتاز، شكراً',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.work_rounded, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text(
              'وظائف وفرص عمل بالمدينة',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.badge_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'اعثر على وظيفتك المناسبة بجرجا',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'فرص عمل يومية موثوقة في الشركات والمحلات والمصانع',
                          style: TextStyle(
                            color: Colors.white90,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن المسمى الوظيفي، الشركة، المكان...',
                  hintStyle: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFFF59E0B)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Filter Chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFF59E0B),
                    backgroundColor: AppColors.surface,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFFF59E0B)
                            : AppColors.textSecondary.withValues(alpha: 0.2),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Header + Results Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الوظائف المتاحة حالياً',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${jobs.length} وظيفة',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Job List or Empty State
            if (jobs.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      size: 50,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد وظائف تطابق البحث',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'جرّب تغيير كلمات البحث أو اختيار تصنيف آخر',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _selectedCategory = 'الكل';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إعادة ضبط البحث',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobCard(
                    job: job,
                    onTap: () => _showJobDetailsModal(context, job),
                    onApply: () => _showJobApplicationDialog(context, job),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

