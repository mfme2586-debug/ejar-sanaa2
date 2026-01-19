import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ejar_sanaa/core/theme/app_theme.dart';
import 'package:ejar_sanaa/core/constants/districts.dart';
import 'package:ejar_sanaa/models/listing_model.dart';
import 'package:ejar_sanaa/providers/listing_provider.dart';
import 'package:ejar_sanaa/widgets/loading_state.dart';
import 'package:ejar_sanaa/widgets/error_state.dart';
import 'package:intl/intl.dart';

/// صفحة تفاصيل العقار
/// تصميم UX: المعلومات المهمة أولاً، واضحة، تدفع للتواصل
class ListingDetailsScreen extends StatelessWidget {
  final String listingId;

  const ListingDetailsScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    final listing = context.watch<ListingProvider>().getListingById(listingId);

    if (listing == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الإعلان')),
        body: const ErrorState(message: 'الإعلان غير موجود'),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          _buildAppBar(context, listing),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price & Title (Above the fold)
                _buildHeader(listing),
                
                // Key Highlights (Icons)
                _buildHighlights(listing),
                
                // Location
                _buildLocationSection(listing),
                
                // Property Details
                _buildPropertyDetails(listing),
                
                // Services
                _buildServicesSection(listing),
                
                // Financial Terms
                _buildFinancialSection(listing),
                
                // Advertiser Info
                _buildAdvertiserSection(listing),
                
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildContactBar(context, listing),
    );
  }

  Widget _buildAppBar(BuildContext context, Listing listing) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: listing.images.isNotEmpty
            ? Image.network(
                listing.images.first,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareListing(context, listing),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => _saveToFavorites(listing),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.borderColor.withOpacity(0.3),
      child: const Icon(Icons.home, size: 80, color: AppTheme.textColor),
    );
  }

  Widget _buildHeader(Listing listing) {
    final formatter = NumberFormat('#,###');
    final priceText = '${formatter.format(listing.price)} ${listing.currency}';
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listing.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                priceText,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              if (listing.negotiable)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'قابل للتفاوض',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            listing.priceIncludesUtilities
                ? 'السعر شامل الماء والكهرباء'
                : 'السعر غير شامل الماء والكهرباء',
            style: TextStyle(
              fontSize: 14,
              color: listing.priceIncludesUtilities
                  ? AppTheme.successColor
                  : AppTheme.textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlights(Listing listing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.backgroundColor,
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        children: [
          if (listing.roomCount != null)
            _buildHighlightIcon(Icons.bed, '${listing.roomCount} غرف'),
          if (listing.bathroomCount != null)
            _buildHighlightIcon(Icons.bathroom, '${listing.bathroomCount} حمام'),
          if (listing.hasExternalMajlis)
            _buildHighlightIcon(Icons.deck, 'مجلس خارجي'),
          if (listing.sunlightDirection != null)
            _buildHighlightIcon(
              Icons.wb_sunny,
              _getSunlightText(listing.sunlightDirection!),
            ),
          if (listing.waterSource != null)
            _buildHighlightIcon(
              Icons.water_drop,
              WaterSources.getName(listing.waterSource!),
            ),
          if (listing.electricityType != null)
            _buildHighlightIcon(
              Icons.bolt,
              ElectricityTypes.getName(listing.electricityType!),
            ),
        ],
      ),
    );
  }

  Widget _buildHighlightIcon(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppTheme.secondaryColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppTheme.textColor),
        ),
      ],
    );
  }

  Widget _buildLocationSection(Listing listing) {
    return _buildSection(
      title: 'الموقع',
      icon: Icons.location_on,
      child: Column(
        children: [
          _buildDetailRow('المديرية', Districts.getDistrictName(listing.district)),
          if (listing.neighborhood != null)
            _buildDetailRow('الحي', listing.neighborhood!),
          if (listing.street != null)
            _buildDetailRow('الحارة', listing.street!),
          if (listing.locationDescription != null)
            _buildDetailRow('وصف الموقع', listing.locationDescription!),
        ],
      ),
    );
  }

  Widget _buildPropertyDetails(Listing listing) {
    return _buildSection(
      title: 'تفاصيل العقار',
      icon: Icons.home,
      child: Column(
        children: [
          if (listing.buildingType != null)
            _buildDetailRow('نوع العقار', listing.buildingType!),
          if (listing.floor != null)
            _buildDetailRow('الدور', Floors.getName(listing.floor!)),
          if (listing.roomCount != null)
            _buildDetailRow('عدد الغرف', '${listing.roomCount} غرف'),
          if (listing.rooms != null && listing.rooms!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'تفاصيل الغرف:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            ...listing.rooms!.map((room) => Padding(
                  padding: const EdgeInsets.only(top: 4, right: 16),
                  child: Text(
                    '${room.name}: ${room.getSizeText()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                )),
          ],
          if (listing.hasKitchen)
            _buildDetailRow('المطبخ', listing.kitchenSize ?? 'يوجد مطبخ'),
          if (listing.bathroomCount != null)
            _buildDetailRow('عدد الحمامات', '${listing.bathroomCount} حمام'),
          if (listing.hasExternalMajlis)
            _buildDetailRow(
              'المجلس الخارجي',
              listing.externalMajlisHasBathroom ? 'يوجد مع حمام' : 'يوجد',
            ),
          if (listing.sunlightDirection != null)
            _buildDetailRow(
              'دخول الشمس',
              SunlightDirections.getName(listing.sunlightDirection!),
            ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(Listing listing) {
    return _buildSection(
      title: 'الخدمات',
      icon: Icons.build,
      child: Column(
        children: [
          if (listing.waterSource != null) ...[
            _buildDetailRow('مصدر الماء', WaterSources.getName(listing.waterSource!)),
            if (listing.waterIndependence != null)
              _buildDetailRow(
                'الماء',
                listing.waterIndependence == 'independent' ? 'مستقل' : 'مشترك',
              ),
          ],
          if (listing.electricityType != null) ...[
            _buildDetailRow('نوع الكهرباء', ElectricityTypes.getName(listing.electricityType!)),
            if (listing.electricityIndependence != null)
              _buildDetailRow(
                'الكهرباء',
                listing.electricityIndependence == 'independent' ? 'مستقل' : 'مشترك',
              ),
          ],
          if (listing.hasSolarPanels)
            _buildDetailRow('الطاقة الشمسية', 'يوجد ألواح شمسية'),
        ],
      ),
    );
  }

  Widget _buildFinancialSection(Listing listing) {
    final formatter = NumberFormat('#,###');
    
    return _buildSection(
      title: 'الشروط المالية',
      icon: Icons.account_balance_wallet,
      child: Column(
        children: [
          if (listing.deposit != null)
            _buildDetailRow(
              'التأمين',
              '${formatter.format(listing.deposit!)} ${listing.currency}',
            ),
          if (listing.advance != null)
            _buildDetailRow(
              'المقدم',
              '${formatter.format(listing.advance!)} ${listing.currency}',
            ),
          if (listing.hasBrokerage)
            _buildDetailRow('الساعية (الدلالة)', 'يوجد'),
          _buildDetailRow('قابل للتفاوض', listing.negotiable ? 'نعم' : 'لا'),
          if (listing.requiresGuarantee)
            _buildDetailRow(
              'الضمانة',
              listing.guaranteeType ?? 'مطلوب ضمانة',
            ),
          _buildDetailRow('النوع', listing.isCommercial ? 'تجاري' : 'سكني'),
        ],
      ),
    );
  }

  Widget _buildAdvertiserSection(Listing listing) {
    return _buildSection(
      title: 'معلومات المعلن',
      icon: Icons.person,
      child: Column(
        children: [
          _buildDetailRow('الصفة', SellerTypes.getName(listing.sellerType)),
          if (listing.sellerName != null)
            _buildDetailRow('الاسم', listing.sellerName!),
          _buildDetailRow(
            'تاريخ النشر',
            DateFormat('yyyy-MM-dd').format(listing.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: AppTheme.textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactBar(BuildContext context, Listing listing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _launchWhatsApp(listing.contactPhone),
              icon: const Icon(Icons.chat),
              label: const Text('واتساب'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _makePhoneCall(listing.contactPhone),
              icon: const Icon(Icons.phone),
              label: const Text('اتصال'),
            ),
          ),
        ],
      ),
    );
  }

  String _getSunlightText(String direction) {
    switch (direction) {
      case 'south':
        return 'مشمس ☀️';
      case 'east':
        return 'شرقي 🌅';
      case 'west':
        return 'غربي 🌇';
      case 'north':
        return 'ظليل ☁️';
      default:
        return 'شمس';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareListing(BuildContext context, Listing listing) {
    // TODO: Implement sharing
  }

  void _saveToFavorites(Listing listing) {
    // TODO: Implement favorites
  }
}
