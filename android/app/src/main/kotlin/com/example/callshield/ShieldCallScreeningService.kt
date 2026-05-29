package com.example.callshield

import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log
import io.flutter.plugin.common.MethodChannel

class ShieldCallScreeningService : CallScreeningService() {
    private val tag = "CallShield"

    override fun onScreenCall(callDetails: Call.Details) {
        val phoneNumber = callDetails.handle.schemeSpecificPart
        Log.d(tag, "Screening incoming call: $phoneNumber")

        if (phoneNumber.isNullOrBlank()) {
            respondToCall(callDetails, allowResponse())
            return
        }

        if (!CallShieldNativeBridge.isShieldActive(this)) {
            respondToCall(callDetails, allowResponse())
            return
        }

        if (CallShieldNativeBridge.isBlockedNumber(this, phoneNumber)) {
            respondToCall(callDetails, blockResponse("Blocked by native blacklist"))
            return
        }

        val engine = CallShieldNativeBridge.getCachedEngine()
        if (engine == null) {
            Log.w(tag, "Flutter engine not available, allowing call")
            respondToCall(callDetails, allowResponse())
            return
        }

        val channel = MethodChannel(
            engine.dartExecutor.binaryMessenger,
            CallShieldNativeBridge.CALL_EVENTS_CHANNEL,
        )

        channel.invokeMethod(
            "incomingCall",
            mapOf(
                "phone" to phoneNumber,
                "callerName" to null,
            ),
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    val decision = result as? Map<*, *> ?: emptyMap<Any?, Any?>()
                    val shouldBlock = decision["shouldBlock"] as? Boolean ?: false
                    val reason = decision["reason"] as? String ?: "Flutter decision"

                    if (shouldBlock) {
                        respondToCall(callDetails, blockResponse(reason))
                    } else {
                        respondToCall(callDetails, allowResponse())
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e(tag, "Flutter call screening error: $errorCode $errorMessage")
                    respondToCall(callDetails, allowResponse())
                }

                override fun notImplemented() {
                    Log.w(tag, "Flutter call screening not implemented")
                    respondToCall(callDetails, allowResponse())
                }
            },
        )
    }

    private fun blockResponse(reason: String): CallResponse {
        Log.d(tag, "Blocking incoming call: $reason")
        return CallResponse.Builder()
            .setDisallowCall(true)
            .setRejectCall(true)
            .setSkipCallLog(false)
            .setSkipNotification(true)
            .build()
    }

    private fun allowResponse(): CallResponse {
        return CallResponse.Builder()
            .setDisallowCall(false)
            .setRejectCall(false)
            .setSkipCallLog(false)
            .setSkipNotification(false)
            .build()
    }
}
