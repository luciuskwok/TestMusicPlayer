//
//  TestMusicPlayerViewController.h
//  TestMusicPlayer
//
//  Created by Lucius Kwok on 7/12/10.
//  Copyright Felt Tip Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface TestMusicPlayerViewController : UIViewController {
	IBOutlet UITableView *tableView;
	IBOutlet UIImageView *artworkView;
	IBOutlet UILabel *artistLabel;
	IBOutlet UILabel *titleLabel;
	IBOutlet UIToolbar *currentToolbar;
	IBOutlet UIToolbar *playToolbar;
	IBOutlet UIToolbar *pauseToolbar;
	
	MPMusicPlayerController *musicPlayer;
	NSArray *playlists;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *artworkView;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIToolbar *currentToolbar;
@property (nonatomic, retain) UIToolbar *playToolbar;
@property (nonatomic, retain) UIToolbar *pauseToolbar;

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, retain) NSArray *playlists;

- (IBAction)skipToPrevious:(id)sender;
- (IBAction)skipToNext:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)reload:(id)sender;

@end

