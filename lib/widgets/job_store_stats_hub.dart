import 'package:flutter/material.dart';

class JobStoreStatsHub extends StatefulWidget {
  final int offeredJobs;
  final int applicantsCount;
  final int acceptedCount;
  final int rejectedCount;
  final Function(String category)? onStatSelected;
  final VoidCallback? onTriggerAtsAnalysis;

  const JobStoreStatsHub({
    super.key,
    this.offeredJobs = 48,
    this.applicantsCount = 184,
    this.acceptedCount = 42,
    this.rejectedCount = 14,
    this.onStatSelected,
    this.onTriggerAtsAnalysis,
  });

  @override
  State<JobStoreStatsHub> createState() => _JobStoreStatsHubState();
}

class _JobStoreStatsHubState extends State<JobStoreStatsHub>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  String _selectedStat = 'all';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double acceptanceRate = widget.applicantsCount > 0
        ? ((widget.acceptedCount / widget.applicantsCount) * 100)
        : 76.5;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Title & Header Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.work_history_rounded,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مركز التوظيف ومؤشر السير الذاتية',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'إدارة المقبولين والمرفوضين وتحليل الـ ATS',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Color(0xFF10B981), size: 7),
                      SizedBox(width: 5),
                      Text(
                        'مباشر',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4 Modern Animated Cards (المقبولين / المرفوضين / المتقدمين / المعروضة)
            Row(
              children: [
                // 1. عدد المقبولين ✅
                Expanded(
                  child: _buildStatCard(
                    id: 'accepted',
                    title: 'عدد المقبولين',
                    count: widget.acceptedCount,
                    unit: 'مقبول',
                    icon: Icons.check_circle_rounded,
                    bgColor: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 8),

                // 2. عدد المرفوضين ❌
                Expanded(
                  child: _buildStatCard(
                    id: 'rejected',
                    title: 'عدد المرفوضين',
                    count: widget.rejectedCount,
                    unit: 'مرفوض',
                    icon: Icons.cancel_rounded,
                    bgColor: const Color(0xFFFEF2F2),
                    iconColor: const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 8),

                // 3. عدد المتقدمين
                Expanded(
                  child: _buildStatCard(
                    id: 'applicants',
                    title: 'إجمالي المتقدمين',
                    count: widget.applicantsCount,
                    unit: 'متقدم',
                    icon: Icons.people_alt_rounded,
                    bgColor: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bottom Progress bar & Acceptance rate summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.query_stats_rounded,
                                size: 16, color: Color(0xFF64748B)),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'معدل التوافق والقبول بالوظائف',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${acceptanceRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (acceptanceRate / 100).clamp(0.0, 1.0),
                      minHeight: 7,
                      backgroundColor:
                          const Color(0xFFEF4444).withValues(alpha: 0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String id,
    required String title,
    required int count,
    required String unit,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    final bool isSelected = _selectedStat == id;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedStat = id;
            });
            if (widget.onStatSelected != null) {
              widget.onStatSelected!(id);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? bgColor : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? iconColor
                    : Colors.black.withValues(alpha: 0.05),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: iconColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Column(
              children: [
                // Top Icon Badge
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
                const SizedBox(height: 6),

                // Animated Counter Number
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: count.toDouble()),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, val, child) {
                    return Text(
                      val.toInt().toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: iconColor,
                        height: 1.1,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 2),

                // Unit Text
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: iconColor.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 3),

                // Label Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
