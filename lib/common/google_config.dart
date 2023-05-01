import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final fireStore = FirebaseFirestore.instance;

final user = FirebaseAuth.instance.currentUser;

final googleApiKey = "AIzaSyDqLEUJanM8cM_J0IDyNlXNbwXRArBb81g";

final paystackApiKey = "sk_test_89f14c68dbcd1df1950e55d898d4299d278bd2aa";
final paystack_public_key = "pk_test_648e43ddbc9dcb14554accec07c64b31cf545846";