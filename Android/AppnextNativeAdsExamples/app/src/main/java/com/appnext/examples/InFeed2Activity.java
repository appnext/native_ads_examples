package com.appnext.examples;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import com.appnext.appnextsdk.API.AppnextAPI;
import com.appnext.appnextsdk.API.AppnextAd;
import com.appnext.appnextsdk.API.AppnextAdRequest;

import java.io.InputStream;
import java.util.ArrayList;

public class InFeed2Activity extends Activity {
	
	AppnextAPI appnextAPI;
	AppnextAd ad;
	MediaPlayer mediaPlayer;
	
	ImageView icon;
	ImageView main_image;
	TextView title;
	TextView description;
	TextView rating;
	Button install;
	ImageView privacy;
	ImageView mute;
	VideoView videoView;
	
	ProgressDialog progressDialog;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.infeed2_activity);
		
		progressDialog = new ProgressDialog(this);
		progressDialog.setCancelable(false);
		progressDialog.setMessage("Loading");
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setProgress(0);
		progressDialog.show();
		
		icon = (ImageView) findViewById(R.id.icon);
		main_image = (ImageView) findViewById(R.id.main_image);
		privacy = (ImageView) findViewById(R.id.privacy);
		mute = (ImageView) findViewById(R.id.mute);
		title = (TextView) findViewById(R.id.title);
		description = (TextView) findViewById(R.id.description);
		rating = (TextView) findViewById(R.id.rating);
		install = (Button) findViewById(R.id.install);
		videoView = (VideoView) findViewById(R.id.video_view);

		// Make sure to use your own Placement ID as created in www.appnext.com
		appnextAPI = new AppnextAPI(this, "680274a5-1b9b-4805-91a6-05cea85f66f9");
		appnextAPI.setAdListener(new AppnextAPI.AppnextAdListener() {
			@Override
			public void onAdsLoaded(ArrayList<AppnextAd> arrayList) {
				ad = arrayList.get(0);
				
				findViewById(R.id.banner_view).setVisibility(View.VISIBLE);
				new DownloadImageTask(icon).execute(ad.getImageURL());
				new DownloadImageTask(main_image).execute(ad.getWideImageURL());
				title.setText(ad.getAdTitle());
				description.setText(ad.getAdDescription());
				rating.setText(ad.getStoreRating());
				install.setText(ad.getButtonText());
				install.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						appnextAPI.adClicked(ad);
					}
				});
				privacy.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						appnextAPI.privacyClicked(ad);
					}
				});
				mute.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						if(mediaPlayer!=null){
							mediaPlayer.setVolume(1, 1);
							mute.setVisibility(View.GONE);
						}
					}
				});
				
				if(hasVideo(ad)) {
					videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
						@Override
						public void onPrepared(MediaPlayer mp) {
							videoView.setVisibility(View.VISIBLE);
							if (mp != null) {
								mediaPlayer = mp;
								mp.setVolume(0, 0);
								mp.start();
								appnextAPI.videoStarted(ad);
							}
						}
					});
					videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
						@Override
						public void onCompletion(MediaPlayer mp) {
							appnextAPI.videoEnded(ad);
						}
					});
					videoView.setOnErrorListener(new MediaPlayer.OnErrorListener() {
						@Override
						public boolean onError(MediaPlayer mp, int what, int extra) {
							videoView.setVisibility(View.GONE);
							mute.setVisibility(View.GONE);
							return true;
						}
					});
					
					videoView.setVideoURI(Uri.parse(getVideo(ad)));
				} else {
					videoView.setVisibility(View.GONE);
					mute.setVisibility(View.GONE);
				}
				
				appnextAPI.adImpression(ad);
			}
			
			@Override
			public void onError(String s) {
				Toast.makeText(InFeed2Activity.this, s, Toast.LENGTH_SHORT).show();
				
				progressDialog.dismiss();
			}
		});
		appnextAPI.loadAds(new AppnextAdRequest().setCount(1));
	}
	
	private boolean hasVideo(AppnextAd ad) {
		return !ad.getVideoUrlHigh30Sec().equals("") || !ad.getVideoUrlHigh().equals("") || !ad.getVideoUrl().equals("") || ad.getVideoUrl30Sec().equals("");
	}
	
	private String getVideo(AppnextAd ad){
		if(!ad.getVideoUrl().equals("")){
			return ad.getVideoUrl();
		} else if(!ad.getVideoUrl30Sec().equals("")){
			return ad.getVideoUrl30Sec();
		} else if(!ad.getVideoUrlHigh().equals("")){
			return ad.getVideoUrlHigh();
		} else return ad.getVideoUrlHigh30Sec();
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
			progressDialog.dismiss();
		}
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		progressDialog.dismiss();
	}
}
