//
//  FFSettingDebugTableViewController.m
//  FormularLib
//
//  Created by 인식 조 on 12. 12. 3..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFSettingDebugTableViewController.h"

@interface FFSettingDebugTableViewController ()

@end

@implementation FFSettingDebugTableViewController

@synthesize addressTextField = _addressTextField;
@synthesize portTextField = _portTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Debug"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.addressTextField.text forKey:@"DebugModeAddress"];
    [userDefaults setObject:self.portTextField.text forKey:@"DebugModePort"];
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *debugCell = @"FFSettingDebugCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:debugCell];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:debugCell];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"DebugMode";
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([userDefaults boolForKey:@"isDebugMode"]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            [cell setAccessoryView:switchView];
        }
    }
    
    else if (indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Address";
            
            self.addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(5,5,200,20)];
            [self.addressTextField setPlaceholder:@"address"];
            [self.addressTextField setKeyboardType:UIKeyboardTypeURL];
            [self.addressTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"DebugModeAddress"]];
            [cell setAccessoryView:self.addressTextField];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Port";
            self.portTextField = [[UITextField alloc] initWithFrame:CGRectMake(5,5,200,20)];
            [self.portTextField setPlaceholder:@"port"];
            [self.portTextField setKeyboardType:UIKeyboardTypeNumberPad];
            [self.portTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"DebugModePort"]];
            [cell setAccessoryView:self.portTextField];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - switch delegate
- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (switchControl.on) {
        [userDefaults setBool:YES forKey:@"isDebugMode"];
    } else {
        [userDefaults setBool:NO forKey:@"isDebugMode"];
    }
    [userDefaults synchronize];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
