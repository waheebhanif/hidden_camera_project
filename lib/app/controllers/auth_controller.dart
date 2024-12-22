import 'dart:developer';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidden_camera_detector/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> user = Rx<User?>(null);
  RxString userName = ''.obs; // Observable for the user's name
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    user.value = _auth.currentUser;
    if (user.value != null) {
      _fetchUserName();
    }
    super.onInit();
  }

  Future<void> _fetchUserName() async {
    try {
      final doc =
          await _firestore.collection('users').doc(user.value!.uid).get();
      if (doc.exists) {
        userName.value = doc['name'] ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user name: $e');
    }
  }

  Future<void> updateName(String newName) async {
    try {
      isLoading.value = true;
      await _firestore.collection('users').doc(user.value!.uid).update({
        'name': newName,
      });
      userName.value = newName;
      Get.snackbar('Success', 'Name updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      isLoading.value = true;

      // Re-authenticate the user
      bool reauthSuccess = await reauthenticateUser(currentPassword);
      if (!reauthSuccess) {
        Get.snackbar('Error', 'Re-authentication failed. Please try again.');
        return;
      }

      // Update password
      await user.value!.updatePassword(newPassword);
      Get.snackbar('Success', 'Password updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      user.value = userCredential.user;
      Get.snackbar('Registration Success', 'Welcome $name!');
      Get.toNamed(AppRoutes.BOTTOM_NAVBAR);
    } catch (e) {
      Get.snackbar('Registration Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user.value = userCredential.user;

      Get.toNamed(AppRoutes.BOTTOM_NAVBAR);
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    user.value = null;
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  // Re-authenticate user before sensitive operations
  Future<bool> reauthenticateUser(String password) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || currentUser.email == null) {
        Get.snackbar('Error', 'No user is currently signed in');
        return false;
      }

      // Create credentials
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );

      // Re-authenticate
      await currentUser.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      Get.snackbar('Re-authentication Error', e.toString());
      return false;
    }
  }

  // Delete account and all associated data
  Future<void> deleteAccount(String password) async {
    try {
      isLoading.value = true;
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        Get.snackbar('Error', 'No user is currently signed in');
        return;
      }

      // First, re-authenticate the user
      bool reauthSuccess = await reauthenticateUser(password);
      if (!reauthSuccess) {
        Get.snackbar('Error', 'Re-authentication failed. Please try again.');
        return;
      }

      // Delete user data from Firestore first
      await _deleteUserData(currentUser.uid);

      // Finally, delete the user account
      await currentUser.delete();

      user.value = null;
      Get.snackbar('Success', 'Your account has been deleted successfully');
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar('Account Deletion Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to delete user data from Firestore
  Future<void> _deleteUserData(String userId) async {
    try {
      // Delete user document
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user data: ${e.toString()}');
      throw e; // Re-throw to handle in the calling method
    }
  }
}
