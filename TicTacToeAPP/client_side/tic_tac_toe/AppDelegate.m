//
//  AppDelegate.m
//  tic_tac_toe
//
//  Created by Devina Munjal on 12/28/23.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     //Override point for customization after application launch.
       self.ticTacToeClient = [[TicTacToeClient alloc] initWithServerIP:@"127.0.0.1" port:12348];
       [self.ticTacToeClient connectToServer];
       
       // Set up your initial view controller
      // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
       
       // Use your specific ViewController class here
       //ViewController *viewController = [[ViewController alloc] init];
       //viewController.ticTacToeClient = self.ticTacToeClient; // Pass the client to the view controller
       //self.window.rootViewController = viewController;
       
       //[self.window makeKeyAndVisible];
       
       return YES;
   }

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
