import 'package:flutter/material.dart';
import '../models/job_item.dart';
import '../theme/app_colors.dart';

class JobCard extends StatelessWidget {
  final JobItem job;
  final VoidCallback? onTap;
  final VoidCallback? onApply;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: job.isUrgent
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : const Color(0xFFF59E0B).withValues(alpha: 0.2),
          width: job.isUrgent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: job.isUrgent
                ? Colors.red.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Icon + Title + Urgent badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: job.isUrgent
                            ? const Color(0xFFFEE2E2)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.work_rounded,
                        color: job.isUrgent
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFF59E0B),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  job.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (job.isUrgent)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xFFFCA5A5)),
                                  ),
                                  child: const Text(
                                    '⚡ عاجل جداً',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFDC2626),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.business_rounded,
                                size: 14,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  job.companyName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                job.publishedDate,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Job info pills (Salary + Type + Location)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildInfoBadge(Icons.payments_outlined, job.salaryRange,
                        const Color(0xFF10B981)),
                    _buildInfoBadge(Icons.access_time_rounded, job.jobType,
                        const Color(0xFF3B82F6)),
                    _buildInfoBadge(Icons.location_on_outlined, job.location,
                        AppColors.textSecondary),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  job.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                // Action buttons row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.info_outline_rounded,
                            size: 16, color: Color(0xFFF59E0B)),
                        label: const Text(
                          'التفاصيل',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF59E0B)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: onApply ?? onTap,
                        icon: const Icon(Icons.send_rounded,
                            size: 16, color: Colors.white),
                        label: const Text(
                          'قدّم الآن',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: accentColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

