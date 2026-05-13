package com.example.callshield

import android.content.Context
import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log

class ShieldCallScreeningService : CallScreeningService() {
    override fun onScreenCall(callDetails: Call.Details) {
        val phoneNumber = callDetails.handle.schemeSpecificPart
        Log.d("CallShield", "Screening incoming call: $phoneNumber")

        // Logic to check against MTC Blacklist
        // For simulation, we block any number starting with '0800'
        val isScam = phoneNumber.startsWith("0800")

        val response = CallResponse.Builder()
        if (isScam) {
            Log.d("CallShield", "SCAM DETECTED! Blocking: $phoneNumber")
            response.setDisallowCall(true)
            response.setRejectCall(true)
            response.setSkipCallLog(false)
            response.setSkipNotification(true)
        } else {
            response.setDisallowCall(false)
            response.setRejectCall(false)
            response.setSkipCallLog(false)
            response.setSkipNotification(false)
        }

        respondToCall(callDetails, response.build())
    }
}
