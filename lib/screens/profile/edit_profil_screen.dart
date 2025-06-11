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

    // Register SupabaseService jika belum ada
    if (!Get.isRegistered<SupabaseService>()) {
      Get.put(SupabaseService());
    }

    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoading = true);

    try {
      final profile = await _editProfileService.getCurrentProfile();
      if (profile != null) {
        setState(() {
          _currentProfile = profile;
          _originalUsername = profile['full_name'];
          _usernameController.text = profile['full_name'] ?? '';
          _phoneController.text = profile['phone_number'] ?? '';

          // Get email from current user - akses langsung ke Supabase
          _originalEmail =
              Supabase.instance.client.auth.currentUser?.email ?? '';
          _emailController.text = _originalEmail ?? '';
        });

        // Update local storage to match profile screen format
        box.write(
          'username',
          profile['full_name'],
        ); // Store as username for profile screen
        box.write('phone', profile['phone_number']);
        box.write('email', _originalEmail);
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memuat profil: ${e.toString()}');

      // Fallback to local storage if database fails
      _usernameController.text = box.read('username') ?? '';
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
      final phone = _phoneController.text.trim();
      final newEmail = _emailController.text.trim();

      // Validate data before submitting
      final validationErrors = _editProfileService.validateProfileData(
        username: username,
        fullName: username,
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
        username: username,
        fullName: username,
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

      // Update local storage to match profile screen expectations
      box.write(
        'username',
        username,
      ); // Profile screen reads this as display name
      box.write('phone', phone);
      if (newEmail != _originalEmail) {
        // Only update email in storage if it's the same (not changed)
        // If changed, wait for email confirmation
      } else {
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
    _phoneController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
                      _buildSectionCard(
                        title: 'Informasi Profil',
                        children: [
                          _buildFormField(
                            controller: _usernameController,
                            icon: Icons.person,
                            label: 'Nama Lengkap',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama lengkap tidak boleh kosong';
                              }
                              if (value.length < 3) {
                                return 'Nama lengkap minimal 3 karakter';
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
                                if (!RegExp(
                                  r'^\+?[0-9]{10,15}$',
                                ).hasMatch(value)) {
                                  return 'Format nomor telepon tidak valid';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Account Security Section
                      _buildSectionCard(
                        title: 'Keamanan Akun',
                        children: [
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
                            elevation: 0,
                            color:
                                theme.brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: theme.dividerColor.withOpacity(0.2),
                              ),
                            ),
                            child: SwitchListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              title: Text(
                                'Ubah Password',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Aktifkan untuk mengubah password',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              value: _isChangePasswordMode,
                              activeColor: theme.primaryColor,
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
                                  () =>
                                      _obscureNewPassword =
                                          !_obscureNewPassword,
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
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            disabledBackgroundColor: theme.disabledColor,
                          ),
                          child:
                              _isLoading
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                theme.brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('Menyimpan...'),
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

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          labelText: label,
          labelStyle: TextStyle(color: theme.hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorStyle: TextStyle(fontSize: 12, color: theme.colorScheme.error),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.lock, color: theme.primaryColor, size: 20),
          ),
          labelText: label,
          labelStyle: TextStyle(color: theme.hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: theme.hintColor,
              size: 20,
            ),
            onPressed: onToggleVisibility,
          ),
          errorStyle: TextStyle(fontSize: 12, color: theme.colorScheme.error),
        ),
      ),
    );
  }
}
