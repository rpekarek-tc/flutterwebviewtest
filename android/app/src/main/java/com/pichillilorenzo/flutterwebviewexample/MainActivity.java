package com.pichillilorenzo.flutterwebviewexample;

import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.graphics.Color;
import androidx.core.view.WindowCompat;
import androidx.activity.EdgeToEdge;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.platform.PlatformPlugin;

public class MainActivity extends FlutterFragmentActivity {

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        EdgeToEdge.enable(this);
        super.onCreate(savedInstanceState);

        Window window = getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.setStatusBarColor(Color.GRAY);
        window.getDecorView().setSystemUiVisibility(PlatformPlugin.DEFAULT_SYSTEM_UI);

        View view = findViewById(android.R.id.content).getRootView();
        view.setFilterTouchesWhenObscured(true);
    }
}