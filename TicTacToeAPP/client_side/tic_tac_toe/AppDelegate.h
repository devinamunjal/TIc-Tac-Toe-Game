//
//  AppDelegate.h
//  tic_tac_toe
//
//  Created by Devina Munjal on 12/28/23.
//

// AppDelegate.h
#import <UIKit/UIKit.h>
#import "TicTacToeClient.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TicTacToeClient *ticTacToeClient;

@end
