//
//  NewsCell.h
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//


/*
 Table view cell to display news on the table view
 */
#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (nonatomic,unsafe_unretained) UILabel *newsHeaderLabel; //news heading
@property (nonatomic,unsafe_unretained) UILabel *newsSubLabel; // news description
@property (nonatomic,unsafe_unretained) UIImageView *newsImageView; // news image

@end
