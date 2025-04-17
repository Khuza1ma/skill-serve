import 'package:encrypt/encrypt.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'logger.dart';

//ignore_for_file: public_member_api_docs, unused_element

// TODO(Khuza1ma): change private key.
//Get it generated from NodeJS library
const String _rsaPrivateKey =
    'MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALrknq4NRyg1BXfdDXWqz4Xahnk3s7vceMPSi5KWcOokfO3gr/vgZ3+oGWMrU7E6LkSYGXUCK5gXATMrxqKXzTUmhvWQWPdP0BAsqHrDJLL7wuS9SQjqiIAvA91KLncgx0m7gQfEMsUfm5vvbYRWz9V1QLLnlZA/fAIIPJ6L0QfjAgMBAAECgYBmQcSYkudGFoyhYq+EnCrjoAdHt7R9q0ngSwjW8b1iPwij1vYzKDs4267YVdJ6+8xo95emL8POeXfMmb0bJVe/N1x1OjS1BrRBpvAXjK0tKpb+O7vh1ElK7SafW/O1UpI0AID4g1qx/0kE2cAmKS9GA7N44nsKRkGSWfxLXSoZIQJBAOary7io6UKJcHdJZy9PcBCJNjXfOQFhMWeg3g1X/EjhOCjW+fM4Shp3HkIR3E7P7ZDZqWMSmDrcB+oqSYsStOkCQQDPajdJxhPwVqCoGBvPim296xnertZ2obHawGr6vBzRMPD0pqX+pZlnq+hcZ+TKjH+CU6vZyJmSDhMUW4rze4brAkEArtS265badNvGqiKwWmNTBLV6qQovIqSP1YNPyb1OMc7ByfJmL7oSMEzoWhs/Z1yhKpBOmhCV4Ma0GP9EDmx3QQJBAKKoVnFpgAtztAv+1Bh/I67Tp3cFv7RK+9JkIcE+Mo8vBVenNPgtX894dgG5jCf35KsM+PESqrRqizXk0GQ/lD8CQFr7bIoMSMt2CQM2nqwuWU8xJVF5pUYHGB6aZXrAFHT7W/slzgwzvLFPrdzSLgp1c4pHmT+clWrylAoU4F4p3uU=';

// TODO(Khuza1ma): change public key.
//Get it generated from NodeJS library
const String _rsaPublicKey =
    'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC65J6uDUcoNQV33Q11qs+F2oZ5N7O73HjD0ouSlnDqJHzt4K/74Gd/qBljK1OxOi5EmBl1AiuYFwEzK8ail801Job1kFj3T9AQLKh6wySy+8LkvUkI6oiALwPdSi53IMdJu4EHxDLFH5ub722EVs/VdUCy55WQP3wCCDyei9EH4wIDAQAB';

Uint8List secretKey = Uint8List.fromList(
    <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
Uint8List secretIv = Uint8List.fromList(
    <int>[21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]);

/*class AppEncryption {
  static final RSAPrivateKey _privateKey =
      RSAPrivateKey.fromString(_rsaPrivateKey);
  static final RSAPublicKey _publicKey = RSAPublicKey.fromString(_rsaPublicKey);

  static String encrypt({@required String? plainText}) {
    String encryptedPlainText;

    if (plainText != null) {
      encryptedPlainText = _publicKey.encrypt(plainText);
    } else {
      throw Exception('plainText is required');
    }

    return encryptedPlainText;
  }

  static String decrypt({@required String? encryptedPlainText}) {
    String decryptedPlainText;

    if (encryptedPlainText != null) {
      decryptedPlainText = _privateKey.decrypt(encryptedPlainText);
    } else {
      throw Exception('encryptedPlainText is required');
    }

    return decryptedPlainText;
  }

  static void testEncryption() {
    final message = 'testtesttesttest';

    var publicKey = RSAPublicKey.fromString(_rsaPublicKey);
    var privateKey = RSAPrivateKey.fromString(_rsaPrivateKey);

    final encrypted = publicKey.encrypt(message);
    final decrypted = privateKey.decrypt(encrypted);

    final privateKeyString = privateKey.toString();
    final publicKeyString = publicKey.toString();

    logI('Your Private Key\n $privateKeyString\n---');
    logI('Your Public Key\n $publicKeyString\n---');
    logD('Encrypted Message\n $encrypted\n---');
    logD('Decrypted Message\n $decrypted\n---');

    if (decrypted == message) {
      logI('The Message was successfully decrypted!');
    } else {
      logWTF('Failed to decrypted the Message!');
    }
  }
}*/

class AppEncryption {
  static final Key key = Key(secretKey);
  static final IV iv = IV(secretIv);

  static final Encrypter encrypter = Encrypter(AES(
    key,
    mode: AESMode.ctr,
    padding: null,
  ));

  static String encrypt({required String plainText}) {
    final Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);

    return encrypted.base16;
  }

  static String decrypt({required String cipherText}) {
    final String decrypted = encrypter.decrypt16(cipherText, iv: iv);

    return decrypted;
  }

  static void testEncryption() {
    final String plainText = jsonEncode(<String, dynamic>{
      'name': '',
      'username': 'test',
      'email': '',
      'phone': '',
      'country': '',
      'city': '',
      'bio': '',
      'current_location': '',
      'first_name': '',
      'last_name': '',
      'address_line1': '',
      'address_line2': '',
      'is_verified': false,
      'job_post': '',
      'password': 'passwordpasswordpasswordpasswordpassword',
    });
    // final plainText = 'Khuza1ma testing here again';

    final Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    final String decrypted = encrypter.decrypt(encrypted, iv: iv);

    logI('Decrypted :: $decrypted');
    // logI('bytes :: '+encrypted.bytes.toString());
    logI('base16 :: ${encrypted.base16}');
    logI('base64 :: ${encrypted.base64}');

    //bytes to string
    String? separator;
    int? wrap;
    final Uint8List bytes = encrypted.bytes;
    int len = 0;
    final StringBuffer buf = StringBuffer();
    for (final int b in bytes) {
      final String s = b.toRadixString(16);
      // ignore: unnecessary_null_comparison
      if (buf.isNotEmpty && separator != null) {
        buf.write(separator);
        len += separator.length;
      }
      // ignore: unnecessary_null_comparison
      if (wrap != null && wrap < len + 2) {
        buf.write('\n');
        len = 0;
      }

      buf.write('${(s.length == 1) ? '0' : ''}$s');
      len += 2;
    }
    logI('bytes to base16 :: $buf');
  }
}
