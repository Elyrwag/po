package com.example.shoppingapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.example.shoppingapp.data.database.RealmDb
import com.example.shoppingapp.ui.theme.ShoppingAppTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        RealmDb.init()

        setContent {
            ShoppingAppTheme {
                Surface(modifier = Modifier) {
                    AppContent(RealmDb.realm)
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        RealmDb.close()
    }
}