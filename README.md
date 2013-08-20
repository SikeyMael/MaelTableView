MaelTableView
=============

An easy way to manage iOS UITableView and his sections.


How to use
==============

1) Add MaelTableView.h and MaelTableView.m in your project.

2) Import the .h file where do you use a UITableView: #import "MaelTableView.h"

3) Create an istance to MaelTableView as it will be a UITableView or in your xib\storyboard select the UITableView, in the Identity Ispector panel, under Class, choose MaelTableView

4) In your .h file add MaelTableViewDelegate: @interface YourClassName : BaseClassName <MaelTableViewDelegate>

5) To fill the UITableView you have 2 methods: 

  - -(void)fillTableWithData:(NSArray *)tableData;
  
  - -(void)fillTableWithData:(NSArray *)tableData sectionsFromKey:(NSString *)keyName withTitleLength:(int)numberOfCharactes;
  
 The first doesn't use the UITableView section.
 
 The second setup UITableView sections.
 
 NOTE: tableData must be a NSArray of NSDictionary. If you use sections, every dictioray must have the key settd by "sectionsFromKey"
 
6) In your .m file add the methods:

  - -(UITableViewCell *)tableCreateCell:(UITableView *)sender usingData:(NSDictionary *)currentRow;
  
  - -(void)tableRowSelected:(UITableView *)sender selectedData:(NSDictionary *)currentRow;
  
  The first allow the creation of UITableViewCell using dictionary from tableData, it's the same of: - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath.

  The second will be raised when the user touch a row.


