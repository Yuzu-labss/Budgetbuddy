import 'package:firebase_auth/firebase_auth.dart';

import '../config/constants.dart';
import '../models/app_user.dart';
import '../models/budget.dart';
import 'database_service.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({FirebaseAuth? auth, DatabaseService? database})
    : _auth = auth ?? FirebaseAuth.instance,
      _database = database ?? DatabaseService();

  final FirebaseAuth _auth;
  final DatabaseService _database;

  Stream<AppUser?> get authStateChanges => _auth.authStateChanges().map(
    (user) => user == null ? null : _fromFirebaseUser(user),
  );

  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final firebaseUser = credential.user!;
      final name = _nameFromEmail(firebaseUser.email ?? email);

      await firebaseUser.updateDisplayName(name);

      final appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? email.trim(),
        displayName: name,
        createdAt: DateTime.now(),
      );

      await _database.userRef(appUser.uid).set(appUser.toMap());

      // Best-effort seed of the per-user budget doc so the account owns its
      // budget record in Firestore from the start. A missing doc simply falls
      // back to defaults on first read, so a failure here must not block sign-up.
      try {
        await _database
            .budgetsRef(appUser.uid)
            .doc(kBudgetDocId)
            .set(const Budget().toMap());
      } on FirebaseException {
        // Ignore: BudgetService.getBudget returns defaults when absent.
      }

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code, e.message));
    } on FirebaseException {
      throw const AuthException(
        'Account created, but we could not save your profile. '
        'Please log in again.',
      );
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final firebaseUser = credential.user!;
      return await _loadOrCreateProfile(firebaseUser);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code, e.message));
    }
  }

  Future<void> logout() => _auth.signOut();

  Future<AppUser> _loadOrCreateProfile(User firebaseUser) async {
    try {
      final ref = _database.userRef(firebaseUser.uid);
      final snapshot = await ref.get();
      final data = snapshot.data();
      if (snapshot.exists && data != null) {
        return AppUser.fromMap(data);
      }
      final created = _fromFirebaseUser(firebaseUser);
      await ref.set(created.toMap());
      return created;
    } on FirebaseException {
      return _fromFirebaseUser(firebaseUser);
    }
  }

  AppUser _fromFirebaseUser(User user) {
    final name = user.displayName;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: (name != null && name.trim().isNotEmpty)
          ? name
          : _nameFromEmail(user.email ?? ''),
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  String _nameFromEmail(String email) {
    final prefix = email.split('@').first.trim();
    return prefix.isEmpty ? 'Student' : prefix;
  }

  String _messageFor(String code, [String? message]) {
    switch (code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      default:
        return 'Error ($code): ${message ?? 'no details'}';
    }
  }
}
