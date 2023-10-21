import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/my_address_model.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class MyAddressesRepository {
  late List<MyAddress> myAddresses;

  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;
  FirebaseAuthService firebaseAuthService = GetIt.I<FirebaseAuthService>();

  getMyAddresses() {
    myAddresses = [];

    DatabaseReference verifiedAddressesRef = firebaseDatabase
        .ref()
        .child(Environment.getEnvironment())
        .child("users")
        .child("privMeta")
        .child(firebaseAuthService.firebaseAuth.currentUser!.uid)
        .child("myAddresses");

    verifiedAddressesRef.keepSynced(true);

    return verifiedAddressesRef.onValue.map((event) =>
        mapMyAddresses(event.snapshot.value as Map<dynamic, dynamic>));
  }

  List<MyAddress> mapMyAddresses(Map<dynamic, dynamic> addresses) {
    addresses.forEach((key, value) {
      myAddresses.add(MyAddress.fromMap({key: value}));
    });
    return myAddresses;
  }
}
