#import <Foundation/Foundation.h>
#import <CarPlay/CarPlay.h>
#import "CarSceneDelegate.h"
#import "RNCarPlay.h"

@implementation CarSceneDelegate

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController toWindow:(CPWindow *)window {
  [RNCarPlay connectWithInterfaceController:interfaceController window:templateApplicationScene.carWindow];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene
didDisconnectInterfaceController:(CPInterfaceController *)interfaceController {
  // Dispatch disconnect to RNCarPlay
  [RNCarPlay disconnect];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didBecomeActive:(CPTemplateApplicationScene *)scene {
  // Handle becoming active if necessary
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene willResignActive:(CPTemplateApplicationScene *)scene {
  // Handle resigning active if necessary
}


@end


