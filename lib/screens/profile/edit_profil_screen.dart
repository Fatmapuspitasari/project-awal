import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_awal/screens/database/supabase_service.dart';
import 'package:project_awal/screens/database/edit_profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final box = GetStorage();
  final EditProfileService _editProfileService = Get.put(EditProfileService());

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isChangePasswordMode = false;

  Map<String, dynamic>? _currentProfile;
  String? _originalUsername;
  String? _originalEmail;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoading = true);

    try {
      final profile = await _editProfileService.getCurrentProfile();
      if (profile != null) {
        setState(() {
          _currentProfile = profile;
          _originalUsername = profile['username'];
          _usernameController.text = profile['username'] ?? '';
          _fullNameController.text = profile['full_name'] ?? '';
          _phoneController.text = profile['phone_number'] ?? '';

          // Get email from current user
          final supabaseService = Get.find<SupabaseService>();
          _originalEmail = supabaseService.currentUser?.email ?? '';
          _emailController.text = _originalEmail ?? '';
        });

        // Update local storage
        box.write('username', profile['username']);
        box.write('full_name', profile['full_name']);
        box.write('phone', profile['phone_number']);
        box.write('email', _originalEmail);
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memuat profil: ${e.toString()}');

      // Fallback to local storage if database fails
      _usernameController.text = box.read('username') ?? '';
      _fullNameController.text = box.read('full_name') ?? '';
      _phoneController.text = box.read('phone') ?? '';
      _emailController.text = box.read('email') ?? '';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final username = _usernameController.text.trim();
      final fullName = _fullNameController.text.trim();
      final phone = _phoneController.text.trim();
      final newEmail = _emailController.text.trim();

      // Validate data before submitting
      final validationErrors = _editProfileService.validateProfileData(
        username: username,
        fullName: fullName,
        phoneNumber: phone.isNotEmpty ? phone : null,
        email: newEmail,
        newPassword:
            _newPasswordController.text.isNotEmpty
                ? _newPasswordController.text
                : null,
      );

      if (validationErrors.isNotEmpty) {
        final errorMessage = validationErrors.values.first;
        _showErrorSnackbar(errorMessage);
        return;
      }

      // Use complete profile update method
      await _editProfileService.updateCompleteProfile(
        username: username != _originalUsername ? username : null,
        fullName: fullName,
        phoneNumber: phone.isNotEmpty ? phone : null,
        newEmail: newEmail != _originalEmail ? newEmail : null,
        currentPassword:
            _isChangePasswordMode && _currentPasswordController.text.isNotEmpty
                ? _currentPasswordController.text
                : null,
        newPassword:
            _isChangePasswordMode && _newPasswordController.text.isNotEmpty
                ? _newPasswordController.text
                : null,
      );

      // Update local storage
      box.write('username', username);
      box.write('full_name', fullName);
      box.write('phone', phone);
      if (newEmail == _originalEmail) {
        box.write('email', newEmail);
      }

      // Show success message
      _showSuccessSnackbar('Profil berhasil diperbarui');

      // Show email confirmation dialog if email was changed
      if (newEmail != _originalEmail) {
        _showEmailConfirmationDialog();
      }

      // Clear password fields after successful update
      if (_isChangePasswordMode) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        setState(() => _isChangePasswordMode = false);
      }

      // Reload profile data
      await _loadCurrentProfile();
    } catch (e) {
      _showErrorSnackbar(_getErrorMessage(e));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showEmailConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Email'),
        content: const Text(
          'Email baru telah dikirim ke alamat email Anda. '
          'Silakan cek email dan klik link konfirmasi untuk mengaktifkan email baru.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blue[500],
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Profile Info Section
                      _buildSectionHeader('Informasi Profil'),
                      const SizedBox(height: 16),

                      _buildFormField(
                        controller: _usernameController,
                        icon: Icons.person,
                        label: 'Username',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          if (value.length < 3) {
                            return 'Username minimal 3 karakter';
                          }
                          if (value.length > 30) {
                            return 'Username maksimal 30 karakter';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                            return 'Username hanya boleh mengandung huruf, angka, dan underscore';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildFormField(
                        controller: _fullNameController,
                        icon: Icons.badge,
                        label: 'Nama Lengkap',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildFormField(
                        controller: _phoneController,
                        icon: Icons.phone,
                        label: 'Nomor Telepon (Opsional)',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                              return 'Format nomor telepon tidak valid';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Account Security Section
                      _buildSectionHeader('Keamanan Akun'),
                      const SizedBox(height: 16),

                      _buildFormField(
                        controller: _emailController,
                        icon: Icons.email,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Change Password Toggle
                      Card(
                        elevation: 2,
                        child: SwitchListTile(
                          title: const Text(
                            'Ubah Password',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: const Text(
                            'Aktifkan untuk mengubah password',
                          ),
                          value: _isChangePasswordMode,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              _isChangePasswordMode = value;
                              if (!value) {
                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                              }
                            });
                          },
                        ),
                      ),

                      // Password Fields (if enabled)
                      if (_isChangePasswordMode) ...[
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          controller: _currentPasswordController,
                          label: 'Password Lama',
                          obscureText: _obscureCurrentPassword,
                          onToggleVisibility: () {
                            setState(
                              () =>
                                  _obscureCurrentPassword =
                                      !_obscureCurrentPassword,
                            );
                          },
                          validator: (value) {
                            if (_isChangePasswordMode &&
                                (value == null || value.isEmpty)) {
                              return 'Password lama harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildPasswordField(
                          controller: _newPasswordController,
                          label: 'Password Baru',
                          obscureText: _obscureNewPassword,
                          onToggleVisibility: () {
                            setState(
                              () => _obscureNewPassword = !_obscureNewPassword,
                            );
                          },
                          validator: (value) {
                            if (_isChangePasswordMode) {
                              if (value == null || value.isEmpty) {
                                return 'Password baru harus diisi';
                              }
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              if (value.length > 50) {
                                return 'Password maksimal 50 karakter';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          label: 'Konfirmasi Password Baru',
                          obscureText: _obscureConfirmPassword,
                          onToggleVisibility: () {
                            setState(
                              () =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                            );
                          },
                          validator: (value) {
                            if (_isChangePasswordMode) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password harus diisi';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Password tidak cocok';
                              }
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child:
                              _isLoading
                                  ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Menyimpan...'),
                                    ],
                                  )
                                  : const Text(
                                    'Simpan Perubahan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          errorStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onToggleVisibility,
          ),
          errorStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
