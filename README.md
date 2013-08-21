MaelTableView
=============

An easy way to manage iOS UITableView and his sections.

This class inherit from UITableView and it automatically manage calls from UITableViewDelegate.



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



Example
=======


ViewController.h


    #import <UIKit/UIKit.h>
    #import "MaelTableView.h"

    @interface ViewController : UIViewController <MaelTableViewDelegate>
    @property (weak, nonatomic) IBOutlet MaelTableView *myTableView;
    @end
    
    
    
ViewController.m


    #import "ViewController.h"

    @implementation ViewController
    -(void)viewDidLoad
    {
        [super viewDidLoad];

        // Setup tableData as NSArray of NSDictiorany
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setValue:@"Apple" forKey:@"name"];
        [dict1 setValue:@"iOs" forKey:@"platform"];
    
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
        [dict2 setValue:@"Google" forKey:@"name"];
        [dict2 setValue:@"Android" forKey:@"platform"];
    
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
        [dict3 setValue:@"Microsoft" forKey:@"name"];
        [dict3 setValue:@"Windows" forKey:@"platform"];
    
        NSArray *tableData = [[NSArray alloc] initWithObjects:dict1, dict2, dict3, nil];
        
        // set Delegate and fill the UITableView with NSArray
        self.myTableView.MaelTableDelegate = self;
        [self.myTableView fillTableWithData:tableData];
    }

    //How cell will appear
    -(UITableViewCell *)tableCreateCell:(UITableView *)sender usingData:(NSDictionary *)currentRow {
        UITableViewCell *cell = [sender dequeueReusableCellWithIdentifier:@"myCell"];
        cell.textLabel.text = [currentRow objectForKey:@"platform"];
        cell.detailTextLabel.text = [currentRow objectForKey:@"name"];

        return cell;
    }

    //A row was touched
    -(void)tableRowSelected:(UITableView *)sender selectedData:(NSDictionary *)currentRow {
        NSLog(@"Touched %@", [currentRow objectForKey:@"name"]);
    }
    @end





