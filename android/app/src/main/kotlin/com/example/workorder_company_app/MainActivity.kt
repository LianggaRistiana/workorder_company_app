package com.example.workorder_company_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel =
                    NotificationChannel(
                                    "high_importance_channel",
                                    "High Importance Notifications",
                                    NotificationManager.IMPORTANCE_HIGH
                            )
                            .apply { description = "Workorder important notifications" }

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
// bring back this if someting wrong
// package com.example.workorder_company_app

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity()
