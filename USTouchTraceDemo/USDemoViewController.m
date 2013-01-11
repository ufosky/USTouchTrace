//
//  USDemoViewController.m
//  USTouchTrace
//
//  Created by Qihe Bian on 1/11/13.
//  Copyright (c) 2013 Qihe Bian. All rights reserved.
//

#import "USDemoViewController.h"

enum ViewTag {
  ViewTagTextField = 100,
  ViewTagTextView
};

@interface USDemoViewController ()

@end

@implementation USDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  UITextField *textField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 8, 300, 30)] autorelease];
  [textField setTag:ViewTagTextField];
  [textField setBorderStyle:UITextBorderStyleRoundedRect];
  [textField setPlaceholder:@"Touch here for keyboard."];
  [[self view] addSubview:textField];
  
  UITextView *textView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 46, 320, [[self view] frame].size.height - 46)] autorelease];
  [textView setTag:ViewTagTextView];
  [textView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
  [textView setEditable:NO];
  [[self view] addSubview:textView];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder:)];
  [textView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignResponder:(id)sender{
  UITextField *textField = (UITextField *)[[self view] viewWithTag:ViewTagTextField];
  [textField resignFirstResponder];
}
@end
