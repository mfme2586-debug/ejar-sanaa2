import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ejar_sanaa/core/theme/app_theme.dart';
import 'package:ejar_sanaa/core/constants/districts.dart';
import 'package:ejar_sanaa/providers/listing_provider.dart';
import 'package:ejar_sanaa/widgets/listing_card.dart';
import 'package:ejar_sanaa/widgets/empty_state.dart';
import 'package:ejar_sanaa/widgets/loading_state.dart';

/// صفحة البحث والفلاتر المتقدمة
/// تصميم UX محسّن: سريع، واضح، لا يرهق المستخدم
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Filters State
  String? _selectedType;
  String? _selectedDistrict;
  String? _selectedNeighborhood;
  RangeValues _priceRange = const RangeValues(0, 200000);
  int? _minRooms;
  String? _selectedFloor;
  String? _waterIndependence;
  String? _electricityIndependence;
  bool? _negotiable;
  
  bool _isSearching = false;
  List<String> _suggestions = [];
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingProvider>().loadListings();
    });
  }
  
  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.length >= 2) {
      _generateSuggestions(query);
    } else {
      setState(() => _suggestions = []);
    }
  }
  
  void _generateSuggestions(String query) {
    // Auto-suggestions: Districts, Neighborhoods, Property Types
    final suggestions = <String>[];
    
    // Districts
    for (var district in Districts.districts) {
      if (district['name'].toString().contains(query)) {
        suggestions.add(district['name']);
      }
    }
    
    // Property Types
    for (var type in RentalTypes.types) {
      if (type['name'].toString().contains(query)) {
        suggestions.add(type['name']);
      }
    }
    
    setState(() => _suggestions = suggestions.take(5).toList());
  }
  
  void _applyFilters() {
    setState(() => _isSearching = true);
    
    context.read<ListingProvider>().applyFilters(
      type: _selectedType,
      district: _selectedDistrict,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      minRooms: _minRooms,
      waterSource: _waterIndependence,
      electricityType: _electricityIndependence,
    );
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isSearching = false);
    });
  }
  
  void _resetFilters() {
    setState(() {
      _selectedType = null;
      _selectedDistrict = null;
      _selectedNeighborhood = null;
      _priceRange = const RangeValues(0, 200000);
      _minRooms = null;
      _selectedFloor = null;
      _waterIndependence = null;
      _electricityIndependence = null;
      _negotiable = null;
      _searchController.clear();
      _suggestions = [];
    });
    context.read<ListingProvider>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث والفلاتر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            tooltip: 'مسح الفلاتر',
            onPressed: _resetFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar with Auto-suggestions
          _buildSearchBar(),
          
          // Quick Filters (Chips)
          _buildQuickFilters(),
          
          // Advanced Filters (Expandable)
          _buildAdvancedFilters(),
          
          // Results
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ابحث عن: المديرية، الحي، نوع العقار...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _suggestions = []);
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          
          // Auto-suggestions
          if (_suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: _suggestions.map((suggestion) {
                  return ListTile(
                    dense: true,
                    title: Text(suggestion),
                    leading: const Icon(Icons.search, size: 20),
                    onTap: () {
                      _searchController.text = suggestion;
                      setState(() => _suggestions = []);
                      _applyFilters();
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildQuickFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'جميع الأنواع',
              isSelected: _selectedType == null,
              onTap: () {
                setState(() => _selectedType = null);
                _applyFilters();
              },
            ),
            const SizedBox(width: 8),
            ...RentalTypes.types.take(5).map((type) {
              final isSelected = _selectedType == type['id'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  label: '${type['icon']} ${type['name']}',
                  isSelected: isSelected,
                  onTap: () {
                    setState(() => _selectedType = isSelected ? null : type['id'] as String);
                    _applyFilters();
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
  
  Widget _buildAdvancedFilters() {
    return ExpansionTile(
      title: const Text('فلاتر متقدمة'),
      leading: const Icon(Icons.tune),
      initiallyExpanded: false,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // District Filter
              _buildSectionTitle('المديرية'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Districts.districts.map((district) {
                  final isSelected = _selectedDistrict == district['id'];
                  return FilterChip(
                    label: Text(district['name']),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDistrict = selected ? district['id'] as String : null;
                        _selectedNeighborhood = null; // Reset neighborhood
                      });
                      _applyFilters();
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Price Range
              _buildSectionTitle('السعر الشهري'),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 200000,
                divisions: 20,
                labels: RangeLabels(
                  '${_priceRange.start.toInt()}',
                  '${_priceRange.end.toInt()}',
                ),
                onChanged: (values) {
                  setState(() => _priceRange = values);
                  _applyFilters();
                },
              ),
              
              const SizedBox(height: 24),
              
              // Rooms Count
              _buildSectionTitle('عدد الغرف'),
              Wrap(
                spacing: 8,
                children: [1, 2, 3, 4, 5].map((count) {
                  final isSelected = _minRooms == count;
                  return FilterChip(
                    label: Text('$count+'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _minRooms = selected ? count : null);
                      _applyFilters();
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Utilities
              _buildSectionTitle('الخدمات'),
              Row(
                children: [
                  Expanded(
                    child: _buildToggleFilter(
                      label: 'ماء مستقل',
                      value: _waterIndependence == 'independent',
                      onChanged: (value) {
                        setState(() => _waterIndependence = value ? 'independent' : null);
                        _applyFilters();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleFilter(
                      label: 'كهرباء مستقلة',
                      value: _electricityIndependence == 'independent',
                      onChanged: (value) {
                        setState(() => _electricityIndependence = value ? 'independent' : null);
                        _applyFilters();
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              _buildToggleFilter(
                label: 'قابل للتفاوض',
                value: _negotiable == true,
                onChanged: (value) {
                  setState(() => _negotiable = value ? true : null);
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.textColor,
        ),
      ),
    );
  }
  
  Widget _buildToggleFilter({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildResults() {
    return Consumer<ListingProvider>(
      builder: (context, provider, child) {
        if (_isSearching) {
          return const LoadingState(message: 'جاري البحث...');
        }
        
        final listings = provider.listings;
        
        if (listings.isEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            title: 'لا توجد نتائج',
            message: 'جرب تغيير الفلاتر أو البحث بكلمات مختلفة',
            actionLabel: 'مسح الفلاتر',
            onAction: _resetFilters,
          );
        }
        
        return ListView.builder(
          controller: _scrollController,
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing = listings[index];
            return ListingCard(
              listing: listing,
              onTap: () => context.push('/listing/${listing.id}'),
            );
          },
        );
      },
    );
  }
}
