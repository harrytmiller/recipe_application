import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_log/pages/profile_page/profileManager.dart';
import 'package:flutter_log/pages/profile_page/userManager.dart';
import 'package:flutter_log/pages/profile_page/userModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserManager extends Mock implements UserManager {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserModel extends Mock implements UserModel {}

void main() {
  late ProfileManager profileManager;
  late FirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    // Mock FirebaseAuth and FirebaseFirestore
    fakeFirestore = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth();

    // Profile Manager with Mocked Dependencies
    profileManager = ProfileManager(auth: mockAuth, firestore: fakeFirestore);
    profileManager.userManager =
        UserManager(auth: mockAuth, firestore: fakeFirestore);
    profileManager.auth = mockAuth;
    profileManager.firestore = fakeFirestore;
  });

  group('Profile Manager deleteUserDetails()', () {
    test('deleteUserDetails should not update due to no data or invalid uid',
        () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Call the method under test
      await profileManager.deleteUserDetails();

      // Verify that user details are updated in Firestore
      final storedDocument =
          await fakeFirestore.collection('UserDetails').doc('dummyUid').get();
      final storedUserData = storedDocument.data();

      // Expecting storedUserData: null
      expect(storedUserData, null);
    });

    test('deleteUserDetails should not update due to no data or invalid uid',
        () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(null);

      // Call the method under test
      await profileManager.deleteUserDetails();

      // Verify that user details are updated in Firestore
      final storedDocument =
          await fakeFirestore.collection('UserDetails').doc('dummyUid').get();
      final storedUserData = storedDocument.data();

      // Expecting storedUserData: null
      expect(storedUserData, null);
    });

    test('deleteUserDetails should not update due to no data or invalid uid',
        () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Call the method under test
      await profileManager.deleteUserDetails();

      // Verify that user details are updated in Firestore
      final storedDocument =
          await fakeFirestore.collection('UserDetails').doc(null).get();
      final storedUserData = storedDocument.data();

      // Expecting storedUserData: null
      expect(storedUserData, null);
    });
  });

  group('Profile Manager storeUserDetails() Tests', () {
    test('storeUserDetails stores user details in Firestore', () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Create a UserModel instance with some dummy data
      UserModel user = const UserModel(
        age: "30",
        firstName: "John",
        foodRestriction: "None",
        lastName: "Doe",
        username: "johndoe123",
        bio: "Hello, I am John Doe.",
      );

      // Call the method under test
      await profileManager.storeUserDetails(user);

      // Retrieve the stored user details from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await fakeFirestore.collection('UserDetails').doc('dummyUid').get();

      // Verify that the user details are stored correctly in Firestore
      expect(snapshot.exists, true);
      expect(snapshot.data()?['age'], "30");
      expect(snapshot.data()?['firstName'], 'John');
      expect(snapshot.data()?['foodRestriction'], 'None');
      expect(snapshot.data()?['lastName'], 'Doe');
      expect(snapshot.data()?['username'], 'johndoe123');
    });

    test('storeUserDetails stores user details in Firestore', () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Create a UserModel instance with some dummy data
      UserModel user = const UserModel(
        age: "30",
        firstName: "John",
        foodRestriction: "None",
        lastName: "Doe",
        username: "johndoe123",
        bio: "Hello, I am John Doe.",
      );

      // Call the method under test
      await profileManager.storeUserDetails(user);

      // Get a reference to the UserDetails collection
      CollectionReference<Map<String, dynamic>> userDetailsCollection =
          fakeFirestore.collection('UserDetails');

      // Verify that the collection exists
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await userDetailsCollection.get();
      expect(querySnapshot.docs.length, greaterThan(0));
    });

    test('Incorrect user details should return null', () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Verify the result
      final storedDocument =
          await fakeFirestore.collection('UserDetails').doc('dummyUid').get();
      final storedUserData = storedDocument.data();

      // Expecting storedUserData to be null because of incorrect input
      expect(storedUserData, isNull);
    });

    test('Incorrect user details should return null', () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(null);

      // Verify the result
      final storedDocument =
          await fakeFirestore.collection('UserDetails').doc('dummyUid').get();
      final storedUserData = storedDocument.data();

      // Expecting storedUserData to be null because of incorrect input
      expect(storedUserData, isNull);
    });

    test('Incorrect user details should return null', () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Verify the result
      final storedDocument =
          await fakeFirestore.collection('UserDetails').doc(null).get();
      final storedUserData = storedDocument.data();

      // Expecting storedUserData to be null because of incorrect input
      expect(storedUserData, isNull);
    });
  });

  group("Profile Manager getUserDetails() Tests", () {
    test('getCurrentUserUID returns UID when user is authenticated', () async {
      // Set up the fake Firestore collection
      fakeFirestore.collection('UserDetails').doc('dummyUid').set({
        "age": 20,
        "bio": "Hello Mate",
        "firstName": "Josh",
        "foodRestriction": "Vegan",
        "lastName": "Varney",
        "username": "jrv1234455"
      });

      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      Map<String, dynamic>? result = await profileManager.getUserDetails();

      // Expecting a non-empty map with user details
      expect(result, isNotNull);
      expect(result?['age'], 20);
      expect(result?['bio'], 'Hello Mate');
      expect(result?['firstName'], 'Josh');
      expect(result?['foodRestriction'], 'Vegan');
      expect(result?['lastName'], 'Varney');
      expect(result?['username'], 'jrv1234455');
    });

    test('getUserDetails returns null when user is not authenticated',
        () async {
      // Mock the absence of current user
      when(mockAuth.currentUser).thenReturn(null);

      Map<String, dynamic>? result = await profileManager.getUserDetails();

      // Expecting a null result when user is not authenticated
      expect(result, isNull);
    });

    test('getUserDetails returns user details with different data', () async {
      fakeFirestore.collection('UserDetails').doc('anotherUid').set({
        "age": 25,
        "bio": "Hi there!",
        "firstName": "Emily",
        "foodRestriction": "None",
        "lastName": "Smith",
        "username": "emily123"
      });
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'anotherUid'));

      // Call the method under test
      Map<String, dynamic>? result = await profileManager.getUserDetails();

      // Expecting a non-null result with user details
      expect(result, isNotNull);
      expect(result?['age'], 25);
      expect(result?['bio'], 'Hi there!');
      expect(result?['firstName'], 'Emily');
      expect(result?['foodRestriction'], 'None');
      expect(result?['lastName'], 'Smith');
      expect(result?['username'], 'emily123');
    });

    test('getUserDetails returns no data', () async {
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'diffUid'));

      // Call the method under test
      Map<String, dynamic>? result = await profileManager.getUserDetails();

      // Expecting a non-null result with user details
      expect(result, isNull);
    });

    test('getUserDetails returns null as testing with null users', () async {
      fakeFirestore.collection('UserDetails').doc(null).set({
        "age": 25,
        "bio": "Hi there!",
        "firstName": "Emily",
        "foodRestriction": "None",
        "lastName": "Smith",
        "username": "emily123"
      });
      // Mock the current user
      when(mockAuth.currentUser).thenReturn(MockUser(uid: null));

      // Call the method under test
      Map<String, dynamic>? result = await profileManager.getUserDetails();

      // Expecting a non-null result with user details
      expect(result, isNull);
    });
  });

  group('Profile Manager checkInputLength() Tests', () {
    test('Less than exceeded value therefore return true', () {
      bool result = profileManager.checkInputLength('This is an Example Bio');
      expect(result, true); // Assert the expected result
    });

    test('Less than exceeded value therefore return true', () {
      bool result = profileManager
          .checkInputLength('This is an Example Bio: This is a bit longer');
      expect(result, true); // Assert the expected result
    });

    test('More than exceeded value therefore return true', () {
      bool result = profileManager.checkInputLength(
          'John Smith is an intrepid explorer of the human condition, traversing the landscapes of literature, science, and philosophy with equal fervor. With a penchant for unraveling the mysteries of existence, he delves into the depths of the written word, seeking to illuminate the complexities of life. As an avid reader and thinker, he navigates the intricacies of the human psyche, weaving together the threads of thought to craft profound insights into the tapestry of existence. With a heart ablaze with curiosity and a mind as vast as the cosmos, John ventures forth into the realms of knowledge, driven by an insatiable thirst for understanding.');
      expect(result, false); // Assert the expected result
    });

    test('Less than exceeded value therefore return true', () {
      bool result = profileManager.checkInputLength('');
      expect(result, true); // Assert the expected result
    });
  });
}
