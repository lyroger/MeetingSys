//
//  MSSelectMemeberViewController.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/18.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSBaseViewController.h"

typedef NS_ENUM(NSUInteger, MSSelectMemeberType)
{
    MSSelectMemeber_Organizer,
    MSSelectMemeber_Others,
};

typedef void(^SelectedMemberBlock)(MSSelectMemeberType selectType,NSArray *members);

@interface MSSelectMemeberViewController : MSBaseViewController

@property (nonatomic, assign) MSSelectMemeberType memberType;
@property (nonatomic, strong) NSMutableArray *selectedMemebers;
@property (nonatomic, copy)   SelectedMemberBlock selectBlock;

@end

