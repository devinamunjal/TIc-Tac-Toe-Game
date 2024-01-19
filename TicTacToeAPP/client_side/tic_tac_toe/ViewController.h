//
//  ViewController.h
//  tic_tac_toe
//
//  Created by Devina Munjal on 12/28/23.
//

#import <UIKit/UIKit.h>
#import "TicTacToeClient.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) TicTacToeClient *ticTacToeClient;



@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UIButton *playAgain;
@property (weak, nonatomic) IBOutlet UIButton *winner;
- (IBAction)playAgainClick:(id)sender;
- (void)updateBoardUIWithState:(NSString *)boardState;
- (IBAction)button1click:(id)sender;

- (IBAction)button2click:(id)sender;
- (IBAction)winnerDisplay:(id)sender;

@end

