import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SecureStorageService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> saveData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    notifyListeners();
  }

  Future<String?> readData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
    notifyListeners();
  }

  Future<void> deleteAllData() async {
    await _secureStorage.deleteAll();
    notifyListeners();
  }
}

class SecureStorageProvider extends StatelessWidget {
  final Widget child;

  const SecureStorageProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SecureStorageService>(
      create: (_) => SecureStorageService(),
      child: child,
    );
  }

  static SecureStorageService of(BuildContext context) {
    return context.read<SecureStorageService>();
  }
}