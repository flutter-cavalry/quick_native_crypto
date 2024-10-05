package com.fluttercavalry.quick_native_crypto

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import javax.crypto.*
import javax.crypto.spec.*

object Constants {
  const val GCM_TAG_LENGTH = 16
}

/** QuickNativeCryptoPlugin */
class QuickNativeCryptoPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "quick_native_crypto")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "aesEncrypt" -> {
        // Arguments are enforced at dart level.
        val nonce = call.argument<ByteArray>("nonce")!!
        val key = call.argument<ByteArray>("key")!!
        val plaintext = call.argument<ByteArray>("plaintext")!!
        try {
          val secretKey: SecretKey = secretAESKey(key)
          val cipher = Cipher.getInstance("AES/GCM/NoPadding")
          cipher.init(Cipher.ENCRYPT_MODE, secretKey, IvParameterSpec(nonce))
          val cipherRes = cipher.doFinal(plaintext)
          val cipherText = cipherRes.copyOfRange(0, cipherRes.size - Constants.GCM_TAG_LENGTH)
          val mac = cipherRes.copyOfRange(cipherRes.size - Constants.GCM_TAG_LENGTH, cipherRes.size)

          Handler(Looper.getMainLooper()).post {
            result.success(
              mapOf(
                "ciphertext" to cipherText,
                "mac" to mac,
              )
            )
          }
        } catch (err: Exception) {
          Handler(Looper.getMainLooper()).post {
            result.error("Err", err.message, null)
          }
        }
      }
      "aesDecrypt" -> {
        // Arguments are enforced at dart level.
        val nonce = call.argument<ByteArray>("nonce")!!
        val key = call.argument<ByteArray>("key")!!
        val ciphertext = call.argument<ByteArray>("ciphertext")!!
        val mac = call.argument<ByteArray>("mac")!!
        try {
          val secretKey: SecretKey = secretAESKey(key)
          val cipher = Cipher.getInstance("AES/GCM/NoPadding")
          cipher.init(Cipher.DECRYPT_MODE, secretKey, IvParameterSpec(nonce))
          val plaintext = cipher.doFinal(ciphertext + mac)

          Handler(Looper.getMainLooper()).post {
            result.success(
              mapOf(
                "plaintext" to plaintext,
              )
            )
          }
        } catch (err: Exception) {
          Handler(Looper.getMainLooper()).post {
            result.error("Err", err.message, null)
          }
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun secretAESKey(key: ByteArray): SecretKey {
    return SecretKeySpec(key, 0, key.size, "AES")
  }
}
