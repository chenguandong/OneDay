//
//  YYTextEditExample.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//
//pod 'YYText'
//pod 'YYCategories'
//pod 'YYKeyboardManager'
// [_self setExclusionPathEnabled:NO];
//

#import "HYWriteNoteNow.h"
#import <YYKit.h>
#import "Constant.h"
#import <BlocksKit+UIKit.h>
@interface HYWriteNoteNow () <YYTextViewDelegate, YYTextKeyboardObserver>
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISwitch *verticalSwitch;
@property (nonatomic, strong) UISwitch *exclusionSwitch;
@property(nonatomic,copy)NSMutableAttributedString *text;
@end

@implementation HYWriteNoteNow

#pragma mark - lifeVC
- (void)viewDidLoad {
    [super viewDidLoad];

  
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
    NSMutableAttributedString *text = nil;
    
    if (_lastNoteData) {
        text = [NSMutableAttributedString unarchiveFromData:_lastNoteData];
        
        NSLog(@"%@",text);
        
    }else{
        text = [[NSMutableAttributedString alloc] initWithString:@"It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us. We were all going direct to heaven, we were all going direct the other way.\n\n这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望之春，这是失望之冬；人们面前有着各样事物，人们面前一无所有；人们正在直登天堂，人们正在直下地狱。"];
        
        text.font = [UIFont fontWithName:@"Times New Roman" size:20];
        text.lineSpacing = 4;
        text.firstLineHeadIndent = 20;
       
    }
    
  
    
    self.text = text;
    
    YYTextView *textView = [YYTextView new];
    
    textView.attributedText = text;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    textView.allowsPasteImage = YES; /// Pasts image
    //textView.allowsPasteAttributedString = YES; /// Paste attributed string

    if (kiOS7Later) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    } else {
        textView.height -= 64;
    }
    textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    //textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    textView.bounces = YES;
    [self.view addSubview:textView];
     
    self.textView = textView;
    

    
     _textView.inputAccessoryView = [self bottomToolsBar];
    
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
   
   
    self.toolbarItems = [self toolsBarButtonItems];
    
  
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    _textView.bounces = YES;
    

}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}




- (NSArray<UIBarButtonItem*>*)toolsBarButtonItems{
    
    UIBarButtonItem *locationBarButton = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"toolsbar_location"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        NSLog(@"xxxxx");
        
    }];
    
    UIBarButtonItem *fixedSpaceBarButton = [[UIBarButtonItem alloc]bk_initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace handler:^(id sender) {
        
    }];
    
    UIBarButtonItem *tagBarButton = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"toolsbar_tag"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        
    }];
    
    UIBarButtonItem *orderbyBarButton = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"toolsbar_orderby"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        [_textView setVerticalForm:!_textView.verticalForm];
        
        
    }];
    
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"toolsbar_camera"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        
    }];
    
    return @[locationBarButton,fixedSpaceBarButton,tagBarButton,fixedSpaceBarButton,cameraButton,fixedSpaceBarButton,orderbyBarButton];

}

- (UIToolbar*)bottomToolsBar{
    
   UIToolbar *toolBar =  [[UIToolbar alloc]init];
    
    toolBar.size = CGSizeMake(kHY_SCREEN_WIDTH, 44);
    
    toolBar.barStyle = UIBarStyleDefault;
  
    toolBar.items = [self toolsBarButtonItems];


    return toolBar;
    
}



- (void)edit:(UIBarButtonItem *)item {
    
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
        
    } else {
        [_textView becomeFirstResponder];
    }
    
    NSLog(@"%@",_textView.attributedText);
    
   NSData *noteData =  [_textView.attributedText archiveToData];
    
    if ([_delegate respondsToSelector:@selector(noteEditEnd:)]) {
     
        [_delegate noteEditEnd:noteData];
    }
}



#pragma mark text view delegate

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - keyboard notifacation

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    if (_textView.isVerticalForm && transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        _textView.frame = self.view.bounds;
    }
    
    
}

@end
