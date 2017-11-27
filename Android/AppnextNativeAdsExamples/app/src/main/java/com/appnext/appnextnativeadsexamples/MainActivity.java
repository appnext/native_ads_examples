package com.appnext.appnextnativeadsexamples;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import com.appnext.base.Appnext;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Appnext.init(this);
        setVies();
    }

    private void setVies() {
        Button inFeedButtonButton1 = findViewById(R.id.in_feed_1_button);
        inFeedButtonButton1.setOnClickListener(this);

        Button inFeedButtonButton2 = findViewById(R.id.in_feed_2_button);
        inFeedButtonButton2.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        Intent intent = null;
        switch (view.getId()) {
            case R.id.in_feed_1_button:
                intent = new Intent(this, InFeedExample1.class);
                break;
            case R.id.in_feed_2_button:
                intent = new Intent(this, InFeedExample2.class);
                break;
        }
        startActivity(intent);
    }
}
