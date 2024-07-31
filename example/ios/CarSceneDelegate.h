#import <CarPlay/CarPlay.h>

@interface CarSceneDelegate : UIResponder <CPTemplateApplicationSceneDelegate>

@property (nonatomic, strong) CPInterfaceController *interfaceController;
@property (nonatomic, strong) CPWindow *carWindow;

@end
