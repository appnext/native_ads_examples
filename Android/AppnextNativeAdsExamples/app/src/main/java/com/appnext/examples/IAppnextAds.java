package com.appnext.examples;

import com.appnext.appnextsdk.API.AppnextAd;

public interface IAppnextAds{
	void adImpression(AppnextAd ad);
	void adClicked(AppnextAd ad);
	void privacyClicked(AppnextAd ad);
}
