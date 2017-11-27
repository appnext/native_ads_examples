package com.appnext.appnextnativeadsexamples;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appnext.base.Appnext;
import com.appnext.core.AppnextError;
import com.appnext.nativeads.MediaView;
import com.appnext.nativeads.NativeAd;
import com.appnext.nativeads.NativeAdListener;
import com.appnext.nativeads.NativeAdRequest;
import com.appnext.nativeads.NativeAdView;
import com.appnext.nativeads.PrivacyIcon;

import java.util.ArrayList;

public class InFeedExample2 extends AppCompatActivity {

    private NativeAd nativeAd;
    private NativeAdView nativeAdView;
    private ImageView imageView;
    private TextView textView, rating, description;
    private MediaView mediaView;
    private ProgressBar progressBar;
    private Button button;
    private ArrayList<View> viewArrayList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_in_feed_example2);

        Appnext.init(this);
        setViews();

        // Don't forget to change the placement ID to your own ID        
        nativeAd = new NativeAd(this, "5d32ae77-1949-4322-808e-c08705deec84");
        nativeAd.setPrivacyPolicyColor(PrivacyIcon.PP_ICON_COLOR_DARK);
        nativeAd.setPrivacyPolicyPosition(PrivacyIcon.PP_ICON_POSITION_BOTTOM_LEFT);
        nativeAd.setAdListener(new NativeAdListener() {
            @Override
            public void onAdLoaded(final NativeAd nativeAd) {
                super.onAdLoaded(nativeAd);
                progressBar.setVisibility(View.GONE);
                nativeAd.downloadAndDisplayImage(imageView, nativeAd.getIconURL());
                textView.setText(nativeAd.getAdTitle());
                nativeAd.setMediaView(mediaView);
                rating.setText(nativeAd.getStoreRating());
                description.setText(nativeAd.getAdDescription());
                nativeAd.registerClickableViews(viewArrayList);
                nativeAd.setNativeAdView(nativeAdView);
            }

            @Override
            public void onAdClicked(NativeAd nativeAd) {
                super.onAdClicked(nativeAd);
            }

            @Override
            public void onError(NativeAd nativeAd, AppnextError appnextError) {
                super.onError(nativeAd, appnextError);
                Toast.makeText(getApplicationContext(), "Error loading ads", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void adImpression(NativeAd nativeAd) {
                super.adImpression(nativeAd);
            }
        });

        nativeAd.loadAd(new NativeAdRequest()
                // optional - config your ad request:
                .setCachingPolicy(NativeAdRequest.CachingPolicy.STATIC_ONLY)
                .setCreativeType(NativeAdRequest.CreativeType.ALL)
                .setVideoLength(NativeAdRequest.VideoLength.SHORT)
                .setVideoQuality(NativeAdRequest.VideoQuality.LOW));
    }

    private void setViews() {
        nativeAdView = (NativeAdView) findViewById(R.id.na_view);
        imageView = (ImageView) findViewById(R.id.na_icon);
        textView = (TextView) findViewById(R.id.na_title);
        mediaView = (MediaView) findViewById(R.id.na_media);
        progressBar = (ProgressBar) findViewById(R.id.progressBar);
        button = (Button) findViewById(R.id.install);
        rating = (TextView) findViewById(R.id.rating);
        description = (TextView) findViewById(R.id.description);
        viewArrayList = new ArrayList<>();
        viewArrayList.add(button);
        viewArrayList.add(mediaView);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        nativeAd.destroy();
    }
}
