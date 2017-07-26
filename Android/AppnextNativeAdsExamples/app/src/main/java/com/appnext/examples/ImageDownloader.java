package com.appnext.examples;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.ImageView;

import java.io.InputStream;
import java.util.HashMap;

public class ImageDownloader extends AsyncTask<String, Void, Bitmap> {

	private static HashMap<String, Bitmap> images;

	static {
		images = new HashMap<>();
	}

	ImageView bmImage;
	LoadingCallback callback;

	public ImageDownloader(ImageView bmImage, LoadingCallback callback) {
		this.bmImage = bmImage;
		this.callback = callback;
	}

	protected Bitmap doInBackground(String... urls) {
		String urldisplay = urls[0];
		if(images.containsKey(urldisplay))
			return images.get(urldisplay);
		Bitmap mIcon11 = null;
		try {
			InputStream in = new java.net.URL(urldisplay).openStream();
			mIcon11 = BitmapFactory.decodeStream(in);
			images.put(urldisplay, mIcon11);
		} catch (Exception e) {
			Log.e("Error", e.getMessage());
			e.printStackTrace();
		}
		return mIcon11;
	}

	protected void onPostExecute(Bitmap result) {
		bmImage.setImageBitmap(result);
		callback.loaded();
	}
}

