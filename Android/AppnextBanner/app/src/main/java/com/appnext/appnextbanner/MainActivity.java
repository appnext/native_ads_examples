package com.appnext.appnextbanner;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.appnext.appnextsdk.API.AppnextAPI;
import com.appnext.appnextsdk.API.AppnextAd;
import com.appnext.appnextsdk.API.AppnextAdRequest;

import java.io.InputStream;
import java.util.ArrayList;

public class MainActivity extends Activity {

	AppnextAPI appnextAPI;
	AppnextAd ad;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		appnextAPI = new AppnextAPI(this, "e04e7c03-cda3-487f-ae1e-41ab1ffb8477");
		appnextAPI.setAdListener(new AppnextAPI.AppnextAdListener() {
			@Override
			public void onAdsLoaded(ArrayList<AppnextAd> arrayList) {
				ad = arrayList.get(0);

				findViewById(R.id.banner_view).setVisibility(View.VISIBLE);
				new DownloadImageTask((ImageView) findViewById(R.id.icon)).execute(ad.getImageURL());
				((TextView)findViewById(R.id.title)).setText(ad.getAdTitle());
				((TextView)findViewById(R.id.rating)).setText(ad.getStoreRating());
				findViewById(R.id.install).setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						appnextAPI.adClicked(ad);
					}
				});

				appnextAPI.adImpression(ad);
			}

			@Override
			public void onError(String s) {
				((TextView)findViewById(R.id.error)).setText("Error: " + s);
				findViewById(R.id.error).setVisibility(View.VISIBLE);
			}
		});
		appnextAPI.loadAds(new AppnextAdRequest().setCount(1));
	}

	private class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
		ImageView bmImage;

		public DownloadImageTask(ImageView bmImage) {
			this.bmImage = bmImage;
		}

		protected Bitmap doInBackground(String... urls) {
			String urldisplay = urls[0];
			Bitmap mIcon11 = null;
			try {
				InputStream in = new java.net.URL(urldisplay).openStream();
				mIcon11 = BitmapFactory.decodeStream(in);
			} catch (Exception e) {
				Log.e("Error", e.getMessage());
				e.printStackTrace();
			}
			return mIcon11;
		}

		protected void onPostExecute(Bitmap result) {
			bmImage.setImageBitmap(result);
		}
	}
}
