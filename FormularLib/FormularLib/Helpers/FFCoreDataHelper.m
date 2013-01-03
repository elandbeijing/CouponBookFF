//
//  FFCoreDataHelper.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFCoreDataHelper.h"
#import <CoreData/CoreData.h>

@interface FFManagedDocument : UIManagedDocument
@property (nonatomic,retain,readonly) NSManagedObjectModel *myManagedObjectModel;
@end

@implementation FFManagedDocument
@synthesize myManagedObjectModel = _myManagedObjectModel;
-(NSManagedObjectModel*)myManagedObjectModel
{
    @synchronized(self){
        if(!_myManagedObjectModel){
    // test code에서는 [NSBundle mainBundle]로 현재 bundle을 가져올 수 없음. [NSBundle bundleForClass:self.class] 사용
    //        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"FormularLibResource" withExtension:@"bundle"]];
            NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:self.class] URLForResource:@"FormularLibResource" withExtension:@"bundle"]];        
            NSURL *modelURL = [bundle URLForResource:@"Model" withExtension:@"momd"];
            _myManagedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
        }
    }
    return _myManagedObjectModel;
}

-(NSManagedObjectModel*)managedObjectModel {
    return self.myManagedObjectModel;
}
@end


@implementation FFCoreDataHelper

static NSManagedObjectContext *_context;
static FFManagedDocument *_document;

+(void)openDocument:(NSString *)documentName usingBlock:(completion_block_t)completionBlock
{
    if(_context){
        completionBlock(_context);
        return;
    }

    
    NSURL *fileUrl = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    fileUrl = [fileUrl URLByAppendingPathComponent:documentName];
    
    if(!_document){
        _document = [[FFManagedDocument alloc]initWithFileURL:fileUrl];
        _context = _document.managedObjectContext;
    }
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:fileUrl.path]){
        [_document saveToURL:fileUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            _context = _document.managedObjectContext;
            completionBlock(_context);
        }];
    }else if(_document.documentState == UIDocumentStateClosed){
        [_document openWithCompletionHandler:^(BOOL success){
            _context = _document.managedObjectContext;
            completionBlock(_context);
        }];
    }else if(_document.documentState == UIDocumentStateNormal){
        _context = _document.managedObjectContext;
        completionBlock(_context);
    }
}

@end
