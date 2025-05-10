import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/features/auth/logic/login_cubit.dart';
import 'package:grade3/features/auth/logic/login_state.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';
import 'package:grade3/features/user_account/data/models/user_profile_model.dart';
import 'package:grade3/features/user_account/logic/user_profile_cubit.dart';
import 'package:grade3/features/user_account/logic/user_profile_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();

    // Only call getUserProfile if not already loaded
    final userProfileState = context.read<UserProfileCubit>().state;
    if (userProfileState is! UserProfileLoaded) {
      context.read<UserProfileCubit>().getUserProfile();
    } else {
      // If already loaded, check for sync
      _syncProfileImageWithServer(userProfileState.userProfile);
    }
  }

  Future<void> _loadProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          setState(() {
            _profileImage = file;
          });
          print('Loaded profile image from local storage: $imagePath');
        } else {
          print('Profile image file does not exist: $imagePath');
        }
      } else {
        print('No profile image path found in preferences');
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  // Check if we need to update the server with the local profile image
  Future<void> _syncProfileImageWithServer(UserProfileModel userProfile) async {
    // This will be implemented when the backend supports image upload
    // For now, we just log the information
    final bool hasLocalImage = _profileImage != null;
    final bool hasRemoteImage = userProfile.profileImageUrl != null &&
        userProfile.profileImageUrl!.isNotEmpty;

    if (hasLocalImage && !hasRemoteImage) {
      print(
          'Local image exists but not on server. Will need to upload when backend supports it.');
      // TODO: Implement server upload when backend is ready
    } else if (!hasLocalImage && hasRemoteImage) {
      print(
          'Remote image exists but not locally. Downloading is not implemented yet.');
      // TODO: Implement download functionality if needed
    } else if (hasLocalImage && hasRemoteImage) {
      print(
          'Both remote and local images exist. Would need comparison logic to determine which is newer.');
      // TODO: Implement comparison logic
    } else {
      print('No profile image exists locally or remotely.');
    }
  }

  Future<void> _saveProfileImagePath(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', path);
    } catch (e) {
      print('Error saving profile image path: $e');
    }
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Profile Photo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.blue),
              ),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context);
                await _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library, color: Colors.blue),
              ),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _getImage(ImageSource.gallery);
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Remove photo'),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() {
                    _profileImage = null;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('profile_image_path');

                  // Show success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile picture removed'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        await _saveProfileImagePath(pickedFile.path);

        // TODO: When backend supports image upload, implement here
        // For example:
        // await _uploadProfileImageToServer(pickedFile.path);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await context.read<LoginCubit>().logout();
      if (context.mounted) {
        GoRouter.of(context).go(AppRouter.loginView);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginInitial) {
              GoRouter.of(context).go(AppRouter.loginView);
            }
          },
        ),
        BlocListener<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is UserProfileLoaded) {
              // Try to sync profile image data when profile is loaded
              _syncProfileImageWithServer(state.userProfile);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserProfileLoaded) {
                return _buildProfileContent(context, state.userProfile);
              } else if (state is UserProfileError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, UserProfileModel userProfile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildProfileSection(context, userProfile),
          _buildUserInfo(context, userProfile),
          _buildLogoutButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 24),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
      BuildContext context, UserProfileModel userProfile) {
    // Determine the image source priority:
    // 1. If there's a remote profile image URL from the server, use that
    // 2. Otherwise, use the locally saved image file
    // 3. If neither is available, fall back to the default profile image

    final bool hasRemoteImage = userProfile.profileImageUrl != null &&
        userProfile.profileImageUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Stack(
            children: [
              CustomRoundedImage(
                imageFile: !hasRemoteImage ? _profileImage : null,
                imageUrl: hasRemoteImage ? userProfile.profileImageUrl : null,
                width: MediaQuery.sizeOf(context).width * 0.35,
                onTap: _pickImage,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userProfile.name,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 22),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userProfile.email,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 14),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserProfileModel userProfile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person_outline,
            title: 'Name',
            value: userProfile.name,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.email_outlined,
            title: 'Email',
            value: userProfile.email,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.person_outline,
            title: 'Gender',
            value: userProfile.gender.isNotEmpty
                ? userProfile.gender.substring(0, 1).toUpperCase() +
                    userProfile.gender.substring(1)
                : 'Not specified',
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Date of Birth',
            value: _formatDate(userProfile.dob),
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            title: 'Mobile Number',
            value: userProfile.mobileNumber.isNotEmpty
                ? userProfile.mobileNumber
                : 'Not specified',
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.work_outline,
            title: 'Role',
            value: userProfile.role.isNotEmpty
                ? userProfile.role.substring(0, 1).toUpperCase() +
                    userProfile.role.substring(1)
                : 'User',
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Not specified';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey,
      indent: 70,
      endIndent: 0,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleLogout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
