import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/core/network/end_points.dart';
import 'package:moghtarib/features/home/student/model/All_apartment_model.dart';

import'package:moghtarib/features/home/student/cubit/all_apartment/all_apartment_cubit.dart';
import'package:moghtarib/features/home/student/cubit/all_apartment/all_apartment_state.dart';
import 'package:moghtarib/features/home/student/view/apartment_details_view.dart';






class ApartmentTabView extends StatefulWidget {
  const ApartmentTabView({super.key});

  @override
  State<ApartmentTabView> createState() => _ApartmentTabViewState();
}

class _ApartmentTabViewState extends State<ApartmentTabView> {
  final TextEditingController _searchController = TextEditingController();

 
  final String _baseUrl = "https://mo3tarib123.runasp.net/";

  @override
  void initState() {
    super.initState();
    
    context.read<AllApartmentCubit>().fetchAllApartment();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        Container(
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 20),
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6A11CB),
                Color(0xFF2575FC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Explore Apartments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by city or location...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            context.read<AllApartmentCubit>().fetchAllApartment(searchText: '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  context.read<AllApartmentCubit>().fetchAllApartment(searchText: value.trim());
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        
        Expanded(
          child: BlocBuilder<AllApartmentCubit, ApartmentState>(
            builder: (context, state) {
              if (state is ApartmentLoading || state is ApartmentInitial) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF6A11CB)));
              }
              
              if (state is ApartmentError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Failed to load apartments', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context.read<AllApartmentCubit>().fetchAllApartment(),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A11CB)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final List<AllApartmentModel> apartments = state is ApartmentLoaded 
                  ? state.apartment 
                  : <AllApartmentModel>[];

              if (apartments.isEmpty) {
                return const Center(
                  child: Text(
                    'No apartments found',
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                );
              }

              
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: apartments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final AllApartmentModel apartment = apartments[index];

                  
String cleanImagePath = apartment.baseImageURL ?? '';

if (cleanImagePath.startsWith('/')) {
  cleanImagePath = cleanImagePath.substring(1);
}


String rawImageUrl = cleanImagePath.isNotEmpty
    ? (cleanImagePath.startsWith('http') 
        ? cleanImagePath 
        : '${_baseUrl}images/$cleanImagePath') 
    : 'https://via.placeholder.com/350x200';


final String imageUrl = Uri.encodeFull(rawImageUrl);


print("🚀 Testing New Image URL: $imageUrl");
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: CircularProgressIndicator(color: Color(0xFF6A11CB)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[900],
                            child: const Icon(Icons.image_not_supported, color: Colors.white38, size: 40),
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Text(
                                apartment.location ?? '${apartment.village ?? ""} ${apartment.city ?? ""}'.trim(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              
                              
                              Text(
                                '${apartment.city ?? "Unknown"} - Egypt',
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                              ),
                              const SizedBox(height: 12),

                              
                              Row(
                                children: [
                                  _buildBadge(
                                    icon: Icons.king_bed_outlined, 
                                    label: '${apartment.numOfRooms ?? 0}-Rooms'
                                  ),
                                  const SizedBox(width: 8),
                                  _buildBadge(
                                    icon: Icons.gavel, 
                                    label: (apartment.isRent ?? true) ? 'Rent' : 'Sale'
                                  ),
                                  const SizedBox(width: 8),
                                  _buildBadge(
                                    icon: Icons.apartment, 
                                    label: 'Property'
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Price',
                                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                                      ),
                                      Text(
                                        '${apartment.price ?? 0} EGP',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (newContext) => BlocProvider.value(
                                            value: context.read<AllApartmentCubit>(),
                                            child: ApartmentDetailsView(apartment: apartment),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6A11CB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    child: const Text(
                                      'View Property Details',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.redAccent),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
