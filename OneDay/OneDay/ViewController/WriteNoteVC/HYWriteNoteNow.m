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
#import "LocationTools.h"
#import "NoteDBModel.h"
#import "LocationModel.h"
@interface HYWriteNoteNow () <YYTextViewDelegate, YYTextKeyboardObserver,LocationToolsDelegate>


@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISwitch *verticalSwitch;
@property (nonatomic, strong) UISwitch *exclusionSwitch;
@property(nonatomic,strong)LocationTools *locationTools;


//存储用户位置信息
@property(nonatomic)LocationModel *locationModel;

//textView

@property(nonatomic)NSMutableAttributedString *textAttributed;

@property (nonatomic, strong) YYTextView *textView;

@end

@implementation HYWriteNoteNow

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _textAttributed = [[NSMutableAttributedString alloc]initWithString:@" "];
        
        _textView = [[YYTextView alloc]init];
        
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

#pragma mark - lifeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // setting toolsBar
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    _textView.inputAccessoryView = [self bottomToolsBar];
    
    self.toolbarItems = [self toolsBarButtonItems];
    

    _locationTools = [LocationTools new];
    
    _locationTools.delegate = self;
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
    
    
    if (_noteModel.note_body) {
        
        _textAttributed = [NSMutableAttributedString unarchiveFromData:_noteModel.note_body];
        
    }else{
        
        _textAttributed = [[NSMutableAttributedString alloc]initWithString:@" "];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            [_textView becomeFirstResponder];
        });
        
        _textAttributed.font = [UIFont fontWithName:@"Times New Roman" size:20];
        _textAttributed.lineSpacing = 4;
        _textAttributed.firstLineHeadIndent = 20;
       
    }
    
    _textView.attributedText = _textAttributed;
    
    _textView.frame = self.view.bounds;
    
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _textView.delegate = self;
    
    //textView.allowsPasteImage = YES; /// Pasts image
    
    //textView.allowsPasteAttributedString = YES; /// Paste attributed string

    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    _textView.contentInset = UIEdgeInsetsMake(64, 0, 64, 0);
    
    _textView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    
    _textView.selectedRange = NSMakeRange(_textAttributed.length, 0);

    
    [self.view addSubview:_textView];

    
    
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    if (_noteModel) {
        
        if (![_textView.text isEqualToString:_noteModel.note_title]) {
            [self updateNote];
        }

    }else{
        [self saveNote];
    }
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}



#pragma mark - privateMethod

- (void)saveNote{
    
    
    if (!_textView.text.isNotBlank) {
        
        return;
    }

    
    NoteDBModel *noteModel = [[NoteDBModel alloc]init];
    
    noteModel.note_title = _textView.text;
    
    NSData *noteData =  [_textView.attributedText archiveToData];
    
    if (noteData) {
        noteModel.note_body = noteData;
    }
    
    noteModel.note_weather = @"18℃ 晴";
    
    if (_locationModel) {
        
        noteModel.note_lat = [NSNumber numberWithDouble:_locationModel.lat];
        
        noteModel.note_lng = [NSNumber numberWithDouble:_locationModel.log];
        
        noteModel.note_adress = _locationModel.adressName;
    }
    
    noteModel.note_sync = @NO;
    
    TagDBModel *tagModel = [[TagDBModel alloc]init];
    
    tagModel.tagName = @"标签";
    
    [noteModel.note_tag addObject:tagModel];
    
    noteModel.note_date = [NSDate date];
    
    FolderDBModel *folderModel = [[FolderDBModel alloc]init];
    
    folderModel.folderName= @"默认文件夹";
    
    noteModel.note_folder = folderModel;
    
    
    noteModel.note_step = @"10000";
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        
        [realm addObject:noteModel];
        
    }];
    
}

- (void)updateNote{

    if (_noteModel) {
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        
        if (_textView.text.length!=0) {
            
            _noteModel.note_title = _textView.text;
        }

        
        NSData *noteData =  [_textView.attributedText archiveToData];
        
        if (noteData) {
            _noteModel.note_body = noteData;
        }
        
        [realm commitWriteTransaction];
    }
}

/**
 *  获取ToolsBar 的 BarButtonItems
 *
 *  @return BarButtonItems
 */
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

/**
 *  获取ToolsBar
 *
 *  @return ToolsBar
 */
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

#pragma mark - Location delegate

- (void)onLocationSuccess:(LocationModel*)locationModel{

    _locationModel = locationModel;
}

- (void)onLocationFail{
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
