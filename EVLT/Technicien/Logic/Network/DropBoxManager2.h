//
//  DropboxManager2.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 16/04/2015.
//  Copyright (c) 2015 Emmanuel Levasseur. All rights reserved.
//
#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

#define kDropbox_AppKey @"5fzj65nhs3znvf6" // Provide your key here - 5fzj65nhs3znvf6 / 6azp4ptgb11f95l
#define kDropbox_AppSecret @"3mekuljd36n2750" // Provide your secret key here - 3mekuljd36n2750 / 5sm7e3enggsrvrw
#define kDropbox_RootFolder kDBRootAppFolder //Decide level access like root or app - kDBRootAppFolder / kDBRootDropbox

@protocol DropBoxDelegate;

typedef enum
{
    DropBoxTypeStatusNone = 0,
    DropBoxGetAccountInfo = 1,
    DropBoxGetFolderList = 2,
    DropBoxCreateFolder = 3,
    DropBoxUploadFile = 4
} DropBoxPostType;

@interface DropboxManager : NSObject <DBRestClientDelegate,DBSessionDelegate,UIAlertViewDelegate>
{
    UIViewController<DropBoxDelegate> *apiCallDelegate;
    
    DBSession *objDBSession;
    NSString *relinkUserId;
    DBRestClient *objRestClient;
    
    DropBoxPostType currentPostType;
    
    NSString *strFileName;
    NSString *strFilePath;
    NSString *strDestDirectory;
    NSString *strFolderCreate;
    NSString *strFolderToList;
}

@property (nonatomic,retain) DBSession *objDBSession;
@property (nonatomic,retain) NSString *relinkUserId;

@property (nonatomic,retain) UIViewController<DropBoxDelegate> *apiCallDelegate;

@property (nonatomic,retain) DBRestClient *objRestClient;

@property (nonatomic,assign) DropBoxPostType currentPostType;

@property (nonatomic,retain) NSString *strFileName;
@property (nonatomic,retain) NSString *strFilePath;
@property (nonatomic,retain) NSString *strDestDirectory;

@property (nonatomic,retain) NSString *strFolderCreate;

@property (nonatomic,retain) NSString *strFolderToList;

//Singleton
+(id)dropBoxManager;

//Initialize dropbox
-(void)initDropbox;

//Authentication Verification
-(BOOL)handledURL:(NSURL*)url;
-(void)dropboxDidLogin;
-(void)dropboxDidNotLogin;

//Upload file
-(void)uploadFile;

//Download File
-(void)downlaodFileFromSourcePath:(NSString*)pstrSourcePath destinationPath:(NSString*)toPath;

//Create Folder
-(void)createFolder;

//Get Account Information
-(void)loginToDropbox;
-(void)logoutFromDropbox;
-(BOOL)isLoggedIn;

//List Folders
-(void)listFolders;

@end

@protocol DropBoxDelegate <NSObject>

@optional

- (void)finishedLogin:(NSMutableDictionary*)userInfo;
- (void)failedToLogin:(NSString*)withMessage;

- (void)finishedCreateFolder;
- (void)failedToCreateFolder:(NSString*)withMessage;

- (void)finishedUploadFile;
- (void)failedToUploadFile:(NSString*)withMessage;

- (void)finishedDownloadFile;
- (void)failedToDownloadFile:(NSString*)withMessage;

- (void)getFolderContentFinished:(DBMetadata*)metadata;
- (void)getFolderContentFailed:(NSString*)withMessage;

@end