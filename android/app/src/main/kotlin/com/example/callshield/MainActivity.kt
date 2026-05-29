package com.example.callshield

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FlutterEngineCache.getInstance().put(CallShieldNativeBridge.FLUTTER_ENGINE_CACHE_KEY, flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CallShieldNativeBridge.BLOCKING_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "toggleShield" -> {
                    val active = call.argument<Boolean>("active") ?: false
                    CallShieldNativeBridge.setShieldActive(this, active)
                    result.success(true)
                }

                "blockNumber" -> {
                    val number = call.argument<String>("number")
                    if (number.isNullOrBlank()) {
                        result.error("invalid_args", "number is required", null)
                        return@setMethodCallHandler
                    }

                    CallShieldNativeBridge.saveBlockedNumber(this, number)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
}
