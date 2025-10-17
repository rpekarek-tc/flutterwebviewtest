package com.pichillilorenzo.flutterwebviewexample;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
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

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        if (!hasFocus) {
            hideAppContent();
        } else {
            showAppContent();
        }
        super.onWindowFocusChanged(hasFocus);
    }

    private void hideAppContent() {
        RelativeLayout secureView = findViewById(R.id.secureView);

        if (secureView == null) {
            FrameLayout parentView = findViewById(FRAGMENT_CONTAINER_ID);
            LayoutInflater inflater = getLayoutInflater();
            View splashScreen = inflater.inflate(R.layout.secure_view, null);
            parentView.addView(
                    splashScreen,
                    parentView.getWidth(),
                    parentView.getHeight()
            );
        }
    }

    private void showAppContent() {
        FrameLayout parentView = findViewById(FRAGMENT_CONTAINER_ID);
        RelativeLayout secureView = findViewById(R.id.secureView);
        parentView.removeView(secureView);
    }

}