#import <UIKit/UIKit.h>
#import <React/RCTRootView.h>
#import "AppDelegate.h"
#import "PhoneSceneDelegate.h"

@implementation PhoneSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  if (!appDelegate) {
    return;
  }

  UIWindowScene *windowScene = (UIWindowScene *)scene;
  if (!windowScene) {
    return;
  }

  UIViewController *rootViewController = [[UIViewController alloc] init];
  rootViewController.view = appDelegate.rootView;

  UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
  window.rootViewController = rootViewController;
  self.window = window;
  [window makeKeyAndVisible];
}

@end
