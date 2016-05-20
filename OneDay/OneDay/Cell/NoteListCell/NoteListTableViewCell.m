//
//  NoteListTableViewCell.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/18.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "NoteListTableViewCell.h"
#import "NoteDBModel.h"
#import <YYKit.h>
#import <NSDate+DateTools.h>
#import <Foundation/Foundation.h>
#import "DateTools.h"
#import "Constant.h"
@interface NoteListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dayLable;

@property (weak, nonatomic) IBOutlet UILabel *weeksLable;

@property (weak, nonatomic) IBOutlet UIView *textViewContainer;

@property(nonatomic)UITextView *textView;

@end

@implementation NoteListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _textView = [UITextView new];
    
    [_textViewContainer addSubview:_textView];
    
    _textView.editable = NO;
    
    _textView.userInteractionEnabled = NO;
    
    
    _textView.font =[UIFont fontWithName:@"Times New Roman" size:17];
    
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(_textViewContainer);
    }];
    
}

- (void)setNoteModel:(NoteDBModel *)noteModel{
    
    if (noteModel) {
        
        _noteModel = noteModel;
        
        _textView.text = _noteModel.note_title;
        
        NSDate *date = _noteModel.note_date;
        
        _dayLable.text = [NSString stringWithFormat:@"%ld",[date day]];
        
        _weeksLable.text = [DateTools weekName:date];
        
        
    }
}


- (void)layoutSubviews{


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
