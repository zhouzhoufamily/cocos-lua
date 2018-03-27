//#pragma once

/*
* web网页是在网页部分自适配的，分电脑和移动端两个部分，可能是调用了相应的布局库or方法。
* 所以在这创建的web内容层，定义为移动端的全屏（cocos引擎并未接入webview）。
*/

#ifndef _WEB_LAYER_H
#define _WEB_LAYER_H

#include "cocos\ui\CocosGUI.h"

#include "cocos2d.h"

USING_NS_CC;

class ZZWebLayer : public Layer
{
public:
	/**
	* Allocates and initializes a ZZWebLayer.
	*
	* @param url Content URL.
	* @return a pointer of ZZWebLayer.
	*/
	static ZZWebLayer *create();

	/**
	* Loads the given URL. It doesn't clean cached data.
	*
	* @param url Content URL.
	*/
	void loadURL(const std::string &url);

	/**
	* Loads the given URL. It doesn't clean cached data.
	*
	* @param url Content URL.
	*/
	void reloadURL(const std::string &url);

	/**
	* Goes back in the history.
	*/
	void goBack();

	/**
	* Goes forward in the history.
	*/
	void goForward();

	/**
	* Set WebView should support zooming. The default value is false.
	*/
	void setScalesPageToFit(const bool scalesPageToFit);

	/**
	* Set whether the webview bounces at end of scroll of WebView.
	*/
	void setBounces(bool bounce);

	/**
	* set the background transparent
	*/
	virtual void setBackgroundTransparent();
	virtual void onEnter() override;
	virtual void onExit() override;

protected:
	ZZWebLayer();
	virtual ~ZZWebLayer();

	bool init() override;

private:

};


#endif // !_WEB_LAYER_H
