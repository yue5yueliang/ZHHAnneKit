//
//  UIControl+ZHHSound.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIControl+ZHHSound.h"
#import <objc/runtime.h>

// Key for the dictionary of sounds for control events.
static char const * const zhh_kSoundsKey = "zhh_kSoundsKey";

@implementation UIControl (ZHHSound)
- (void)zhh_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent {
    // Remove the old UI sound.
    NSString *oldSoundKey = [NSString stringWithFormat:@"%zd", controlEvent];
    AVAudioPlayer *oldSound = [self zhh_sounds][oldSoundKey];
    [self removeTarget:oldSound action:@selector(play) forControlEvents:controlEvent];
    
    // Set appropriate category for UI sounds.
    // Do not mute other playing audio.
    [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryAmbient" error:nil];
    
    // Find the sound file.
    NSString *file = [name stringByDeletingPathExtension];
    NSString *extension = [name pathExtension];
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:file withExtension:extension];
    
    NSError *error = nil;
    
    // Create and prepare the sound.
    AVAudioPlayer *tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    NSString *controlEventKey = [NSString stringWithFormat:@"%zd", controlEvent];
    NSMutableDictionary *sounds = [self zhh_sounds];
    [sounds setObject:tapSound forKey:controlEventKey];
    [tapSound prepareToPlay];
    if (!tapSound) {
        NSLog(@"Couldn't add sound - error: %@", error);
        return;
    }
    
    // Play the sound for the control event.
    [self addTarget:tapSound action:@selector(play) forControlEvents:controlEvent];
}


#pragma mark - Associated objects setters/getters

- (void)setZhh_sounds:(NSMutableDictionary *)sounds {
    objc_setAssociatedObject(self, zhh_kSoundsKey, sounds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)zhh_sounds {
    NSMutableDictionary *sounds = objc_getAssociatedObject(self, zhh_kSoundsKey);
    // If sounds is not yet created, create it.
    if (!sounds) {
        sounds = [[NSMutableDictionary alloc] initWithCapacity:2];
        // Save it for later.
        [self setZhh_sounds:sounds];
    }
    return sounds;
}

@end
