//
//  main.m
//  tic_tac_toe
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TicTacToeClient.h"
#import "ViewController.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
        // Initialize TicTacToeClient with server details
//        TicTacToeClient *ticTacToeClient = [[TicTacToeClient alloc] initWithServerIP:@"127.0.0.1" port:12347];
//
//        // Connect to the server
//        [ticTacToeClient connectToServer];
//
//        // Set up your initial view controller
//        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        
//        ViewController *viewController = [[ViewController alloc] init];
//        viewController.ticTacToeClient = ticTacToeClient; // Pass the client to the view controller
//        window.rootViewController = viewController;
//        
//        [window makeKeyAndVisible];
        
        return UIApplicationMain(argc, argv, nil, appDelegateClassName);
    }
}
