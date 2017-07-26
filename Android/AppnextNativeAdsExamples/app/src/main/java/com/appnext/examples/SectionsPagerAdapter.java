package com.appnext.examples;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;

import com.appnext.appnextsdk.API.AppnextAd;
import com.tobishiba.circularviewpager.library.BaseCircularViewPagerAdapter;

import java.util.ArrayList;

public class SectionsPagerAdapter extends BaseCircularViewPagerAdapter<AppnextAd> {

	private ArrayList<AppnextAd> ads;

	public SectionsPagerAdapter(FragmentManager fm, ArrayList<AppnextAd> arrayList) {
		super(fm, arrayList);

		ads = arrayList;
	}

	@Override
	protected Fragment getFragmentForItem(AppnextAd appnextAd) {
		return AdFragment.newInstance(0, appnextAd);
	}

	@Override
	public Fragment getItem(int position) {
		Fragment fragment = super.getItem(position);
		if(fragment!=null) {
			Bundle bundle = fragment.getArguments();
			if(bundle==null)
				bundle = new Bundle();
			bundle.putInt("item", position);
			fragment.setArguments(bundle);
		}

		return fragment;
	}

//	@Override
//	public int getCount() {
//		return ads.size();
//	}

	@Override
	public CharSequence getPageTitle(int position) {
		return ads.get(position).getAdTitle();
	}
}
