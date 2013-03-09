//
//  AppDelegate.m
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.window.rootViewController = self.mainViewController;
    
    // Handle te loading of a previously saved game
    NSString *path = [self saveGamePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.mainViewController.game = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        self.mainViewController.shouldStartNewGame = NO;
        
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Save game object to game.savegame, but only if not game isn't over yet
    if (self.mainViewController.gameNotYetOver) {
        NSString *path = [self saveGamePath];
        [NSKeyedArchiver archiveRootObject:self.mainViewController.game toFile:path];
        NSLog(@"Saved game to /Documents/game.savegame");
        self.mainViewController.game = nil;
    }
    // Else delete file at savegame path and set game to nil
    else {
        NSString *path = [self saveGamePath];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        self.mainViewController.game = nil;
        NSLog(@"Savegame was deleted");
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Reload savegame
    NSString *path = [self saveGamePath];
    self.mainViewController.game = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (NSString *)saveGamePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"game.savegame"];
}

@end
