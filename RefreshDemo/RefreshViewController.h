//
//  RefreshViewController.h
//  RefreshDemo
//
//  Created by fcx on 15/8/25.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshViewController : UIViewController


/**
 *  是否自动加载更多，默认上拉超过scrollView的内容高度时，直接加载更多
 */
@property (nonatomic, unsafe_unretained) BOOL autoLoadMore;


@end
