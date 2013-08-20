//
//  MaelTableView.m
//  Easy Table View
//
//  Created by Paolo Crociati on 20/08/13.
//  Copyright (c) 2013 Maelstorm App. All rights reserved.
//

#import "MaelTableView.h"

@interface MaelTableView()
@property (nonatomic, strong) NSMutableArray* dttSections; //Contains the structure of the sections (how many elements, the first element)
@property (nonatomic, strong) NSMutableArray* dttIndexes; //The list of characters used as title of every sections
@property (nonatomic, strong) NSArray *dttData; //Data used to create cells. Every object of this NSArry must contains a Dictionary.
@property (nonatomic) bool bWithSections; // Internally used to check if sections are enabled
@property (nonatomic) int lSectionTitleLength; // the length of the title in a sections
@property (nonatomic, strong) NSString *strSectionByKeyName; //Name of the key of dttData used to create the sections (only work if every dictionary in dttData have this key name and data is already ordered)

-(NSDictionary *)createDataForNewSection:(NSString *)strSectionTitle withNumberOfElements:(int)lNum atStartPosition:(int)lStart;
@end

@implementation MaelTableView
@synthesize MaelTableDelegate = _MaelTableDelegate;
@synthesize dttSections = _dttSections;
@synthesize dttIndexes = _dttIndexes;
@synthesize bWithSections = _bWithSections;
@synthesize lSectionTitleLength = _lSectionTitleLength;
@synthesize strSectionByKeyName = _strSectionByKeyName;
@synthesize dttData = _dttData;

#pragma mark - Setters
-(void)setStrSectionByKeyName:(NSString *)strSectionByKeyName {
    //When the name of the key used to create sections is empty, sections will be disabled.
    self.bWithSections = ![strSectionByKeyName isEqualToString:@""];
    
    _strSectionByKeyName = strSectionByKeyName;
}
-(void)setDttData:(NSMutableArray *)dttData {
    _dttData = dttData;
    
    [self setDelegate:self];
    [self setDataSource:self];
    
    //Every time the data is changing, we create new sections.
    self.dttSections = [[NSMutableArray alloc] init];
    self.dttIndexes = [[NSMutableArray alloc] init];
    
    if ([dttData count] > 0) {
        if (self.bWithSections) {
            int lCount = 0;
            NSString *strPrev = @"";
            // Loop over the dictionary and check when a new section begin.
            for (int i=0; i<[dttData count]; i++) {
                //Get the firsts chars of the title
                NSString *strCurrent = [(NSString *)[dttData getDataAtRow:i andDictionaryKey:self.strSectionByKeyName]  substringToIndex:self.lSectionTitleLength];
                if ([strPrev caseInsensitiveCompare:strCurrent] == NSOrderedSame) {
                    //the chars are equals to the previous, we increase the counter of rows found
                    lCount += 1;
                } else {
                    //the chars are equals to the previous, we complete the sections data
                    if (lCount > 0) {
                        [self.dttSections addObject:[self createDataForNewSection:strPrev withNumberOfElements:lCount atStartPosition:i - lCount]];
                        [self.dttIndexes addObject:strPrev];
                    }
                    
                    strPrev = strCurrent;
                    lCount = 1; //Start with 1 to count the current chars
                }
            }
            //Add the last section
            [self.dttSections addObject:[self createDataForNewSection:strPrev withNumberOfElements:lCount atStartPosition:[self.dttData count] - lCount]];
            [self.dttIndexes addObject:strPrev];
        }
    }
    
    [self reloadData];
}

#pragma mark - Public methods for the setup of UITableView
-(void)fillTableWithData:(NSArray *)tableData {
    [self fillTableWithData:tableData sectionsFromKey:@"" withTitleLength:0];
}

-(void)fillTableWithData:(NSArray *)tableData sectionsFromKey:(NSString *)keyName withTitleLength:(int)numberOfCharactes {
    self.strSectionByKeyName = keyName;
    self.lSectionTitleLength = numberOfCharactes;

    //The setter of dttData make all the work
    self.dttData = tableData;
}

#pragma mark - UITableView standard methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.bWithSections) {
         return [self.dttSections count];
    } else {
       return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bWithSections) {
        return [[self.dttSections getDataAtRow:section andDictionaryKey:@"Count"] MaelCInt];
    } else {
        return [self.dttData count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.dttIndexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString *)[self.dttSections getDataAtRow:section andDictionaryKey:@"TAG"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int lRow;
    
    if (self.bWithSections) {
        lRow = [[self.dttSections getDataAtRow:indexPath.section andDictionaryKey:@"Start"] MaelCInt] + indexPath.row;
    } else {
        lRow = indexPath.row;
    }
    
    // Call the Delegate and it pass the dictiornary of the UITableViewCell to generate.
    // The cell must be generate inside this call.
    return [self.MaelTableDelegate tableCreateCell:tableView usingData:[self.dttData objectAtIndex:lRow]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int lRow;
    
    if (self.bWithSections) {
        lRow = [[self.dttSections getDataAtRow:indexPath.section andDictionaryKey:@"Start"] MaelCInt] + indexPath.row;
    } else {
        lRow = indexPath.row;
    }
    
    // Call the Delegate and it pass the dictiornary of row touched.
    [self.MaelTableDelegate tableRowSelected:self selectedData:[self.dttData objectAtIndex:lRow]];
}

#pragma mark - Other features
-(NSDictionary *)createDataForNewSection:(NSString *)strSectionTitle withNumberOfElements:(int)lNum atStartPosition:(int)lStart {
    NSMutableDictionary *dicTmp = [[NSMutableDictionary alloc] init];
    [dicTmp setValue:strSectionTitle forKey:@"TAG"];
    [dicTmp setValue:[NSString stringWithFormat:@"%d", lNum] forKey:@"Count"];
    [dicTmp setValue:[NSString stringWithFormat:@"%d", lStart] forKey:@"Start"];
    return dicTmp;
}

@end

@implementation NSObject (MaelNSObject)
-(int)MaelCInt {
    return [((NSString *)self) intValue];
}
@end

@implementation NSMutableArray (MaelNSMutableArray)
// Return the value of the key of a specified dictionary
-(NSObject *)getDataAtRow:(int)nRow andDictionaryKey:(NSString *)strKeyName {
    if ([self count] < nRow || nRow < 0) return nil;
    
    return [((NSMutableDictionary *)[self objectAtIndex:nRow]) objectForKey:strKeyName];
}
@end
