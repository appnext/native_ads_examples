package com.appnext.examples;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.appnext.appnextsdk.API.AppnextAPI;
import com.appnext.appnextsdk.API.AppnextAd;
import com.appnext.appnextsdk.API.AppnextAdRequest;

import java.util.ArrayList;

public class BannerActivity extends Activity {
	
	AppnextAPI bannerAppnextAPI;
	AppnextAd banner_ad;
	ProgressDialog progressDialog;
	
	@Override
	protected void onCreate(@Nullable Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.banner_activity);
		
		progressDialog = new ProgressDialog(this);
		progressDialog.setCancelable(false);
		progressDialog.setMessage("Loading");
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setProgress(0);
		progressDialog.show();

		// Make sure to use your own Placement ID as created in www.appnext.com
		bannerAppnextAPI = new AppnextAPI(this, "b9842feb-d1c5-49c0-8fe3-dd7db1090104");
		bannerAppnextAPI.setAdListener(new AppnextAPI.AppnextAdListener() {
			@Override
			public void onAdsLoaded(ArrayList<AppnextAd> arrayList) {
				banner_ad = arrayList.get(0);
				
				new ImageDownloader((ImageView) findViewById(R.id.banner_icon), new LoadingCallback() {
					@Override
					public void loaded() {
						progressDialog.dismiss();
						findViewById(R.id.banner_view).setVisibility(View.VISIBLE);
					}
				}).execute(banner_ad.getImageURL());
				((TextView)findViewById(R.id.banner_title)).setText(banner_ad.getAdTitle());
				((TextView)findViewById(R.id.banner_rating)).setText(banner_ad.getStoreRating());
				((Button)findViewById(R.id.banner_install)).setText(banner_ad.getButtonText());
				findViewById(R.id.banner_click).setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						bannerAppnextAPI.adClicked(banner_ad);
					}
				});
				findViewById(R.id.banner_privacy).setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						bannerAppnextAPI.privacyClicked(banner_ad);
					}
				});
				
				bannerAppnextAPI.adImpression(banner_ad);
			}
			
			@Override
			public void onError(String s) {
				((TextView)findViewById(R.id.banner_error)).setText("Error: " + s);
				findViewById(R.id.banner_error).setVisibility(View.VISIBLE);
				
				progressDialog.dismiss();
			}
		});
		// In this example we're loading only one ad for the banner using the setCount(1) function in the ad request
		// This is an optional usage. To load more ads either don't use the fucntion or call it with a different value: setCount(x)
		bannerAppnextAPI.loadAds(new AppnextAdRequest().setCount(1));
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		progressDialog.dismiss();
	}
}
