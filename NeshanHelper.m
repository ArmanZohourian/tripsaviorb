//
//  NeshanHelper.m
//  NeshanNav
//
//  Created by Hoorad Ramezani on 7/19/21.
//

#import <Foundation/Foundation.h>
#import "NeshanHelper.h"

@implementation VectorElementClickedListener

-(BOOL)onVectorElementClicked: (NTElementClickData*)clickInfo
{
    if (self.onVectorElementClickedBlock != nil)
        return self.onVectorElementClickedBlock(clickInfo);
    return NO;
}
@end

@implementation MapEventListener

-(void)onMapClicked: (NTClickData*)clickInfo
{
    if (self.onMapClickedBlock != nil)
        self.onMapClickedBlock(clickInfo);
}

-(void) onMapMoved
{
    if (self.onMapMovedBlock != nil)
        self.onMapMovedBlock();
}

-(void) onMapStable
{
    if (self.onMapStableBlock != nil)
        self.onMapStableBlock();
}

-(void) onMapIdle
{
    if (self.onMapIdleBlock != nil)
        self.onMapIdleBlock();
}
@end
