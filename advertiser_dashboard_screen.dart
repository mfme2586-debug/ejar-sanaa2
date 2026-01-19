import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ejar_sanaa/core/theme/app_theme.dart';
import 'package:ejar_sanaa/providers/listing_provider.dart';
import 'package:ejar_sanaa/models/listing_model.dart';
import 'package:ejar_sanaa/widgets/empty_state.dart';
import 'package:intl/intl.dart';

/// لوحة تحكم المعلن
/// تصميم UX: بسيط، واضح، يعطي تحكم كامل
class AdvertiserDashboardScreen extends StatelessWidget {
  const AdvertiserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/add-listing'),
          ),
        ],
      ),
      body: Consumer<ListingProvider>(
        builder: (context, provider, child) {
          final userListings = provider.allListings; // TODO: Filter by user
          
          if (userListings.isEmpty) {
            return EmptyState(
              icon: Icons.home_work_outlined,
              title: 'لا توجد إعلانات',
              message: 'ابدأ بإضافة أول إعلان لك',
              actionLabel: 'إضافة إعلان',
              onAction: () => context.push('/add-listing'),
            );
          }
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Stats Summary
              _buildStatsSummary(userListings),
              const SizedBox(height: 24),
              
              // Listings
              const Text(
                'إعلاناتك',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              
              ...userListings.map((listing) => _buildListingCard(context, listing)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsSummary(List<Listing> listings) {
    final active = listings.where((l) => l.isActive).length;
    final booked = 0; // TODO: Track booked status
    final paused = listings.where((l) => !l.isActive).length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('نشط', active, AppTheme.successColor),
                ),
                Expanded(
                  child: _buildStatItem('محجوز', booked, AppTheme.warningColor),
                ),
                Expanded(
                  child: _buildStatItem('متوقف', paused, AppTheme.textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildListingCard(BuildContext context, Listing listing) {
    final formatter = NumberFormat('#,###');
    final priceText = '${formatter.format(listing.price)} ${listing.currency}';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/listing/${listing.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(listing.isActive),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'تعديل',
                    onTap: () => _editListing(context, listing),
                  ),
                  _buildActionButton(
                    icon: listing.isActive ? Icons.pause : Icons.play_arrow,
                    label: listing.isActive ? 'إيقاف' : 'تفعيل',
                    onTap: () => _toggleListingStatus(listing),
                  ),
                  _buildActionButton(
                    icon: Icons.delete_outline,
                    label: 'حذف',
                    onTap: () => _deleteListing(context, listing),
                    isDestructive: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'نشط' : 'متوقف',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? AppTheme.successColor : AppTheme.textColor,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _editListing(BuildContext context, Listing listing) {
    // TODO: Navigate to edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('قريباً: تعديل الإعلان')),
    );
  }

  void _toggleListingStatus(Listing listing) {
    // TODO: Implement toggle status
  }

  void _deleteListing(BuildContext context, Listing listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإعلان'),
        content: const Text('هل أنت متأكد من حذف هذا الإعلان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete listing
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم الحذف')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
