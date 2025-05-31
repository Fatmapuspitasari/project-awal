import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class SupabaseService extends GetxService {
  
  SupabaseClient get client => Supabase.instance.client;
  
  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;
  bool get isLoggedIn => currentUser != null;
  
  static Future<SupabaseService> init() async {
    return Get.put(SupabaseService());
  }
  
  static SupabaseService get instance {
    try {
      return Get.find<SupabaseService>();
    } catch (e) {
      return Get.put(SupabaseService());
    }
  }
  
  // ========== AUTH METHODS ==========
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final AuthResponse response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'full_name': fullName,
          if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
        },
      );
      
      if (response.user != null) {
        await createProfile(
          userId: response.user!.id,
          username: username,
          fullName: fullName,
          phoneNumber: phoneNumber,
        );
      }
      
      return response;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }
  
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      print('Login response: ${response.user?.id}');
      print('Session: ${response.session?.accessToken != null}');
      
      return response;
    } on AuthException catch (e) {
      print('Auth Exception: ${e.message}');
      rethrow;
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Gagal login: $e');
    }
  }
  
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }
  
  // ========== PROFILE METHODS ==========
  
  Future<void> createProfile({
    required String userId,
    required String username,
    required String fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final data = {
        'id': userId,
        'username': username,
        'full_name': fullName,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        data['phone_number'] = phoneNumber;
      }
      
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        data['avatar_url'] = avatarUrl;
      }
      
      await client.from('profiles').insert(data);
    } on PostgrestException catch (e) {
      print('Postgrest Exception: ${e.message}');
      rethrow;
    } catch (e) {
      print('Create Profile Exception: $e');
      throw Exception('Gagal membuat profil: $e');
    }
  }
  
  Future<Map<String, dynamic>?> getProfile({String? userId}) async {
    try {
      final id = userId ?? currentUser?.id;
      if (id == null) return null;
      
      final response = await client
          .from('profiles')
          .select()
          .eq('id', id)
          .single();
      
      return response;
    } on PostgrestException catch (e) {
      print('Get Profile Exception: ${e.message}');
      return null;
    } catch (e) {
      print('Get Profile General Exception: $e');
      return null;
    }
  }
  
  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
  }) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('Pengguna belum login');
      
      final data = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (username != null) data['username'] = username;
      if (fullName != null) data['full_name'] = fullName;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      
      await client
          .from('profiles')
          .update(data)
          .eq('id', userId);
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw Exception('Gagal mengupdate profil: $e');
    }
  }
  
  Future<bool> isUsernameExists(String username) async {
    try {
      final response = await client
          .from('profiles')
          .select('id')
          .eq('username', username)
          .maybeSingle();
      
      return response != null;
    } on PostgrestException catch (e) {
      print('Username check exception: ${e.message}');
      return false;
    } catch (e) {
      print('Username check general exception: $e');
      return false;
    }
  }
  
  // ========== ORDER METHODS ==========
  
  /// Simpan order baru ke database
  Future<Map<String, dynamic>> createOrder({
    required String serviceType,
    required String serviceCategory,
    required String serviceName,
    required int quantity,
    required int unitPrice,
    required int totalPrice,
    required String paymentMethod,
    String? notes,
    String paymentStatus = 'Belum Dibayar',
    String serviceStatus = 'Dikonfirmasi',
  }) async {
    try {
      if (!isLoggedIn) {
        throw Exception('Silakan login terlebih dahulu');
      }

      
      final orderData = {
        'user_id': currentUser!.id,
        'service_type': serviceType,
        'service_category': serviceCategory,
        'service_name': serviceName,
        'quantity': quantity,
        'unit_price': unitPrice,
        'total_price': totalPrice,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'service_status': serviceStatus,
        'order_date': DateTime.now().toIso8601String(),
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await client
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      print('Order berhasil disimpan dengan ID: ${response['id']}');
      return response;
    } on PostgrestException catch (e) {
      print('Database error: ${e.message}');
      throw Exception('Gagal menyimpan pesanan: ${e.message}');
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }
  
  /// Ambil semua order user yang sedang login
  Future<List<Map<String, dynamic>>> getUserOrders({
    String? orderBy = 'order_date',
    bool ascending = false,
    int? limit,
  }) async {
    try {
      if (!isLoggedIn) {
        throw Exception('Silakan login terlebih dahulu');
      }

      PostgrestTransformBuilder<PostgrestList> query = client
          .from('orders')
          .select()
          .eq('user_id', currentUser!.id);
          
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      print('Error getting user orders: ${e.message}');
      return [];
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }
  
  /// Update status order
  Future<void> updateOrderStatus({
    required String orderId,
    String? paymentStatus,
    String? serviceStatus,
    String? notes,
  }) async {
    try {
      if (!isLoggedIn) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (paymentStatus != null) updateData['payment_status'] = paymentStatus;
      if (serviceStatus != null) updateData['service_status'] = serviceStatus;
      if (notes != null) updateData['notes'] = notes;

      await client
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .eq('user_id', currentUser!.id); // Pastikan user hanya bisa update ordernya sendiri

      print('Order status berhasil diupdate: $orderId');
    } on PostgrestException catch (e) {
      print('Error updating order status: ${e.message}');
      throw Exception('Gagal mengupdate status pesanan: ${e.message}');
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }
  
  /// Hapus order (soft delete dengan mengubah status)
  Future<void> cancelOrder(String orderId) async {
    try {
      await updateOrderStatus(
        orderId: orderId,
        paymentStatus: 'Dibatalkan',
        serviceStatus: 'Dibatalkan',
        notes: 'Pesanan dibatalkan oleh pengguna',
      );
    } catch (e) {
      throw Exception('Gagal membatalkan pesanan: $e');
    }
  }
  
  /// Ambil detail order berdasarkan ID
  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      if (!isLoggedIn) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final response = await client
          .from('order_summary') // Menggunakan view yang sudah join dengan profiles
          .select()
          .eq('id', orderId)
          .eq('user_id', currentUser!.id)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      print('Error getting order by ID: ${e.message}');
      return null;
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }
  
  /// Ambil history perubahan status order
  Future<List<Map<String, dynamic>>> getOrderHistory(String orderId) async {
    try {
      final response = await client
          .from('order_history')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      print('Error getting order history: ${e.message}');
      return [];
    } catch (e) {
      print('Error getting order history: $e');
      return [];
    }
  }
  
  /// Statistik order user
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      if (!isLoggedIn) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final orders = await getUserOrders();
      
      final stats = {
        'total_orders': orders.length,
        'total_amount': orders.fold<int>(0, (sum, order) => sum + (order['total_price'] as int)),
        'pending_orders': orders.where((o) => o['payment_status'] == 'Belum Dibayar').length,
        'completed_orders': orders.where((o) => o['service_status'] == 'Selesai').length,
        'cancelled_orders': orders.where((o) => o['service_status'] == 'Dibatalkan').length,
      };
      
      return stats;
    } catch (e) {
      print('Error getting order statistics: $e');
      return {
        'total_orders': 0,
        'total_amount': 0,
        'pending_orders': 0,
        'completed_orders': 0,
        'cancelled_orders': 0,
      };
    }
  }
  
  // ========== UTILITY METHODS ==========
  
  void listenToAuthChanges(Function(AuthState) callback) {
    client.auth.onAuthStateChange.listen(callback);
  }
  
  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'your-app://reset-password', 
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('Gagal reset password: $e');
    }
  }
  
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('Gagal mengupdate password: $e');
    }
  }
  
  String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      final message = error.message.toLowerCase();
      
      if (message.contains('invalid login credentials') || 
          message.contains('invalid credentials')) {
        return 'Email atau password salah';
      } else if (message.contains('email not confirmed') || 
                 message.contains('confirm your email')) {
        return 'Email belum diverifikasi. Silakan cek email Anda';
      } else if (message.contains('user already registered') ||
                 message.contains('already registered')) {
        return 'Email sudah terdaftar';
      } else if (message.contains('signup is disabled')) {
        return 'Pendaftaran sedang dinonaktifkan';
      } else if (message.contains('password should be at least')) {
        return 'Password terlalu pendek';
      } else if (message.contains('email rate limit')) {
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      } else if (message.contains('network')) {
        return 'Masalah koneksi internet';
      }
      
      // Fallback berdasarkan status code
      switch (error.statusCode) {
        case '400':
          return 'Data tidak valid';
        case '401':
          return 'Email atau password salah';
        case '422':
          return 'Email belum diverifikasi';
        case '429':
          return 'Terlalu banyak percobaan. Coba lagi nanti';
        case '500':
          return 'Masalah server. Coba lagi nanti';
        default:
          return error.message;
      }
    } else if (error is PostgrestException) {
      if (error.code == '23505') {
        return 'Data sudah ada (duplikat)';
      } else if (error.code == '42501') {
        return 'Tidak memiliki izin untuk operasi ini';
      } else if (error.code == '23503') {
        return 'Data terkait tidak ditemukan';
      }
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    
    return 'Terjadi kesalahan yang tidak diketahui';
  }
  
  Future<bool> checkConnection() async {
    try {
      final response = await client.from('profiles').select('id').limit(1);
      return true;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  Future<void> refreshSession() async {
    try {
      await client.auth.refreshSession();
    } catch (e) {
      print('Session refresh failed: $e');
    }
  }
}