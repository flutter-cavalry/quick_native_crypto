import Cocoa
import CryptoKit
import FlutterMacOS

public class QuickNativeCryptoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "quick_native_crypto", binaryMessenger: registrar.messenger)
    let instance = QuickNativeCryptoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "InvalidArgsType", message: "Invalid args type", details: nil))
      return
    }
    switch call.method {
    case "aesEncrypt":
      let nonce = (args["nonce"] as! FlutterStandardTypedData).data
      let key = (args["key"] as! FlutterStandardTypedData).data
      let plaintext = (args["plaintext"] as! FlutterStandardTypedData).data

      if #available(macOS 10.15, *) {
        DispatchQueue.global().async {
          do {
            let secretKey = SymmetricKey(data: key)
            let res = try AES.GCM.seal(
              plaintext,
              using: secretKey,
              nonce: AES.GCM.Nonce(data: nonce))

            DispatchQueue.main.async {
              result([
                "ciphertext": FlutterStandardTypedData(bytes: res.ciphertext),
                "mac": FlutterStandardTypedData(bytes: res.tag),
              ])
            }
          } catch {
            DispatchQueue.main.async {
              result(
                FlutterError(code: "PluginError", message: error.localizedDescription, details: nil)
              )
            }
          }
        }
      } else {
        result(
          FlutterError(
            code: "NotSupportedError", message: "Not available in your system", details: nil))
      }

    case "aesDecrypt":
      let nonce = (args["nonce"] as! FlutterStandardTypedData).data
      let key = (args["key"] as! FlutterStandardTypedData).data
      let ciphertext = (args["ciphertext"] as! FlutterStandardTypedData).data
      let mac = (args["mac"] as! FlutterStandardTypedData).data

      if #available(macOS 10.15, *) {
        DispatchQueue.global().async {
          do {
            let secretKey = SymmetricKey(data: key)
            let sealedBox = try AES.GCM.SealedBox(
              nonce: AES.GCM.Nonce(data: nonce),
              ciphertext: ciphertext,
              tag: mac)
            let plaintext = try AES.GCM.open(sealedBox, using: secretKey)

            DispatchQueue.main.async {
              result([
                "plaintext": FlutterStandardTypedData(bytes: plaintext)
              ])
            }
          } catch {
            DispatchQueue.main.async {
              result(
                FlutterError(code: "PluginError", message: error.localizedDescription, details: nil)
              )
            }
          }
        }
      } else {
        result(
          FlutterError(
            code: "NotSupportedError", message: "Not available in your system", details: nil))
        return
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
