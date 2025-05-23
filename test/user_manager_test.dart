import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_log/pages/profile_page/userManager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('UserManager Tests', () {
    late UserManager userManager;
    late MockFirebaseAuth mockAuth;
    late FirebaseFirestore fakeFirestore;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      fakeFirestore = FakeFirebaseFirestore();
      userManager = UserManager(auth: mockAuth, firestore: fakeFirestore);
    });

    group('User Manager: getUserUID() Tests', () {
      test('Test: getUserUID() with current user', () async {
        when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

        final result = await userManager.getCurrentUserUID();

        expect(result, 'dummyUid');
      });

      test('Test: getUserUID() test with no current user', () async {
        // Mock getCurrentUserUID function to return null
        when(mockAuth.currentUser).thenReturn(null);

        // Test the function
        final result = await userManager.getCurrentUserUID();

        // Assert the result
        expect(result, '');
      });
    });

    group('User Manager: getFoodRestriction() Tests', () {
      test('Test: getFoodRestriction with valid documentation', () async {
        // Set up dummy Firestore data
        fakeFirestore.collection('UserDetails').doc('dummyUid').set({
          'foodRestriction': 'Vegitarian',
        });

        // Mock getCurrentUserUID function to return the mock User object
        when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

        // Test the function
        final result = await userManager.getFoodRestriction();

        // Assert the result
        expect(result, equals("Vegitarian"));
      });

      test('Test: getFoodRestriction with non-field document', () async {
        // Set up dummy Firestore data
        fakeFirestore.collection('UserDetails').doc('dummyUid').set({
          'foodRestriction': 'N/A',
        });
        // Mock getCurrentUserUID function to return the mock User object
        when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

        // Test the function
        final result = await userManager.getFoodRestriction();

        // Assert the result
        expect(result, 'N/A');
      });

      test('Test: getFoodRestriction with non-existing document', () async {
        // Mock getCurrentUserUID function to return null
        when(mockAuth.currentUser).thenReturn(null);

        // Test the function
        final Future<String?> resultFuture = userManager.getFoodRestriction();

        // Await the result and assert
        expect(await resultFuture, null);
      });
    });
  });
}
