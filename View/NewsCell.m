//
//  NewsCell.m
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import "NewsCell.h"
#import "Constants.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.newsHeaderLabel = [[[UILabel alloc]init]autorelease];
        self.newsHeaderLabel.textAlignment = NSTextAlignmentLeft;
        self.newsHeaderLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        self.newsHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.newsHeaderLabel.numberOfLines = 0;
        self.newsHeaderLabel.textColor = [UIColor blueColor];
        
        self.newsSubLabel = [[[UILabel alloc]init]autorelease];
        self.newsSubLabel.textAlignment = NSTextAlignmentLeft;
        self.newsSubLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        self.newsSubLabel.numberOfLines = 0;
        self.newsSubLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.newsImageView = [[[UIImageView alloc]init]autorelease];
        
        [self.contentView addSubview:self.newsHeaderLabel];
        [self.contentView addSubview:self.newsSubLabel];
        [self.contentView addSubview:self.newsImageView];
        // Initialization code
    }
    return self;
}

// set up the coordinates of the UI elements
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    
    CGRect frame;
   
    [self.newsSubLabel setNeedsDisplay];
    
    [self.newsHeaderLabel sizeToFit];
    [self.newsSubLabel sizeToFit];
    
    //Coordinates of Header Label
    CGFloat headerX = boundsX + 15;
    CGFloat headerWidth = contentRect.size.width - headerX;
    CGFloat headerHeight = self.newsHeaderLabel.frame.size.height;
    frame= CGRectMake(headerX ,2, headerWidth, headerHeight);
    self.newsHeaderLabel.frame = frame;
    
    //Coordinates of Sub Label
    CGFloat subHeaderX = boundsX + 15;
    CGFloat subHeaderWidth = contentRect.size.width - subHeaderX - contentRect.size.width/3;
    CGFloat subHeaderHeight = self.newsSubLabel.frame.size.height;
    frame= CGRectMake(subHeaderX ,headerHeight + 2 , subHeaderWidth, subHeaderHeight);
    self.newsSubLabel.frame = frame;
    
    //Coordinates of image view
    CGFloat imageViewX = subHeaderWidth + 25;
    frame = CGRectMake(imageViewX, headerHeight + 2, 44, 44);
    self.newsImageView.frame = frame;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



