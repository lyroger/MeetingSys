//
//  MSNewMeetingInputCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNewMeetingInputCell.h"
#import "MSMustInputItemView.h"

@interface MSNewMeetingInputCell()<UITextViewDelegate,UITextFieldDelegate>
{
    MSMustInputItemView *mustView;
    UITextField         *textField;
    UITextView          *textView;
    UILabel             *placeholderLabel;
}

@property (nonatomic, strong) UILabel *bottomLine;

@end
@implementation MSNewMeetingInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        mustView = [MSMustInputItemView new];
        [self.contentView addSubview:mustView];
        
        textField = [UITextField new];
        textField.font = kFontPingFangRegularSize(14);
        textField.textColor = UIColorHex(0x333333);
        textField.delegate = self;
        [self.contentView addSubview:textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
        textView = [UITextView new];
        textView.font = kFontPingFangRegularSize(14);
        textView.textColor = UIColorHex(0x888888);
        textView.delegate = self;
        [self.contentView addSubview:textView];
        
        placeholderLabel = [UILabel new];
        placeholderLabel.font = kFontPingFangRegularSize(14);
        placeholderLabel.textColor = UIColorHex(0x888888);
        [textView addSubview:placeholderLabel];
        
        [mustView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@14);
            make.right.equalTo(@(-12));
            make.height.equalTo(@16);
        }];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(mustView.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-12);
        }];
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(mustView.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(9);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-12);
        }];
        
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(4);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        self.bottomLine = [UILabel new];
        self.bottomLine.backgroundColor = UIColorHex(0xE3E3E3);
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.height.equalTo(@(0.6));
        }];
    }
    return self;
}

- (void)multipleLineInput:(BOOL)multiple title:(NSString *)title placeholder:(NSString *)placeholder must:(BOOL)must
{
    [mustView title:title mustItem:must];
    if (multiple) {
        textView.hidden = NO;
        textField.hidden = YES;
        placeholderLabel.text = placeholder;
        placeholderLabel.hidden = textView.text.length;
    } else {
        textField.hidden = NO;
        textView.hidden = YES;
        textField.placeholder = placeholder;
    }
}

- (void)contentText:(NSString*)text multipleLine:(BOOL)multiple
{
    if (text.length) {
        if (multiple) {
            textView.text = text;
            textView.textColor = UIColorHex(0x333333);
        } else {
            textField.text = text;
        }
    } else {
        if (multiple) {
            textView.textColor = UIColorHex(0x333333);
        }
    }
}

- (void)textViewDidChange:(UITextView *)textV
{
    placeholderLabel.hidden = textV.text.length;
    NSString *text = [textV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length > 1000) {
        text = [text substringWithRange:NSMakeRange(0, 1000)];
        textV.text = text;
    }
    if (self.inputBlock) {
        self.inputBlock(text);
    }
}

- (void)textFieldTextDidChange:(NSNotificationCenter*)note
{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length > 50) {
        text = [text substringWithRange:NSMakeRange(0, 50)];
        textField.text = text;
    }
    if (self.inputBlock) {
        self.inputBlock(text);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
