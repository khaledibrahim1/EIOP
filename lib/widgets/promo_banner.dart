import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PromoOfferData {
  final String badgeText;
  final String title;
  final String subtitleText;
  final String discountNum;
  final String footerNote;
  final String buttonText;
  final String bgImagePath;

  const PromoOfferData({
    required this.badgeText,
    required this.title,
    required this.subtitleText,
    required this.discountNum,
    required this.footerNote,
    required this.buttonText,
    required this.bgImagePath,
  });
}

class PromoOfferStore {
  static final ValueNotifier<List<PromoOfferData>> offersNotifier =
      ValueNotifier<List<PromoOfferData>>([
    const PromoOfferData(
      badgeText: 'عرض ترحيبي!',
      title: 'خصم أول طلب مطاعم وسوبرماركت',
      subtitleText: 'خصم يصل إلى',
      discountNum: '40',
      footerNote: 'على جميع الأقسام | كود: EIOP40',
      buttonText: 'احصل عليه',
      bgImagePath: 'assets/images/hadramout_cover.png',
    ),
    const PromoOfferData(
      badgeText: 'توصيل سريع!',
      title: 'مرسول EIOP Express للطرود',
      subtitleText: 'أجرة التوصيل تبدأ من',
      discountNum: '15',
      footerNote: 'نقل أمانات وطرود | في 20 دقيقة',
      buttonText: 'ارسل طردك',
      bgImagePath: 'assets/images/delivery_rider.png',
    ),
    const PromoOfferData(
      badgeText: 'صيدليتك ببيتك!',
      title: 'صور الروشتة ودواك يوصلك',
      subtitleText: 'خصم على المستلزمات',
      discountNum: '20',
      footerNote: 'من أقرب صيدلية | رعاية متكاملة',
      buttonText: 'ارفع روشتتك',
      bgImagePath: 'assets/images/cat_coffee.png',
    ),
    const PromoOfferData(
      badgeText: 'بدون وسيط!',
      title: 'أفضل عقارات وشقق المدينة',
      subtitleText: 'وفر عمولات حتى',
      discountNum: '100',
      footerNote: 'تواصل مباشر مع المالك فوراً',
      buttonText: 'استكشف العقارات',
      bgImagePath: 'assets/images/sultan_pizza_cover.png',
    ),
  ]);

  static void addOffer(PromoOfferData offer) {
    offersNotifier.value = [offer, ...offersNotifier.value];
  }
}

class PromoBanner extends StatefulWidget {
  final VoidCallback onTasteNow;

  const PromoBanner({super.key, required this.onTasteNow});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Auto-slide carousel timer (every 4 seconds)
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final offersCount = PromoOfferStore.offersNotifier.value.length;
        if (offersCount > 0) {
          _currentPage = (_currentPage + 1) % offersCount;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBannerImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.primaryDark,
        ),
      );
    }
    if (File(path).existsSync()) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.primaryDark,
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.primaryDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PromoOfferData>>(
      valueListenable: PromoOfferStore.offersNotifier,
      builder: (context, offers, child) {
        if (offers.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            // Main Offer Banner Card Carousel
            SizedBox(
              height: 175,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return _buildOfferCard(offer);
                },
              ),
            ),
            const SizedBox(height: 12),

            // Carousel Page Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(offers.length, (index) {
                final isSelected = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOfferCard(PromoOfferData offer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Background Full-Bleed Image
            Positioned.fill(
              child: _buildBannerImage(offer.bgImagePath),
            ),

            // Dark Radial & Linear Overlay for High Text Readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
              ),
            ),

            // Card Content Layer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top White Pill Badge ("Limited time!")
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        offer.badgeText,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Middle Section: Title & Large Discount Number Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${offer.subtitleText} ',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            offer.discountNum,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 3),
                          // Small Orange Percent Badge Circle
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Bottom Row: Footer Note (Right) & Action Button (Left)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Footer Note
                      Text(
                        offer.footerNote,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      // Orange Action Pill Button ("احصل عليه" / Claim)
                      ElevatedButton(
                        onPressed: widget.onTasteNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 6,
                          ),
                          minimumSize: const Size(0, 34),
                        ),
                        child: Text(
                          offer.buttonText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
