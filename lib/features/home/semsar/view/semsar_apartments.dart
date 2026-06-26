import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/features/home/semsar/cubit/semsar/add_apartment_cubit.dart';
import 'package:moghtarib/features/home/semsar/repo/add_apartment_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moghtarib/features/home/student/model/All_apartment_model.dart';
import 'package:moghtarib/features/home/student/view/apartment_details_view.dart';
class MyApartmentsScreen extends StatefulWidget {
  const MyApartmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyApartmentsScreen> createState() => _MyApartmentsScreenState();
}

class _MyApartmentsScreenState extends State<MyApartmentsScreen> {
  final ApartmentRepo _repo = ApartmentRepo(); 
  List<dynamic> myApartments = [];
  bool isLoading = true;
  final String baseUrl = "https://mo3tarib123.runasp.net/";

  @override
  void initState() {
    super.initState();
    _fetchApartments();
  }

  void _fetchApartments() async {
    setState(() => isLoading = true);
    try {
      final response = await _repo.getMyApartments();
      
      
      print("📡 SERVER RESPONSE DATA: ${response.data}");

      setState(() {
        myApartments = response.data ?? []; 
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("🚨 FETCH APARTMENTS ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في جلب الشقق: $e')),
      );
    }
  }

  void _deleteApartment(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Apartment', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete apartment', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Exit', style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      await _repo.deleteApartment(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apartment deleted successfully')),
      );
      _fetchApartments(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete apartment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawToken = CacheHelper.getValue('token');
    final String token = rawToken != null ? rawToken.toString() : '';

    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text('My Apartments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : myApartments.isEmpty
              ? const Center(child: Text('You have not added any apartments yet.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: myApartments.length,
                  itemBuilder: (context, index) {
                    final apartment = myApartments[index];
                    
                    
                    String imageUrl = '';
                    if (apartment['baseImageURL'] != null && apartment['baseImageURL'].toString().isNotEmpty) {
                      final String baseImg = apartment['baseImageURL'].toString().trim();
                      if (baseImg.startsWith('/')) {
                        imageUrl = baseImg.substring(1);
                      } 
                          imageUrl ='${baseUrl}images/$baseImg';
                      }
                      final String finalImageUrl = Uri.encodeFull(imageUrl);
                      
                    

                    // طباعة الرابط النهائي لكل كارد يظهر على الشاشة مجدداً
                    print("📸 Render Card ID [${apartment['id']}] -> URL: '$finalImageUrl'");

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), 
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1️⃣ الصورة
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: imageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: finalImageUrl,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        httpHeaders: {
                                          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
                                        },
                                        placeholder: (context, url) => Container(
                                          height: 200,
                                          color: Colors.grey[900],
                                          child: const Center(
                                            child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) {
                                          print("🚨 CACHED IMAGE ERROR: $error FOR URL: $url");
                                          return Container(
                                            height: 200,
                                            color: Colors.grey[900],
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.broken_image_outlined, size: 44, color: Colors.grey),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Error: ${error.toString().split('\n').first}',
                                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        height: 200,
                                        color: Colors.grey[900],
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.home, size: 50, color: Colors.grey),
                                            SizedBox(height: 4),
                                            Text('No image path from server', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () => _deleteApartment(apartment['id']),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // 2️⃣ تفاصيل الشقة
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${apartment['village'] ?? ''} ${apartment['city'] ?? ''}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  apartment['location'] ?? 'مصر',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildBadge(Icons.king_bed_outlined, '${apartment['numOfRooms'] ?? 0}-Rooms'),
                                    const SizedBox(width: 8),
                                    _buildBadge(
                                      Icons.flash_on_outlined, 
                                      (apartment['isRent'] ?? false) ? 'Rent' : 'Buy',
                                      color: const Color(0xFFFF5A5F).withOpacity(0.15),
                                      textColor: const Color(0xFFFF5A5F)
                                    ),
                                    const SizedBox(width: 8),
                                    _buildBadge(Icons.apartment_outlined, 'Property'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Price', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${apartment['price'] ?? 0} EGP',
                                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    //   decoration: BoxDecoration(
                                    //     color: const Color(0xFF6C63FF), 
                                    //     borderRadius: BorderRadius.circular(12),
                                    //   ),
                                    //   child: const Text(
                                    //     'View Details',
                                    //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    //   ),
                                    // )

                                  //],// 👈 زرار عرض التفاصيل بعد التعديل
GestureDetector(
  onTap: () {
   
    final apartmentModel = AllApartmentModel.fromJson(apartment);

    // 2. الأمر اللي بيفتح الشاشة الجديدة فوراً ويظهرها للمستخدم
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      
      create: (context) => ApartmentCubit(ApartmentRepo()), 
      child: ApartmentDetailsView(
        
        apartment: apartmentModel, 
      ),
    ),
  ),
);
  },
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF6C63FF), 
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      'View Details',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
    ),
  ),
)
                               ] ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildBadge(IconData icon, String text, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: textColor ?? Colors.grey[400]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: textColor ?? Colors.grey[300], fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}