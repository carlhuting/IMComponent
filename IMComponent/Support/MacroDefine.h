//
//  macroDefine.h
//  IMComponent
//
//  Created by lkeg on 15/12/17.
//  Copyright © 2015年 lkeg. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

#define viewController(storyboardName) + (instancetype)viewController { \
UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil]; \
return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];\
}

#ifdef DEBUG
    #define FLOG  NSLog(@" method = %@", NSStringFromSelector(_cmd));
#else
    #define FLOG
#endif

#endif /* MacroDefine_h */
