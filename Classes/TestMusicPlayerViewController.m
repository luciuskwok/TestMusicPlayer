//
//  TestMusicPlayerViewController.m
//  TestMusicPlayer
//
//  Created by Lucius Kwok on 7/12/10.
//  Copyright Felt Tip Inc. 2010. All rights reserved.
//

#import "TestMusicPlayerViewController.h"


#define kPlayPauseButtonTag 101

@implementation TestMusicPlayerViewController
@synthesize tableView, artworkView, artistLabel, titleLabel, currentToolbar, playToolbar, pauseToolbar;
@synthesize playlists, musicPlayer;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[tableView release];
	[artworkView release];
	[artistLabel release];
	[titleLabel release];
	[currentToolbar release];
	[playToolbar release];
	[pauseToolbar release];
	
	[playlists release];
	[musicPlayer release];
	
	[super dealloc];
}

#pragma mark View updating

- (void)updateNowPlaying {
	MPMediaItem *item = musicPlayer.nowPlayingItem;
	if (item != nil) {
		artistLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
		titleLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
		artworkView.image = [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:artworkView.bounds.size];
	} else {
		artistLabel.text = @"";
		titleLabel.text = @"";
		artworkView.image = nil;
	}
	
}

- (void)updateToolbar {
	BOOL isPlaying = (musicPlayer.playbackState == MPMusicPlaybackStatePlaying);
	if (isPlaying) {
		[currentToolbar setItems: pauseToolbar.items animated:NO];
	} else {
		[currentToolbar setItems: playToolbar.items animated:NO];
	}
}

#pragma mark MPMusicPlayerController

- (void)registerForMusicPlayerNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(playingItemDidChange:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
	[nc addObserver:self selector:@selector(playbackStateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:musicPlayer];	
	[musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)unregisterMusicPlayerNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
	[nc removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:musicPlayer];
	[musicPlayer endGeneratingPlaybackNotifications];
}

#pragma mark UIViewController

- (void)awakeFromNib {
	self.playlists = [[MPMediaQuery playlistsQuery] collections];
	self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	[self registerForMusicPlayerNotifications];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self updateNowPlaying];
	[self updateToolbar];
}

#pragma mark Notifications

- (void)playingItemDidChange:(NSNotification *)aNotification {
	[self updateNowPlaying];
}

- (void)playbackStateDidChange:(NSNotification *)aNotification {
	[self updateToolbar];
}


#pragma mark Actions

- (IBAction)skipToPrevious:(id)sender {
	if (musicPlayer.currentPlaybackTime < 2.0) {
		NSInteger oldMode = musicPlayer.repeatMode;
		musicPlayer.repeatMode = MPMusicRepeatModeAll;
		[musicPlayer skipToPreviousItem];
		musicPlayer.repeatMode = oldMode;
	} else {
		[musicPlayer skipToBeginning];
	}
}

- (IBAction)skipToNext:(id)sender {
	NSInteger oldMode = musicPlayer.repeatMode;
	musicPlayer.repeatMode = MPMusicRepeatModeAll;
	[musicPlayer skipToNextItem];
	musicPlayer.repeatMode = oldMode;
}

- (IBAction)playPause:(id)sender {
	if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
		[musicPlayer pause];
	} else {
		[musicPlayer play];
	}
}

- (IBAction)reload:(id)sender {
	// Reload list of playlists.
	self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	[tableView reloadData];
	
	// Reload Music Player.
	[self unregisterMusicPlayerNotifications];
	self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	[self registerForMusicPlayerNotifications];
	
	// Reload Now Playing display and toolbar.
	[self updateNowPlaying];
	[self updateToolbar];
}

#pragma mark UITableView delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return playlists.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Configure the cell.
	MPMediaPlaylist *playlist = [playlists objectAtIndex:indexPath.row];
	cell.textLabel.text = [playlist valueForProperty: MPMediaPlaylistPropertyName];
	
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Start playing the selected playlist
	MPMediaPlaylist *playlist = [playlists objectAtIndex:indexPath.row];
	[musicPlayer setQueueWithItemCollection:playlist];
	[musicPlayer play];
}

@end
