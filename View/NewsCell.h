//
//  NewsCell.h
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (nonatomic,unsafe_unretained) UILabel *newsHeaderLabel;
@property (nonatomic,unsafe_unretained) UILabel *newsSubLabel;
@property (nonatomic,unsafe_unretained) UIImageView *newsImageView;

@end
