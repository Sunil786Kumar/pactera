//
//  NewsCell.m
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.newsHeaderLabel = [[[UILabel alloc]init]autorelease];
        self.newsHeaderLabel.textAlignment = NSTextAlignmentLeft;
        self.newsHeaderLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        
        
        self.newsSubLabel = [[[UILabel alloc]init]autorelease];
        self.newsSubLabel.textAlignment = NSTextAlignmentLeft;
        self.newsSubLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];;
        //self.newsSubLabel.numberOfLines = 3;
       
        self.newsImageView = [[[UIImageView alloc]init]autorelease];
        
        [self.contentView addSubview:self.newsHeaderLabel];
        [self.contentView addSubview:self.newsSubLabel];
        [self.contentView addSubview:self.newsImageView];
        // Initialization code
    }
    return self;
}


-(void)layoutSubviews
{
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    
    CGRect frame;
    
    //Coordinates of Header Label
    CGFloat headerX = boundsX + 15;
    CGFloat headerWidth = contentRect.size.width - headerX;
    CGFloat headerHeight = 25;
    
    frame= CGRectMake(headerX ,2, headerWidth, headerHeight);
    self.newsHeaderLabel.frame = frame;
    
    //Coordinates of Sub Label
    CGFloat subHeaderX = boundsX + 15;
    CGFloat subHeaderWidth = contentRect.size.width - subHeaderX - contentRect.size.width/3;
    CGFloat subHeaderHeight = 25;
    
    frame= CGRectMake(subHeaderX ,headerHeight + 2 , subHeaderWidth, subHeaderHeight);
    self.newsSubLabel.frame = frame;
    
    //Coordinates of image view
    CGFloat imageViewX = subHeaderWidth + 5;
    frame = CGRectMake(imageViewX, headerHeight + 2, 44, 44);
    self.newsImageView.frame = frame;
    
    [super layoutSubviews];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
