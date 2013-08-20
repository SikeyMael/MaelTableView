//
//  MaelTableView.h
//  Easy Table View
//
//  Created by Paolo Crociati on 20/08/13. 
//  Copyright (c) 2013 Maelstorm App. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MaelTableViewDelegate
- (void)tableRowSelected:(UITableView *)sender selectedData:(NSDictionary *)currentRow;
- (UITableViewCell *)tableCreateCell:(UITableView *)sender usingData:(NSDictionary *)currentRow;
@end

@interface MaelTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) id <NSObject, MaelTableViewDelegate> MaelTableDelegate;

-(void)fillTableWithData:(NSArray *)tableData;
-(void)fillTableWithData:(NSArray *)tableData sectionsFromKey:(NSString *)keyName withTitleLength:(int)numberOfCharactes;
@end

@interface NSObject (MaelNSObject)
-(int)MaelCInt;
@end

@interface NSMutableArray (MaelNSMutableArray)
-(NSObject *)getDataAtRow:(int)nRow andDictionaryKey:(NSString *)strKeyName;
@end