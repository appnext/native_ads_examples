package com.appnext.examples;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.appnext.appnextsdk.API.AppnextAd;

import java.text.NumberFormat;
import java.text.ParseException;

public class AdFragment extends Fragment {

	private static final String AD_PARAM_STRING = "ad";
	private static final String ITEM_PARAM_INT = "item";

	private IAppnextAds callback;

	public AdFragment() {
	}

	public static AdFragment newInstance(int position, AppnextAd ad) {
		AdFragment fragment = new AdFragment();
		Bundle args = new Bundle();
		args.putSerializable(AD_PARAM_STRING, ad);
		fragment.setArguments(args);
		return fragment;
	}

	@Override
	public void onAttach(Context context) {
		super.onAttach(context);

		if(context instanceof IAppnextAds){
			callback = (IAppnextAds) context;
		}
	}

	@Override
	public void onDetach() {
		super.onDetach();

		callback = null;
	}

	@SuppressLint("SetTextI18n")
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.carousel_item, container, false);
		final AppnextAd ad = ((AppnextAd)getArguments().getSerializable(AD_PARAM_STRING));
		if(ad==null)
			return rootView;
		ImageView imageView = (ImageView) rootView.findViewById(R.id.cover_image);
		new ImageDownloader(imageView, new LoadingCallback() {
			@Override
			public void loaded() {
				
			}
		}).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, ad.getWideImageURL());

		new ImageDownloader((ImageView) rootView.findViewById(R.id.icon), new LoadingCallback() {
			@Override
			public void loaded() {
				
			}
		}).execute(ad.getImageURL());
		((TextView)rootView.findViewById(R.id.title)).setText(ad.getAdTitle());
		((TextView)rootView.findViewById(R.id.rating)).setText(ad.getStoreRating() + " ");
		try {
			int num = NumberFormat.getInstance().parse(ad.getStoreDownloads()).intValue();
			if (num > 1000000) {
				((TextView)rootView.findViewById(R.id.downloads)).setText((num / 1000000) + "M downloads");
			} else {
				if (num > 1000) {
					((TextView)rootView.findViewById(R.id.downloads)).setText((num / 1000) + "K downloads");
				} else {
					((TextView)rootView.findViewById(R.id.downloads)).setText(num + " downloads");
				}
			}
		} catch (ParseException e) {
			((TextView)rootView.findViewById(R.id.downloads)).setText(ad.getStoreDownloads() + " downloads");
		}
		((Button)rootView.findViewById(R.id.install)).setText(ad.getButtonText());
		rootView.findViewById(R.id.click).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(callback!=null)
					callback.adClicked(ad);
			}
		});

		rootView.findViewById(R.id.privacy).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(callback!=null)
					callback.privacyClicked(ad);
			}
		});

		if(callback!=null)
			callback.adImpression(ad);

		rootView.setTag(ITEM_PARAM_INT + getArguments().getInt(ITEM_PARAM_INT));

		return rootView;
	}
}
