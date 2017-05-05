//
//  MNLoginViewController.h
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSBaseViewController.h"

typedef void(^DidLoginComplete)(BOOL successful);

@interface MSLoginViewController : MSBaseViewController

@property (nonatomic, copy) DidLoginComplete loginCompleteBlock;

@end
