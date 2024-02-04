//
//  NeshanHelper.h
//  NeshanNav
//
//  Created by Hoorad Ramezani on 7/19/21.
//


#import <UIKit/UIKit.h>
#import <NeshanMobileSDK/NeshanMobileSDK.h>

NS_ASSUME_NONNULL_BEGIN

#define API_KEY @"service.rx9jiKxPU7lJc403UBx3SsV75lOW65MCdQuA7nun"

@interface VectorElementClickedListener: NTVectorElementEventListener

typedef BOOL (^OnVectorElementClickedBlock)(NTElementClickData* clickInfo);
@property (readwrite, copy) OnVectorElementClickedBlock onVectorElementClickedBlock;

@end

@interface MapEventListener: NTMapEventListener
typedef void (^OnMapClickedBlock)(NTClickData* clickInfo);
@property (readwrite, copy) OnMapClickedBlock onMapClickedBlock;

typedef void (^OnMapMovedBlock)(void);
@property (readwrite, copy) OnMapMovedBlock onMapMovedBlock;


typedef void (^OnMapStableBlock)(void);
@property (readwrite, copy) OnMapStableBlock onMapStableBlock;


typedef void (^OnMapIdleBlock)(void);
@property (readwrite, copy) OnMapIdleBlock onMapIdleBlock;

@end

NS_ASSUME_NONNULL_END
