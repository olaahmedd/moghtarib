import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moghtarib/core/network/end_points.dart';
import 'package:moghtarib/features/home/student/model/All_apartment_model.dart';


class ApartmentDetailsView extends StatefulWidget {
  final AllApartmentModel apartment;

  const ApartmentDetailsView({super.key, required this.apartment});

  @override
  State<ApartmentDetailsView> createState() => _ApartmentDetailsViewState();
}

class _ApartmentDetailsViewState extends State<ApartmentDetailsView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  
  String _formatImageUrl(String url) {
    String cleanImagePath = url.trim();

    
    if (cleanImagePath.startsWith('http')) {
      return Uri.encodeFull(cleanImagePath);
    }

   
    if (cleanImagePath.startsWith('/')) {
      cleanImagePath = cleanImagePath.substring(1);
    }

    
    String base = EndPoints.baseUrl;
    if (!base.endsWith('/')) {
      base = '$base/';
    }

   
    final String rawImageUrl = '${base}images/$cleanImagePath';
    return Uri.encodeFull(rawImageUrl);
  }
  @override
  Widget build(BuildContext context) {
    
    final List<String> allImages = [];
    
    if (widget.apartment.baseImageURL != null && widget.apartment.baseImageURL!.isNotEmpty) {
      allImages.add(_formatImageUrl(widget.apartment.baseImageURL!));
    }
    
    if (widget.apartment.imagesURL != null) {
      for (var img in widget.apartment.imagesURL!) {
        if (img.isNotEmpty) {
          allImages.add(_formatImageUrl(img));
        }
      }
    }
    
   
    if (allImages.isEmpty) {
      allImages.add('https://via.placeholder.com/350x200');
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        title: Text(
          widget.apartment.location ?? 'Apartment Details',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: allImages.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: allImages[index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    
                    placeholder: (context, url) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.purple),
                      ),
                    ),
                   
                    errorWidget: (context, url, error) {
                      print("❌ Details Image Error: $error | URL: ${allImages[index]}");
                      return Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.image_not_supported, color: Colors.white38, size: 50),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text(
                    'Description',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Luxury apartment located in ${widget.apartment.village ?? "N/A"} - ${widget.apartment.city ?? "N/A"} with a modern design and premium finishing.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailInfoTile(
                          title: 'Rooms',
                          value: '${widget.apartment.numOfRooms ?? 0}',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDetailInfoTile(
                          title: 'Price',
                          value: '${widget.apartment.price ?? 0} EGP',
                          valueColor: const Color(0xFF6A11CB), 
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                 
                  const Text(
                    'Property Details',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (widget.apartment.location != null && widget.apartment.location!.isNotEmpty)
                    _buildFeatureCard(icon: Icons.location_on, text: widget.apartment.location!),

                  if (widget.apartment.village != null && widget.apartment.village!.isNotEmpty)
                    _buildFeatureCard(icon: Icons.map, text: widget.apartment.village!),
                  
                  if (widget.apartment.city != null && widget.apartment.city!.isNotEmpty)
                    _buildFeatureCard(icon: Icons.location_city, text: widget.apartment.city!),

                  _buildFeatureCard(
                    icon: Icons.person, 
                    text: widget.apartment.userName ?? 'Admin'
                  ),

                  if (widget.apartment.userPhone != null && widget.apartment.userPhone!.isNotEmpty)
                    _buildFeatureCard(icon: Icons.phone, text: widget.apartment.userPhone!),

                  if (widget.apartment.userWhatsapp != null && widget.apartment.userWhatsapp!.isNotEmpty)
                    _buildFeatureCard(icon: Icons.chat_bubble, text: 'WhatsApp: ${widget.apartment.userWhatsapp!}'),
                  
                  const SizedBox(height: 24),

                  
                  const Text(
                    'Comments',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0 Comments',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailInfoTile({required String title, required String value, Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF90CAF9), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}