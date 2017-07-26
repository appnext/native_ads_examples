package com.appnext.examples;

import android.app.ProgressDialog;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.Toast;
import android.widget.VideoView;

import com.appnext.appnextsdk.API.AppnextAPI;
import com.appnext.appnextsdk.API.AppnextAd;
import com.appnext.appnextsdk.API.AppnextAdRequest;
import com.tobishiba.circularviewpager.library.CircularViewPagerHandler;

import java.util.ArrayList;

public class CarouselActivity extends AppCompatActivity implements IAppnextAds {
	
	private int ADS_COUNT = 6;
	
	private SectionsPagerAdapter mSectionsPagerAdapter;
	
	private ViewPager mViewPager;
	MediaPlayer mediaPlayer;
	
	VideoView videoView;
	AppnextAPI appnextAPI;
	ArrayList<AppnextAd> adsList;
	boolean mute = true;
	int currentPosition;
	ArrayList<Boolean> impressionList;
	
	ProgressDialog progressDialog;
	
	@Override
	protected void onCreate(@Nullable Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.carousel_activity);
		
		progressDialog = new ProgressDialog(this);
		progressDialog.setCancelable(false);
		progressDialog.setMessage("Loading");
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setProgress(0);
		progressDialog.show();
		
		impressionList = new ArrayList<>();
		
		videoView = new VideoView(this);
		videoView.setLayoutParams(new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT));
		videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
			@Override
			public void onPrepared(MediaPlayer mp) {
				if(mp!=null) {
					mediaPlayer = mp;
					if(mute)
						mp.setVolume(0, 0);
					mp.start();
					AppnextAd appnextAd = adsList.get((adsList.size() + currentPosition) % adsList.size());
					appnextAPI.videoStarted(appnextAd);
				}
			}
		});
		videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
			@Override
			public void onCompletion(MediaPlayer mp) {
				AppnextAd appnextAd = adsList.get((adsList.size() + currentPosition) % adsList.size());
				appnextAPI.videoEnded(appnextAd);
			}
		});
		// Make sure to use your own Placement ID as created in www.appnext.com
		appnextAPI = new AppnextAPI(this, "a6d27be0-d323-4e5e-94e6-ae2d7a9f96cc");
		appnextAPI.setAdListener(new AppnextAPI.AppnextAdListener() {
			@Override
			public void onAdsLoaded(ArrayList<AppnextAd> arrayList) {
				adsList = arrayList;
				for(int i = 0; i<adsList.size(); ++i){
					impressionList.add(Boolean.FALSE);
				}
				
				mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager(), arrayList);
				
				// Set up the ViewPager with the sections adapter.
				mViewPager = (ViewPager) findViewById(R.id.container);
				mViewPager.setAdapter(mSectionsPagerAdapter);
				mViewPager.setClipToPadding(false);
				int padding = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 15, getResources().getDisplayMetrics());
				mViewPager.setPadding(padding, 0, padding, 0);
				int margin = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 5, getResources().getDisplayMetrics());
				mViewPager.setPageMargin(margin);
				
				CircularViewPagerHandler listener = new CircularViewPagerHandler(mViewPager);
				mViewPager.addOnPageChangeListener(listener);
				listener.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
					@Override
					public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
						
					}
					
					@Override
					public void onPageSelected(int position) {
						currentPosition = position;
						if(videoView.getParent()!=null)
							((ViewGroup)videoView.getParent()).removeView(videoView);
						
						final ViewGroup view = (ViewGroup) mViewPager.findViewWithTag("item"+(position+1));
						((RelativeLayout)view.findViewById(R.id.video_container)).addView(videoView);
						videoView.setVideoURI(Uri.parse(getVideo(adsList.get((adsList.size() + position)%adsList.size()))));
						
						initView(view);
					}
					
					@Override
					public void onPageScrollStateChanged(int state) {
						
					}
				});
				
				View item;
				if(arrayList.size()==1) {
					item = mViewPager.findViewWithTag("item0");
					((RelativeLayout) item.findViewById(R.id.video_container)).addView(videoView);
				} else {
					item = mViewPager.findViewWithTag("item1");
					((RelativeLayout) item.findViewById(R.id.video_container)).addView(videoView);
				}
				initView(item);
				videoView.setVideoURI(Uri.parse(getVideo(adsList.get(0))));
				
				progressDialog.dismiss();
			}
			
			@Override
			public void onError(String s) {
				Toast.makeText(CarouselActivity.this, "error:" + s, Toast.LENGTH_SHORT).show();
				
				progressDialog.dismiss();
			}
		});
		appnextAPI.setCreativeType(AppnextAPI.TYPE_MANAGED);
		// In this example we're using the setCount function as part of the Carousel example implemention.
		// If you want to load more ads, don't use the setCount function or set it to higher value: setCount(x)
		appnextAPI.loadAds(new AppnextAdRequest().setCount(ADS_COUNT));
	}
	
	private void initView(final View view){
		
		if(mute){
			view.findViewById(R.id.unmute).setVisibility(View.VISIBLE);
			view.findViewById(R.id.unmute).setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					mute = false;
					if(mediaPlayer!=null)
						mediaPlayer.setVolume(1, 1);
					view.findViewById(R.id.unmute).setVisibility(View.GONE);
				}
			});
		} else {
			view.findViewById(R.id.unmute).setVisibility(View.GONE);
		}
		
		view.findViewById(R.id.controller).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(mediaPlayer!=null){
					if(mediaPlayer.isPlaying())
						mediaPlayer.pause();
					else
						mediaPlayer.start();
				}
			}
		});
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
	
	@Override
	public void adImpression(AppnextAd ad) {
		if(appnextAPI!=null && !impressionList.get((adsList.size() + currentPosition)%adsList.size())) {
			appnextAPI.adImpression(ad);
			impressionList.set((adsList.size() + currentPosition)%adsList.size(), Boolean.TRUE);
		}
	}
	
	@Override
	public void adClicked(AppnextAd ad) {
		if(appnextAPI!=null)
			appnextAPI.adClicked(ad);
	}
	
	@Override
	public void privacyClicked(AppnextAd ad) {
		if(appnextAPI!=null)
			appnextAPI.privacyClicked(ad);
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		progressDialog.dismiss();
	}
}
