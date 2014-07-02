//
//  MTZWhatsNewFeatureCollectionViewCell.m
//  What's New
//
//  Created by Matt Zanchelli on 5/23/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "MTZWhatsNewFeatureCollectionViewCell.h"

#import "NSLayoutConstraint+Common.h"

@interface MTZWhatsNewFeatureCollectionViewCell ()

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *detailTextLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MTZWhatsNewFeatureCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id)init
{
	self = [super init];
    if (self) {
		[self commonInit];
    }
    return self;
}

/// Initialization code
- (void)commonInit
{
	self.backgroundColor = [UIColor clearColor];

	self.textLabel = [[UILabel alloc] init];
	[self.contentView addSubview:self.textLabel];
	self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.textLabel.textColor = [UIColor whiteColor];
	self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:20.0f];
	self.textLabel.numberOfLines = 0;
	self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

	self.detailTextLabel = [[UILabel alloc] init];
	[self.contentView addSubview:self.detailTextLabel];
	self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.detailTextLabel.textColor = [UIColor whiteColor];
	self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
	self.detailTextLabel.numberOfLines = 0;
	self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;

	self.imageView = [[UIImageView alloc] init];
	[self.contentView addSubview:self.imageView];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

	// Default of no style.
	_layoutStyle = -1;
}

- (void)setLayoutStyle:(MTZWhatsNewFeatureCollectionViewCellLayoutStyle)layoutStyle
{
	// Avoid reapplying layout, if not necessary..
	if ( layoutStyle == _layoutStyle ) return;

	_layoutStyle = layoutStyle;
	switch (_layoutStyle) {
		case MTZWhatsNewFeatureCollectionViewCellLayoutStyleList:
			[self layoutForList];
			break;
		case MTZWhatsNewFeatureCollectionViewCellLayoutStyleGrid:
			[self layoutForGrid];
			break;
	}
}

- (void)layoutForList
{
	[self removeAllConstraints];

	self.textLabel.textAlignment = NSTextAlignmentLeft;
	self.detailTextLabel.textAlignment = NSTextAlignmentLeft;

	// Thew views to be referencing in visual format.
	NSDictionary *views = @{@"icon": self.imageView, @"title": self.textLabel, @"detail": self.detailTextLabel};
	NSDictionary *metrics = @{
			@"textWidth":@194,
			@"iconSize":@64,
			@"textPadding":@26,
			@"iconTextSpacing":@10,
			@"titleDetailSpacing":@2,
			@"minTitleHeight":@20,
			@"minDetailHeight":@34
	};

	// Vertically align image view to the top in order to accomodate variable height title and detail labels.
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];

	// Horizontally space icon and labels.
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textPadding)-[icon(iconSize)]-(iconTextSpacing)-[title(>=textWidth)]-(textPadding)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textPadding)-[icon(iconSize)]-(iconTextSpacing)-[detail(>=textWidth)]-(textPadding)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
	// Vertically align labels.
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[title(>=minTitleHeight)]-(titleDetailSpacing)-[detail(>=minDetailHeight)]-(>=0)-|" options:NSLayoutFormatDirectionMask metrics:metrics views:views]];
}

- (void)layoutForGrid
{
	[self removeAllConstraints];

	self.textLabel.textAlignment = NSTextAlignmentCenter;
	self.detailTextLabel.textAlignment = NSTextAlignmentCenter;

	// Thew views to be referencing in visual format.
	NSDictionary *views = @{@"icon": self.imageView, @"title": self.textLabel, @"detail": self.detailTextLabel};
	NSDictionary *metrics = @{
			@"textWidth":@206,
			@"iconSize":@64,
			@"textPadding":@32,
			@"minTitleHeight":@20,
			@"minDetailHeight":@28
	};

	// Horizontal alignment.
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[icon(iconSize)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textPadding)-[title(>=textWidth)]-(textPadding)-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textPadding)-[detail(>=textWidth)]-(textPadding)-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
	// Vertical alignment.
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[icon(iconSize)]-10-[title(>=minTitleHeight)]-4-[detail]-(>=minDetailHeight)-(>=0)-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
}

- (void)prepareForReuse
{
	self.title = nil;
	self.detail = nil;
	self.icon = nil;
}

- (void)removeAllConstraints
{
	// Remove all constraints. Start from a clean state.
	[self.contentView removeConstraints:self.contentView.constraints];
	[self.textLabel removeConstraints:self.textLabel.constraints];
	[self.detailTextLabel removeConstraints:self.detailTextLabel.constraints];
	[self.imageView removeConstraints:self.imageView.constraints];
}


#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
	self.textLabel.text = [title copy];
}

- (NSString *)title
{
	return self.textLabel.text;
}

- (void)setDetail:(NSString *)detail
{
	self.detailTextLabel.text = [detail copy];
}

- (NSString *)detail
{
	return self.detailTextLabel.text;
}

- (void)setIcon:(UIImage *)icon
{
	self.imageView.image = [icon copy];
}

- (UIImage *)icon
{
	return self.imageView.image;
}

- (void)setContentColor:(UIColor *)contentColor
{
	_contentColor = contentColor;

	self.textLabel.textColor = _contentColor;
	self.detailTextLabel.textColor = _contentColor;
	self.imageView.tintColor = _contentColor;
}

@end