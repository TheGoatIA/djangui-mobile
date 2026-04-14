package cm.tbg.kauri

import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val SECURE_SCREEN_CHANNEL = "kauri/secure_screen"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Canal MethodChannel pour la protection des captures d'écran (FLAG_SECURE).
        // Appelé par SecureScreenMixin sur les écrans sensibles (wallet, transactions,
        // sécurité, KYC). Bloque screenshots et enregistrements d'écran sur Android.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SECURE_SCREEN_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSecureMode" -> {
                    window.setFlags(
                        WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE,
                    )
                    result.success(null)
                }
                "disableSecureMode" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
