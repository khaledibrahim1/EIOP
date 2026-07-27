import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../theme/app_colors.dart';

class ParcelDeliveryScreen extends StatefulWidget {
  const ParcelDeliveryScreen({super.key});

  @override
  State<ParcelDeliveryScreen> createState() => _ParcelDeliveryScreenState();
}

class _ParcelDeliveryScreenState extends State<ParcelDeliveryScreen> {
  final _pickupController =
      TextEditingController(text: 'شارع المحطة - بجوار البنك الأهلي');
  final _dropoffController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'طرد شخصي / أمانة';
  String _selectedPayment = 'نقداً عند التسليم';
  double _calculatedDeliveryFee = 25.0;

  final List<String> _categories = [
    'طرد شخصي / أمانة',
    'مستندات وأوراق رسمية',
    'مفاتيح أو أغراض نسائية',
    'هدية أو مشتريات خاصة',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.two_wheeler_rounded, color: Color(0xFF0EA5E9)),
            SizedBox(width: 8),
            Text(
              'EIOP Express - توصيل طرود ومرسول',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0EA5E9),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ارسل واستلم أي شيء في مدينتك',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'مندوب خاص يصلك خلال دقائق وينقل شحنتك بأمان',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pickup & Dropoff Address Section
            Text(
              '1. تفاصيل العناوين',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildInputField(
              controller: _pickupController,
              label: 'عنوان استلام الشحنة (منين نسلم؟)',
              icon: Icons.my_location_rounded,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 12),

            _buildInputField(
              controller: _dropoffController,
              label: 'عنوان تسليم الشحنة (تترسل فين؟)',
              icon: Icons.location_on_rounded,
              iconColor: Colors.red,
              hint: 'مثال: حي الزهراء - بالقرب من المستشفى',
            ),
            const SizedBox(height: 24),

            // Recipient Details
            Text(
              '2. بيانات المستلم',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _recipientNameController,
                    label: 'اسم المستلم',
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    controller: _recipientPhoneController,
                    label: 'رقم هاتف المستلم',
                    icon: Icons.phone_android_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Package Type & Category
            Text(
              '3. نوع الشحنة والمحتوى',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: const Color(0xFF0EA5E9),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            _buildInputField(
              controller: _notesController,
              label: 'وصف أو ملاحظات للشحنة',
              icon: Icons.notes_rounded,
              iconColor: Colors.amber[800]!,
              hint: 'مثال: أمانة قابلة للكسر، أو اتصل بالمستلم قبل الوصول',
            ),
            const SizedBox(height: 24),

            // Price Estimation & Delivery Action Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF0EA5E9).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تكلفة التوصيل التقديرية داخل المدينة:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_calculatedDeliveryFee.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0EA5E9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_dropoffController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('برجاء كتابة عنوان التسليم أولاً'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Create active order state
                        appState.placeParcelOrder(
                          pickup: _pickupController.text,
                          dropoff: _dropoffController.text,
                          category: _selectedCategory,
                          fee: _calculatedDeliveryFee,
                        );

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.green),
                                SizedBox(width: 8),
                                Text('تم إرسال الطلب بنجاح!'),
                              ],
                            ),
                            content: Text(
                                'تم تعيين كابتن المندوب وهو في طريقه لاستلام الشحنة من ${_pickupController.text}.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('متابعة الطلب'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      label: const Text(
                        'تأكيد واستدعاء مندوب التوصيل فوراً',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
    String? hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBg),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: iconColor, size: 20),
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
