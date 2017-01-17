package com.appnext.appnextcarousel;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.appnext.appnextsdk.API.AppnextAd;

import java.util.ArrayList;

public class SectionsPagerAdapter extends FragmentPagerAdapter {

	private ArrayList<AppnextAd> ads;

	public SectionsPagerAdapter(FragmentManager fm, ArrayList<AppnextAd> arrayList) {
		super(fm);

		ads = arrayList;
	}

	@Override
	public Fragment getItem(int position) {
		return AdFragment.newInstance(position, ads.get(position));
	}

	@Override
	public int getCount() {
		return ads.size();
	}

	@Override
	public CharSequence getPageTitle(int position) {
		return ads.get(position).getAdTitle();
	}
}
