import 'package:flutter/material.dart';
import '../../models/vendor_store_config.dart';

class VendorOrdersTab extends StatefulWidget {
  final String categoryId;
  final String searchQuery;

  const VendorOrdersTab({
    super.key,
    required this.categoryId,
    this.searchQuery = '',
  });

  @override
  State<VendorOrdersTab> createState() => _VendorOrdersTabState();
}

class _VendorOrdersTabState extends State<VendorOrdersTab> {
  String _selectedFilter = 'الكل';
  late VendorStoreConfig _storeConfig;
  late List<Map<String, dynamic>> _allOrders;

  static const darkForestGreen = Color(0xFF0D2B1D);
  static const vibrantLimeGreen = Color(0xFFA3E635);
  static const lightBgColor = Color(0xFFF6F8F5);
  static const cardWhite = Colors.white;
  static const textDark = Color(0xFF0F172A);
  static const textSubtle = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _storeConfig = VendorStoreConfig.fromCategoryId(widget.categoryId);
    _allOrders = _storeConfig.getInitialSampleOrders();
  }

  bool get _isJobsStore {
    return widget.categoryId == 'jobs' || _storeConfig.categoryId == 'jobs';
  }

  List<Map<String, dynamic>> get _filteredOrders {
    return _allOrders.where((order) {
      if (_selectedFilter != 'الكل') {
        final status = order['status'] ?? '';
        if (_selectedFilter == 'المقبولين ✅') {
          if (status != 'المقبولين ✅' && status != 'تم القبول 🟢') return false;
        } else if (_selectedFilter == 'المرفوضين ❌') {
          if (status != 'المرفوضين ❌' && status != 'مرفوض') return false;
        } else if (status != _selectedFilter) {
          return false;
        }
      }
      final query = widget.searchQuery.trim().toLowerCase();
      if (query.isNotEmpty) {
        final id = (order['id'] ?? '').toString().toLowerCase();
        final name = (order['customerName'] ?? '').toString().toLowerCase();
        final phone = (order['phone'] ?? '').toString().toLowerCase();
        final items = (order['items'] ?? '').toString().toLowerCase();
        final position = (order['position'] ?? '').toString().toLowerCase();
        return id.contains(query) ||
            name.contains(query) ||
            phone.contains(query) ||
            items.contains(query) ||
            position.contains(query);
      }
      return true;
    }).toList();
  }

  int get _acceptedCandidatesCount {
    return _allOrders.where((o) {
      final s = o['status'] ?? '';
      return s == 'المقبولين ✅' || s == 'تم القبول 🟢';
    }).length;
  }

  int get _rejectedCandidatesCount {
    return _allOrders.where((o) {
      final s = o['status'] ?? '';
      return s == 'المرفوضين ❌' || s == 'مرفوض';
    }).length;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'الجديدة':
      case 'طلب جديد ⚡':
      case 'معاينات جديدة':
      case 'طلبات جديدة':
        return darkForestGreen;
      case 'قيد التحضير':
      case 'قيد الفرز والتدقيق':
      case 'موعد محدد':
      case 'قيد التوصيل':
        return const Color(0xFF4285F4);
      case 'جاهزة للتسليم':
      case 'مقابلة محددة 🤝':
        return const Color(0xFF6366F1);
      case 'المكتملة':
      case 'المقبولين ✅':
      case 'تم القبول 🟢':
      case 'معاينات مكتملة':
      case 'تم التسليم':
        return const Color(0xFF10B981);
      case 'المرفوضين ❌':
      case 'مرفوض':
        return const Color(0xFFEF4444);
      default:
        return textSubtle;
    }
  }

  void _showCandidateCvModal(BuildContext context, Map<String, dynamic> candidate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final List<dynamic> skills = candidate['skills'] ?? ['Flutter', 'Dart', 'UI Design'];
        final int atsScore = (candidate['atsScore'] ?? 85) as int;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Candidate Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: darkForestGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.picture_as_pdf_rounded,
                          color: Colors.redAccent, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidate['customerName'] ?? 'متقدم توظيف',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            candidate['position'] ?? 'مطور ومصمم تطبيقات',
                            style: const TextStyle(
                              fontSize: 12,
                              color: textSubtle,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF10B981)),
                      ),
                      child: Column(
                        children: [
                          const Text('درجة ATS',
                              style: TextStyle(fontSize: 9, color: textSubtle)),
                          Text(
                            '%$atsScore',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // CV Document Info Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: lightBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.file_present_rounded,
                          color: darkForestGreen, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidate['cvFileName'] ?? 'Applicant_CV_Resume.pdf',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'الحجم: ${candidate['cvSize'] ?? '2.4 MB'} • تم التحديث مؤخراً',
                              style: const TextStyle(fontSize: 10, color: textSubtle),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkForestGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'تم فتح وتنزيل ملف CV للمتقدم (${candidate['customerName']}) بنجاح'),
                              backgroundColor: darkForestGreen,
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, color: vibrantLimeGreen, size: 14),
                        label: const Text('تحميل',
                            style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Skills & Qualifications
                const Text('المهارات والتقنيات المطابقة (ATS Match):',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textDark)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        skill.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Candidate Notes / HR Review
                const Text('ملاحظات والخبرة السابقة:',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textDark)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFCD34D)),
                  ),
                  child: Text(
                    candidate['review'] ??
                        'خبرة ممتازة متوافقة مع متطلبات التوظيف بجرجا، يرجى تحديد موعد المقابلة.',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF92400E), height: 1.3),
                  ),
                ),
                const SizedBox(height: 20),

                // Decision Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          setState(() {
                            candidate['status'] = 'المقبولين ✅';
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم قبول المتقدم (${candidate['customerName']}) بنجاح ✅'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                        label: const Text('قبول المتقدم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          setState(() {
                            candidate['status'] = 'المرفوضين ❌';
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم رفض الطلب للمتقدم (${candidate['customerName']})'),
                              backgroundColor: const Color(0xFFEF4444),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 18),
                        label: const Text('رفض الطلب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAtsTop10ModalSheet(BuildContext context) {
    // Sort all candidates by ATS Score descending
    final top10List = List<Map<String, dynamic>>.from(_allOrders)
      ..sort((a, b) => ((b['atsScore'] ?? 0) as int).compareTo((a['atsScore'] ?? 0) as int));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              // Header Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkForestGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: vibrantLimeGreen, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تصنيف الـ ATS لأفضل المرشحين',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'ترتيب أوتوماتيكي بناءً على مطابقة المهارات والسيرة الذاتية',
                            style: TextStyle(fontSize: 11, color: textSubtle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),

              // Candidates List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: top10List.length,
                  itemBuilder: (context, index) {
                    final candidate = top10List[index];
                    final int atsScore = (candidate['atsScore'] ?? 80) as int;
                    final int rank = index + 1;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: rank == 1 ? const Color(0xFFFEFCE8) : cardWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: rank == 1
                              ? const Color(0xFFF59E0B)
                              : Colors.black.withValues(alpha: 0.08),
                          width: rank == 1 ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Rank Medal / Circle
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: rank == 1
                                  ? const Color(0xFFF59E0B)
                                  : rank == 2
                                      ? const Color(0xFF94A3B8)
                                      : rank == 3
                                          ? const Color(0xFFD97706)
                                          : lightBgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '#$rank',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: rank <= 3 ? Colors.white : textDark,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      candidate['customerName'] ?? 'متقدم',
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                    if (rank == 1) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  candidate['position'] ?? 'وظيفة متقدم لها',
                                  style: const TextStyle(fontSize: 11, color: textSubtle),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECFDF5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'توافق %$atsScore',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      candidate['status'] ?? 'جديد',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: _getStatusColor(candidate['status'] ?? ''),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Quick Action
                          IconButton(
                            icon: const Icon(Icons.visibility_rounded, color: darkForestGreen),
                            onPressed: () {
                              Navigator.pop(context);
                              _showCandidateCvModal(context, candidate);
                            },
                          ),
                        ],
                      ),
                    );
                  },
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
    final bool isRealEstate = _storeConfig.categoryId == 'real_estate' ||
        _storeConfig.categoryId == 'realEstate' ||
        widget.categoryId == 'real_estate' ||
        widget.categoryId == 'realEstate';

    final bool isParcel = _storeConfig.categoryId == 'parcel' ||
        _storeConfig.categoryId == 'parcelDelivery' ||
        widget.categoryId == 'parcel' ||
        widget.categoryId == 'parcelDelivery' ||
        widget.categoryId == 'delivery';

    final List<String> filterTabs = _isJobsStore
        ? ['الكل', 'الجديدة', 'قيد الفرز والتدقيق', 'المقبولين ✅', 'المرفوضين ❌']
        : isParcel
            ? ['الكل', 'طلبات جديدة', 'قيد التوصيل', 'تم التسليم']
            : isRealEstate
                ? ['الكل', 'معاينات جديدة', 'موعد محدد', 'معاينات مكتملة']
                : ['الكل', 'الجديدة', 'قيد التحضير', 'جاهزة للتسليم', 'المكتملة'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP SUMMARY METRIC CARDS ROW (Job-tailored for Accepted & Rejected counts)
          if (_isJobsStore) ...[
            Row(
              children: [
                // Accepted Applicants Card (عدد المقبولين)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFECFDF5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF10B981), size: 20),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.arrow_upward_rounded,
                                      color: Color(0xFF10B981), size: 10),
                                  Text(
                                    '+18%',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$_acceptedCandidatesCount متقدم',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: darkForestGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'عدد المقبولين ✅',
                          style: TextStyle(
                            fontSize: 11,
                            color: textSubtle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Rejected Applicants Card (عدد المرفوضين)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEF2F2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.cancel_rounded,
                                  color: Color(0xFFEF4444), size: 20),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.arrow_downward_rounded,
                                      color: Color(0xFFEF4444), size: 10),
                                  Text(
                                    '-10%',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$_rejectedCandidatesCount متقدم',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'عدد المرفوضين ❌',
                          style: TextStyle(
                            fontSize: 11,
                            color: textSubtle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ATS Smart Banner
            InkWell(
              onTap: () => _showAtsTop10ModalSheet(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D2B1D), Color(0xFF1E3A2B)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: darkForestGreen.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: vibrantLimeGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: darkForestGreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تحليل ATS - تصفية وترتيب أفضل 10 مرشحين',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'عرض أعلى النسب المطابقة للسيرة الذاتية والشروط',
                            style: TextStyle(color: Colors.white70, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_left_rounded, color: vibrantLimeGreen, size: 24),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Default E-commerce revenue header
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('18 طلب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: darkForestGreen)),
                        Text('إجمالي طلبات اليوم', style: TextStyle(fontSize: 11, color: textSubtle)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1,450.0 ج.م', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: darkForestGreen)),
                        Text('إجمالي المبلغ المحصل', style: TextStyle(fontSize: 11, color: textSubtle)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // 2. FILTER CHOICE CHIPS
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: filterTabs.map((tab) {
                final isSelected = _selectedFilter == tab;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    selectedColor: darkForestGreen,
                    backgroundColor: cardWhite,
                    side: BorderSide(
                      color: isSelected
                          ? darkForestGreen
                          : Colors.black.withValues(alpha: 0.08),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? vibrantLimeGreen : textDark,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = tab);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // 3. CANDIDATES / ORDERS LIST
          if (_filteredOrders.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.badge_outlined, size: 48, color: textSubtle),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد طلبات تقديم في قسم ($_selectedFilter) حالياً',
                      style: const TextStyle(
                        fontSize: 13,
                        color: textSubtle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                final statusColor = _getStatusColor(order['status']);

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row (ID + Status Tag + Action Rate)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: darkForestGreen,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    order['id'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: vibrantLimeGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      order['status'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isJobsStore) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bolt_rounded, size: 13, color: Color(0xFF10B981)),
                                  const SizedBox(width: 2),
                                  Text(
                                    'ATS %${order['atsScore'] ?? 85}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else
                            Text(
                              '${order['total']} ج.م',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: darkForestGreen,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Candidate Info Row
                      Row(
                        children: [
                          const Icon(Icons.person_rounded, size: 16, color: textSubtle),
                          const SizedBox(width: 6),
                          Text(
                            '${order['customerName']} • ${order['phone']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: textSubtle),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              order['address'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: textSubtle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Item Details Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: lightBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: Text(
                          _isJobsStore
                              ? 'تفاصيل الطلب: ${order['items']}\nالخبرة: ${order['experience'] ?? '3 سنوات'}'
                              : isRealEstate
                                  ? 'تفاصيل المعاينة والعقار: ${order['items']}'
                                  : 'محتويات الطلب: ${order['items']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: textDark,
                            height: 1.4,
                          ),
                        ),
                      ),

                      // Attached CV Card Button for Jobs Store
                      if (_isJobsStore) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order['cvFileName'] ?? 'ملف CV السيرة الذاتية (PDF)',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'حجم الملف: ${order['cvSize'] ?? '2.4 MB'}',
                                      style: const TextStyle(fontSize: 10, color: textSubtle),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: darkForestGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                ),
                                onPressed: () => _showCandidateCvModal(context, order),
                                icon: const Icon(Icons.visibility_rounded, color: vibrantLimeGreen, size: 14),
                                label: const Text(
                                  'معاينة الـ CV',
                                  style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // STAR RATING & CUSTOMER REVIEW BOX
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFCD34D).withValues(alpha: 0.8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(5, (starIdx) {
                                    final ratingVal = ((order['rating'] ?? 5.0) as num).toDouble();
                                    return Icon(
                                      starIdx < ratingVal.floor()
                                          ? Icons.star_rounded
                                          : Icons.star_half_rounded,
                                      color: const Color(0xFFF59E0B),
                                      size: 16,
                                    );
                                  }),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'تقييم ${order['rating'] ?? 5.0} ⭐',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFB45309),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              order['review'] ??
                                  'سيرة ذاتية متطابقة وتأهيل ممتاز للوظيفة المطلوب التقديم عليها.',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF78350F),
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // STORE SPECIFIC STATUS UPDATE BUTTONS
                      if (_isJobsStore) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                onPressed: () {
                                  setState(() => order['status'] = 'المقبولين ✅');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تم قبول المتقدم (${order['customerName']}) بنجاح ✅'),
                                      backgroundColor: const Color(0xFF10B981),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                                label: const Text(
                                  'قبول المتقدم ✅',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                onPressed: () {
                                  setState(() => order['status'] = 'المرفوضين ❌');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تم رفض الطلب للمتقدم (${order['customerName']})'),
                                      backgroundColor: const Color(0xFFEF4444),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 16),
                                label: const Text(
                                  'رفض المتقدم ❌',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else if (order['status'] == 'الجديدة' ||
                          order['status'] == 'معاينات جديدة' ||
                          order['status'] == 'طلبات جديدة') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isParcel ? const Color(0xFF0B1120) : darkForestGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() => order['status'] = isParcel
                                  ? 'قيد التوصيل'
                                  : isRealEstate
                                      ? 'موعد محدد'
                                      : 'قيد التحضير');
                            },
                            icon: Icon(
                                isParcel
                                    ? Icons.navigation_rounded
                                    : isRealEstate
                                        ? Icons.event_available_rounded
                                        : Icons.check_circle_outline_rounded,
                                color: const Color(0xFFA3E635),
                                size: 18),
                            label: Text(
                              isParcel
                                  ? 'قبول واستلام الشحنة ورسم المسار'
                                  : isRealEstate
                                      ? 'تأكيد وحجز موعد المعاينة'
                                      : _storeConfig.orderActionLabel,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}
