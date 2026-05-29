package com.example.callshield

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

object CallShieldNativeBridge {
    const val BLOCKING_CHANNEL = "com.mtc.callshield/blocking"
    const val CALL_EVENTS_CHANNEL = "com.mtc.callshield/call_events"
    const val FLUTTER_ENGINE_CACHE_KEY = "callshield_engine"
    private const val PREFS_NAME = "callshield_native"

    fun getPreferences(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    fun setShieldActive(context: Context, active: Boolean) {
        getPreferences(context).edit().putBoolean("shield_active", active).apply()
    }

    fun isShieldActive(context: Context): Boolean {
        return getPreferences(context).getBoolean("shield_active", true)
    }

    fun saveBlockedNumber(context: Context, number: String) {
        val normalized = number.trim()
        if (normalized.isEmpty()) return

        val current = getPreferences(context).getStringSet("blocked_numbers", emptySet())
            ?.toMutableSet() ?: mutableSetOf()
        current.add(normalized)
        getPreferences(context).edit().putStringSet("blocked_numbers", current).apply()
    }

    fun isBlockedNumber(context: Context, number: String): Boolean {
        val normalized = number.trim()
        if (normalized.isEmpty()) return false

        val current = getPreferences(context).getStringSet("blocked_numbers", emptySet())
            ?: emptySet()
        return current.contains(normalized)
    }

    fun getCachedEngine(): FlutterEngine? {
        return FlutterEngineCache.getInstance().get(FLUTTER_ENGINE_CACHE_KEY)
    }
}
