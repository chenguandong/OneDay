//
//  NoteListTableViewVC.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/5.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "NoteListTableViewVC.h"
#import "NoteDBModel.h"
#import "HYWriteNoteNow.h"
#import "NoteListTableViewCell.h"
@interface NoteListTableViewVC ()

@property(nonatomic)NSMutableArray<NoteDBModel*>*noteArray;

@end

@implementation NoteListTableViewVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _noteArray = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.rowHeight = 100;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoteListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"NoteListTableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear: YES];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    if (_noteArray.count!=0) {
        [_noteArray removeAllObjects];
    }
    
    RLMResults *noteResult =  [NoteDBModel allObjects];
    
    for (NoteDBModel *noteModel in noteResult) {
        
        [_noteArray addObject:noteModel];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datesource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _noteArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteListTableViewCell"];

    NoteDBModel *noteModel = _noteArray[indexPath.row];
    
    cell.noteModel = noteModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NoteDBModel *noteModel = _noteArray[indexPath.row];
    
    HYWriteNoteNow *textVC = [[HYWriteNoteNow alloc]init];
    
    textVC.hidesBottomBarWhenPushed = YES;
    
    textVC.noteModel = noteModel;
    
    [self.navigationController pushViewController:textVC animated:YES];
}




 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     
     if (editingStyle == UITableViewCellEditingStyleDelete) {
     // Delete the row from the data source
        
         
         
         NoteDBModel *noteModel = _noteArray[indexPath.row];
         

         RLMRealm *realm = [RLMRealm defaultRealm];
         
         [realm beginWriteTransaction];
         
         [realm deleteObject:noteModel];
         
         [realm commitWriteTransaction];
         
         
         [_noteArray removeObject:noteModel];
         
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }
 


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
