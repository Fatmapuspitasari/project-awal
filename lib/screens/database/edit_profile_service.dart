import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_awal/screens/database/supabase_service.dart';

class EditProfileService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  SupabaseClient get _client => _supabaseService.client;
  User? get _currentUser => _supabaseService.currentUser;

  /// Mendapatkan profil user saat ini
  Future<Map<String, dynamic>?> getCurrentProfile() async {
    try {
      if (_currentUser == null) {
        throw Exception('User tidak login');
      }

      final response =
          await _client
              .from('profiles')
              .select()
              .eq('id', _currentUser!.id)
              .single();

      return response;
    } on PostgrestException catch (e) {
      print('Error getting current profile: ${e.message}');
      throw Exception('Gagal mengambil data profil: ${e.message}');
    } catch (e) {
      print('Error getting current profile: $e');
      throw Exception('Gagal mengambil data profil');
    }
  }

  /// Mengecek apakah username sudah digunakan oleh user lain
  Future<bool> isUsernameAvailable(
    String username, {
    String? excludeUserId,
  }) async {
    try {
      final query = _client
          .from('profiles')
          .select('id')
          .eq('username', username);

      // Exclude current user's ID when checking
      if (excludeUserId != null) {
        query.neq('id', excludeUserId);
      }

      final response = await query.maybeSingle();
      return response == null; // true jika username tersedia
    } on PostgrestException catch (e) {
      print('Error checking username availability: ${e.message}');
      return false;
    } catch (e) {
      print('Error checking username availability: $e');
      return false;
    }
  }

  /// Mengecek apakah email sudah digunakan oleh user lain
  Future<bool> isEmailAvailable(String email, {String? excludeUserId}) async {
    try {
      final query = _client.auth.admin.listUsers();
      // Note: Untuk production, sebaiknya menggunakan API khusus untuk cek email
      // Karena admin API memerlukan service role key

      // Alternatif: bisa menggunakan function di Supabase atau
      // mengandalkan error handling saat update email
      return true; // Return true untuk sementara
    } catch (e) {
      print('Error checking email availability: $e');
      return true;
    }
  }

  /// Update profil user (username, full_name, phone_number)
  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      if (_currentUser == null) {
        throw Exception('User tidak login');
      }

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (username != null) {
        // Cek availability username terlebih dahulu
        final isAvailable = await isUsernameAvailable(
          username,
          excludeUserId: _currentUser!.id,
        );
        if (!isAvailable) {
          throw Exception('Username sudah digunakan oleh user lain');
        }
        updateData['username'] = username;
      }

      if (fullName != null) updateData['full_name'] = fullName;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      await _client
          .from('profiles')
          .update(updateData)
          .eq('id', _currentUser!.id);

      print('Profile updated successfully');
    } on PostgrestException catch (e) {
      print('Error updating profile: ${e.message}');

      if (e.code == '23505') {
        throw Exception('Username sudah digunakan');
      } else if (e.code == '42501') {
        throw Exception('Tidak memiliki izin untuk mengupdate profil');
      }

      throw Exception('Gagal mengupdate profil: ${e.message}');
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  /// Update email user
  Future<void> updateEmail(String newEmail) async {
    try {
      if (_currentUser == null) {
        throw Exception('User tidak login');
      }

      await _client.auth.updateUser(UserAttributes(email: newEmail));

      print('Email update request sent successfully');
    } on AuthException catch (e) {
      print('Error updating email: ${e.message}');

      if (e.message.contains('email already registered')) {
        throw Exception('Email sudah digunakan oleh akun lain');
      } else if (e.message.contains('invalid email')) {
        throw Exception('Format email tidak valid');
      } else if (e.message.contains('rate limit')) {
        throw Exception('Terlalu banyak percobaan. Coba lagi nanti');
      }

      throw Exception('Gagal mengupdate email: ${e.message}');
    } catch (e) {
      print('Error updating email: $e');
      rethrow;
    }
  }

  /// Verifikasi password lama sebelum mengupdate
  Future<bool> verifyCurrentPassword(String currentPassword) async {
    try {
      if (_currentUser == null) {
        throw Exception('User tidak login');
      }

      final email = _currentUser!.email;
      if (email == null) {
        throw Exception('Email user tidak ditemukan');
      }

      // Mencoba login dengan password lama untuk verifikasi
      await _client.auth.signInWithPassword(
        email: email,
        password: currentPassword,
      );

      return true;
    } on AuthException catch (e) {
      print('Password verification failed: ${e.message}');

      if (e.message.contains('invalid login credentials') ||
          e.message.contains('invalid credentials')) {
        return false;
      }

      throw Exception('Gagal memverifikasi password: ${e.message}');
    } catch (e) {
      print('Error verifying password: $e');
      throw Exception('Gagal memverifikasi password');
    }
  }

  /// Update password user
  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (_currentUser == null) {
        throw Exception('User tidak login');
      }

      // Verifikasi password lama terlebih dahulu
      final isCurrentPasswordValid = await verifyCurrentPassword(
        currentPassword,
      );
      if (!isCurrentPasswordValid) {
        throw Exception('Password lama tidak benar');
      }

      // Update ke password baru
      await _client.auth.updateUser(UserAttributes(password: newPassword));

      print('Password updated successfully');
    } on AuthException catch (e) {
      print('Error updating password: ${e.message}');

      if (e.message.contains('password should be at least')) {
        throw Exception('Password baru terlalu pendek (minimal 6 karakter)');
      } else if (e.message.contains('password is too weak')) {
        throw Exception('Password terlalu lemah');
      }

      throw Exception('Gagal mengupdate password: ${e.message}');
    } catch (e) {
      print('Error updating password: $e');
      rethrow;
    }
  }

  /// Update profil lengkap (termasuk email dan password)
  Future<void> updateCompleteProfile({
    String? username,
    String? fullName,
    String? phoneNumber,
    String? newEmail,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      // Update profil basic (username, full_name, phone_number)
      if (username != null || fullName != null || phoneNumber != null) {
        await updateProfile(
          username: username,
          fullName: fullName,
          phoneNumber: phoneNumber,
        );
      }

      // Update email jika berbeda
      if (newEmail != null && newEmail != _currentUser?.email) {
        await updateEmail(newEmail);
      }

      // Update password jika diminta
      if (currentPassword != null && newPassword != null) {
        await updatePassword(currentPassword, newPassword);
      }

      print('Complete profile update successful');
    } catch (e) {
      print('Error in complete profile update: $e');
      rethrow;
    }
  }

  /// Mendapatkan statistik profil user
  Future<Map<String, dynamic>> getProfileStats() async {
    try {
      if (_currentUser == null) {
        throw Exception('User tidak login');
      }

      final profile = await getCurrentProfile();
      if (profile == null) return {};

      final stats = {
        'profile_completion': _calculateProfileCompletion(profile),
        'account_created': profile['created_at'],
        'last_updated': profile['updated_at'],
        'has_avatar': profile['avatar_url'] != null,
        'has_phone': profile['phone_number'] != null,
      };

      return stats;
    } catch (e) {
      print('Error getting profile stats: $e');
      return {};
    }
  }

  /// Menghitung persentase kelengkapan profil
  double _calculateProfileCompletion(Map<String, dynamic> profile) {
    int completedFields = 0;
    int totalFields = 5; // username, full_name, email, phone_number, avatar_url

    if (profile['username'] != null &&
        profile['username'].toString().isNotEmpty) {
      completedFields++;
    }
    if (profile['full_name'] != null &&
        profile['full_name'].toString().isNotEmpty) {
      completedFields++;
    }
    if (_currentUser?.email != null && _currentUser!.email!.isNotEmpty) {
      completedFields++;
    }
    if (profile['phone_number'] != null &&
        profile['phone_number'].toString().isNotEmpty) {
      completedFields++;
    }
    if (profile['avatar_url'] != null &&
        profile['avatar_url'].toString().isNotEmpty) {
      completedFields++;
    }

    return (completedFields / totalFields) * 100;
  }

  /// Log aktivitas update profil
  Future<void> logProfileUpdate(
    String action,
    Map<String, dynamic> details,
  ) async {
    try {
      if (_currentUser == null) return;

      final logData = {
        'user_id': _currentUser!.id,
        'action': action,
        'details': details,
        'timestamp': DateTime.now().toIso8601String(),
        'ip_address': 'unknown', // Bisa ditambahkan jika diperlukan
      };

      // Simpan ke tabel audit log jika ada
      await _client.from('profile_audit_logs').insert(logData);
    } catch (e) {
      print('Error logging profile update: $e');
      // Jangan throw error karena ini optional
    }
  }

  /// Reset profile ke default values
  Future<void> resetProfile() async {
    try {
      if (_currentUser == null) {
        throw Exception('User tidak login');
      }

      await updateProfile(
        username: 'user_${_currentUser!.id.substring(0, 8)}',
        fullName: '',
        phoneNumber: null,
        avatarUrl: null,
      );

      await logProfileUpdate('profile_reset', {
        'reset_time': DateTime.now().toIso8601String(),
      });

      print('Profile reset successfully');
    } catch (e) {
      print('Error resetting profile: $e');
      rethrow;
    }
  }

  /// Validasi data profil sebelum update
  Map<String, String> validateProfileData({
    String? username,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? newPassword,
  }) {
    Map<String, String> errors = {};

    if (username != null) {
      if (username.trim().isEmpty) {
        errors['username'] = 'Username tidak boleh kosong';
      } else if (username.length < 3) {
        errors['username'] = 'Username minimal 3 karakter';
      } else if (username.length > 30) {
        errors['username'] = 'Username maksimal 30 karakter';
      } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
        errors['username'] =
            'Username hanya boleh mengandung huruf, angka, dan underscore';
      }
    }

    if (fullName != null && fullName.trim().isEmpty) {
      errors['fullName'] = 'Nama lengkap tidak boleh kosong';
    }

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phoneNumber)) {
        errors['phoneNumber'] = 'Format nomor telepon tidak valid';
      }
    }

    if (email != null) {
      if (!GetUtils.isEmail(email)) {
        errors['email'] = 'Format email tidak valid';
      }
    }

    if (newPassword != null && newPassword.isNotEmpty) {
      if (newPassword.length < 6) {
        errors['password'] = 'Password minimal 6 karakter';
      } else if (newPassword.length > 50) {
        errors['password'] = 'Password maksimal 50 karakter';
      }
    }

    return errors;
  }
}
