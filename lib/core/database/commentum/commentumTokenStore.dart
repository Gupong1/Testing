import 'package:commentum_client/commentum_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommentumTokenStore extends CommentumStorage {
  String _providerKey(CommentumProvider provider) => "commentum_${provider.name}_token";
  String _oauthKey(CommentumProvider provider) => "commentum_${provider.name}_oauth";

  final _fss = const FlutterSecureStorage();

  @override
  Future<void> clearAll() async {
    for (final provider in CommentumProvider.values) {
      await _fss.delete(key: _providerKey(provider));
      await _fss.delete(key: _oauthKey(provider));
    }
  }

  @override
  Future<void> deleteToken(CommentumProvider provider) {
    return _fss.delete(key: _providerKey(provider));
  }

  @override
  Future<String?> getToken(CommentumProvider provider) {
    return _fss.read(key: _providerKey(provider));
  }

  @override
  Future<void> saveToken(CommentumProvider provider, String token) {
    return _fss.write(key: _providerKey(provider), value: token);
  }

  @override
  Future<void> saveProviderToken(CommentumProvider provider, String token) {
    return _fss.write(key: _oauthKey(provider), value: token);
  }

  @override
  Future<String?> getProviderToken(CommentumProvider provider) {
    return _fss.read(key: _oauthKey(provider));
  }

  @override
  Future<void> deleteProviderToken(CommentumProvider provider) {
    return _fss.delete(key: _oauthKey(provider));
  }

  @override
  Future<Map<CommentumProvider, String>> getAllTokens() async {
    final map = <CommentumProvider, String>{};
    for (final provider in CommentumProvider.values) {
      final t = await getToken(provider);
      if (t != null && t.isNotEmpty) map[provider] = t;
    }
    return map;
  }
}