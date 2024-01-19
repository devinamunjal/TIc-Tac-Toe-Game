//
//  TicTacToeClient.h
//  tic_tac_toe
//
//  Created by Devina Munjal on 1/2/24.
//

#ifndef TicTacToeClient_h
#define TicTacToeClient_h

#import <UIKit/UIKit.h>

#endif /* TicTacToeClient_h */
#import <Foundation/Foundation.h>
@class ViewController;

@interface TicTacToeClient : NSObject
@property (nonatomic, strong) TicTacToeClient *ticTacToeClient;
@property (nonatomic, strong) TicTacToeClient *ticTacToeClient2;
@property (nonatomic, strong) ViewController *vcObj;


- (instancetype)initWithServerIP:(NSString *)serverIP port:(int)port;
- (void)connectToServer;
- (void)sendMove:(NSDictionary *)moveInfo;
- (void)closeConnection;
-(int)getSocket;
- (void)readAndUpdateBoard;
@end
