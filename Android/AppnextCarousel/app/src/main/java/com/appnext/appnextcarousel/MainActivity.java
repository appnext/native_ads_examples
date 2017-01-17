package com.appnext.appnextcarousel;

import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.util.TypedValue;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.Toast;
import android.widget.VideoView;

import com.appnext.appnextsdk.API.AppnextAPI;
import com.appnext.appnextsdk.API.AppnextAd;
import com.appnext.appnextsdk.API.AppnextAdRequest;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements IAppnextAds {

	private SectionsPagerAdapter mSectionsPagerAdapter;

	private ViewPager mViewPager;

	VideoView videoView;
	AppnextAPI appnextAPI;
	ArrayList<AppnextAd> adsList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		videoView = new VideoView(this);
		videoView.setLayoutParams(new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT));
		videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
			@Override
			public void onPrepared(MediaPlayer mp) {
				mp.start();
			}
		});

		appnextAPI = new AppnextAPI(this, "e04e7c03-cda3-487f-ae1e-41ab1ffb8477");
		appnextAPI.setAdListener(new AppnextAPI.AppnextAdListener() {
			@Override
			public void onAdsLoaded(ArrayList<AppnextAd> arrayList) {
				adsList = arrayList;

				mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager(), arrayList);

				// Set up the ViewPager with the sections adapter.
				mViewPager = (ViewPager) findViewById(R.id.container);
				mViewPager.setAdapter(mSectionsPagerAdapter);
				mViewPager.setClipToPadding(false);
				int padding = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 15, getResources().getDisplayMetrics());
				mViewPager.setPadding(padding, 0, padding, 0);
				int margin = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 5, getResources().getDisplayMetrics());
				mViewPager.setPageMargin(margin);

				mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
					@Override
					public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

					}

					@Override
					public void onPageSelected(int position) {
						if(videoView.getParent()!=null)
							((ViewGroup)videoView.getParent()).removeView(videoView);

						((RelativeLayout)mViewPager.findViewWithTag("item"+position).findViewById(R.id.video_container)).addView(videoView);
						videoView.setVideoURI(Uri.parse(getVideo(adsList.get(position))));
					}

					@Override
					public void onPageScrollStateChanged(int state) {

					}
				});

				((RelativeLayout)mViewPager.findViewWithTag("item0").findViewById(R.id.video_container)).addView(videoView);
				videoView.setVideoURI(Uri.parse(getVideo(adsList.get(0))));
			}

			@Override
			public void onError(String s) {
				Toast.makeText(MainActivity.this, "error:" + s, Toast.LENGTH_SHORT).show();
			}
		});
		appnextAPI.setCreativeType(AppnextAPI.TYPE_VIDEO);
		appnextAPI.loadAds(new AppnextAdRequest().setCount(6));
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
		if(appnextAPI!=null)
			appnextAPI.adImpression(ad);
	}

	@Override
	public void adClicked(AppnextAd ad) {
		if(appnextAPI!=null)
			appnextAPI.adClicked(ad);
	}

}
