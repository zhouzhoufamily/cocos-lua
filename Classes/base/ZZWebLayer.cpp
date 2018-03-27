#include "ZZWebLayer.h"

ZZWebLayer::ZZWebLayer()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	_webView = nullptr;
#endif
}

ZZWebLayer::~ZZWebLayer()
{
}

bool ZZWebLayer::init()
{
	if (Layer::init())
	{
		return true;
	}

	return false;
}

ZZWebLayer * ZZWebLayer::create()
{
	ZZWebLayer * layer = new (std::nothrow) ZZWebLayer();
	if (layer && layer->init())
	{
		layer->autorelease();
		
		auto visibleSize = Director::getInstance()->getVisibleSize();
		layer->setContentSize(visibleSize);

		return layer;
	}
	CC_SAFE_DELETE(layer);
	return nullptr;
}

void ZZWebLayer::loadURL(const std::string & url)
{
}

void ZZWebLayer::reloadURL(const std::string & url)
{
}

void ZZWebLayer::goBack()
{
}

void ZZWebLayer::goForward()
{
}

void ZZWebLayer::setScalesPageToFit(const bool scalesPageToFit)
{
}

void ZZWebLayer::setBounces(bool bounce)
{
}

void ZZWebLayer::setBackgroundTransparent()
{
}

void ZZWebLayer::onEnter()
{
}

void ZZWebLayer::onExit()
{
}

