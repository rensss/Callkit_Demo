//
//  ViewController.m
//  CallerID
//
//  Created by Rzk on 2019/11/20.
//  Copyright © 2019 Rzk. All rights reserved.
//

#import "ViewController.h"
#import "CallDirectoryHandler.h"
#import <ContactsUI/ContactsUI.h>

@interface ViewController ()

@property (nonatomic, strong) UITextField *numberTextField; /**< 号码输入*/
@property (nonatomic, strong) UITextField *identifyTextField; /**< 标识*/

@property (nonatomic, strong) UIButton *addBlockBtn; /**< 添加按钮*/
@property (nonatomic, strong) UIButton *removeBlockBtn; /**< 移除Block*/

@property (nonatomic, strong) UIButton *addIdentityBtn; /**< 添加标记按钮*/
@property (nonatomic, strong) UIButton *removeIdentityBtn; /**< 移除标记*/

@property (nonatomic, strong) UITableView *tableView; /**< 列表*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 13.0, *)) {
        self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    [self.view addSubview:self.numberTextField];
    [self.numberTextField autoSetDimension:ALDimensionHeight toSize:35];
    [self.numberTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80];
    [self.numberTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    [self.numberTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
    
    [self.view addSubview:self.identifyTextField];
    [self.identifyTextField autoSetDimension:ALDimensionHeight toSize:35];
    [self.identifyTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    [self.identifyTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
    [self.identifyTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.numberTextField withOffset:15];
    
    [self.view addSubview:self.addBlockBtn];
    [self.addBlockBtn autoSetDimensionsToSize:CGSizeMake(130, 35)];
    [self.addBlockBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    [self.addBlockBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.identifyTextField withOffset:15];
    
    [self.view addSubview:self.removeBlockBtn];
    [self.removeBlockBtn autoSetDimensionsToSize:CGSizeMake(130, 35)];
    [self.removeBlockBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.addBlockBtn];
    [self.removeBlockBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.addBlockBtn withOffset:15];
    
    [self.view addSubview:self.addIdentityBtn];
    [self.addIdentityBtn autoSetDimensionsToSize:CGSizeMake(130, 35)];
    [self.addIdentityBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    [self.addIdentityBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addBlockBtn withOffset:15];
    
    [self.view addSubview:self.removeIdentityBtn];
    [self.removeIdentityBtn autoSetDimensionsToSize:CGSizeMake(130, 35)];
    [self.removeIdentityBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.addIdentityBtn];
    [self.removeIdentityBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.addIdentityBtn withOffset:15];
}

#pragma mark - func
- (NSArray *)contactsWithStore:(CNContactStore *)contactStore {
    NSArray *array;
    NSArray *keys = @[CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey,
        CNContactThumbnailImageDataKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey,
                CNContactBirthdayKey, CNContactPhoneNumbersKey];
    
    NSError *error;
    NSPredicate *predicate;
    NSArray *allContacts = [contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (CNContact *contact in allContacts) {
        [mArray addObjectsFromArray:[self contactsWithCNContact:contact]];
    }
    array = [mArray copy];
    return array;
}

- (NSMutableArray *)contactsWithCNContact:(CNContact *)contact {
    NSMutableArray *mArray = [NSMutableArray array];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^(\\+|00 )(\\d+) (.+)$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@"（）()+-  "];
    for (int i = 0; i < contact.phoneNumbers.count; i++) {
        NSString *phoneNumber = [[contact.phoneNumbers[i] value] stringValue];
        NSString *name = @"";
        if (contact.givenName.length > 0 && contact.familyName.length > 0) {
            name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
        } else if (contact.familyName.length > 0) {
            name = [contact.familyName copy];
        } else if (contact.givenName.length > 0) {
            name = [contact.givenName copy];
        }
        
        NSLog(@"---- phoneNumber:%@",phoneNumber);
        NSLog(@"---- name:%@",name);
        if ([name isEqualToString:@"黑名单"]) {
            NSLog(@"---- hei");
        }
        NSLog(@"---- \n%@",contact);

        [mArray addObject:contact];
    }
    return mArray;
}

#pragma mark - 事件
- (void)addBlockNumClick:(UIButton *)btn {
    
//    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//    CNContactStore *contactStore = [[CNContactStore alloc] init];
//    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"---- \n%@",[self contactsWithStore:contactStore]);
//        });
//    }];
//
//    return;
    
    NSLog(@"---- add Number:%@",self.numberTextField.text);
    if (self.numberTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写blockNumber" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    ContactModel *model = [ContactModel new];
    model.phoneNumber = self.numberTextField.text;
    [[FMDataBaseManager shareInstance] updateContact:model toTable:kUserBlockTabel with:^(BOOL result) {
        if (result) {
            [[CallDirectoryHandler shared] addBlockNumber:self.numberTextField.text complete:^(BOOL finish) {
                if (finish) {
                    NSLog(@"---- success");
                } else {
                    NSLog(@"---- failed");
                }
            }];
        } else {
            NSLog(@"---- db failed");
        }
    }];
}

- (void)removeBlockNumClick:(UIButton *)btn {
    NSLog(@"---- remove Number:%@",self.numberTextField.text);
    if (self.numberTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写blockNumber" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    ContactModel *model = [ContactModel new];
    model.phoneNumber = self.numberTextField.text;
    [[FMDataBaseManager shareInstance] removeContact:model inTable:kUserBlockTabel with:^(BOOL result) {
        if (result) {
            [[CallDirectoryHandler shared] removeBlockNumber:self.numberTextField.text complete:^(BOOL finish) {
                if (finish) {
                    NSLog(@"---- success");
                } else {
                    NSLog(@"---- failed");
                }
            }];
        } else {
            NSLog(@"---- db failed");
        }
    }];
}

- (void)addIdentifyClick:(UIButton *)btn {
    NSLog(@"---- add identify:%@",self.numberTextField.text);
    NSLog(@"---- identify:%@",self.identifyTextField.text);
    if (self.numberTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写identityNumber" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    if (self.identifyTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写identity" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    ContactModel *model = [ContactModel new];
    model.phoneNumber = self.numberTextField.text;
    model.identification = self.identifyTextField.text;
    [[FMDataBaseManager shareInstance] updateContact:model toTable:kUserIdentifyTabel with:^(BOOL result) {
        if (result) {
            [[CallDirectoryHandler shared] addIdentification:self.identifyTextField.text toNumber:self.numberTextField.text complete:^(BOOL finish) {
                if (finish) {
                    NSLog(@"---- success");
                } else {
                    NSLog(@"---- failed");
                }
            }];
        } else {
            NSLog(@"---- db failed");
        }
    }];
}

- (void)removeIdentifyClick:(UIButton *)btn {
    NSLog(@"---- remove identify:%@",self.numberTextField.text);
    if (self.numberTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写identityNumber" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    ContactModel *model = [ContactModel new];
    model.phoneNumber = self.numberTextField.text;
    [[FMDataBaseManager shareInstance] removeContact:model inTable:kUserIdentifyTabel with:^(BOOL result) {
        if (result) {
            [[CallDirectoryHandler shared] removeIdentificationForNumber:self.numberTextField.text complete:^(BOOL finish) {
                if (finish) {
                    NSLog(@"---- success");
                } else {
                    NSLog(@"---- failed");
                }
            }];
        } else {
            NSLog(@"---- db failed");
        }
    }];
}

#pragma mark - 代理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - setting

#pragma mark - getting
- (UITextField *)numberTextField {
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.layer.borderWidth = 1;
        _numberTextField.layer.borderColor = [UIColor systemGrayColor].CGColor;
        _numberTextField.placeholder = @"number";
        _numberTextField.textColor = [UIColor blackColor];
        _numberTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _numberTextField;
}

- (UITextField *)identifyTextField {
    if (!_identifyTextField) {
        _identifyTextField = [[UITextField alloc] init];
        _identifyTextField.layer.borderWidth = 1;
        _identifyTextField.layer.borderColor = [UIColor systemGrayColor].CGColor;
        _identifyTextField.placeholder = @"identify";
        _identifyTextField.textColor = [UIColor blackColor];
    }
    return _identifyTextField;
}

- (UIButton *)addBlockBtn {
    if (!_addBlockBtn) {
        _addBlockBtn = [[UIButton alloc] init];
        _addBlockBtn.layer.borderWidth = 1;
        _addBlockBtn.layer.borderColor = [UIColor systemGrayColor].CGColor;
        [_addBlockBtn setTitle:@"addBlock" forState:UIControlStateNormal];
        [_addBlockBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addBlockBtn addTarget:self action:@selector(addBlockNumClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBlockBtn;
}

- (UIButton *)removeBlockBtn {
    if (!_removeBlockBtn) {
        _removeBlockBtn = [[UIButton alloc] init];
        _removeBlockBtn.layer.borderWidth = 1;
        _removeBlockBtn.layer.borderColor = [UIColor systemGrayColor].CGColor;
        [_removeBlockBtn setTitle:@"removeBlock" forState:UIControlStateNormal];
        [_removeBlockBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_removeBlockBtn addTarget:self action:@selector(removeBlockNumClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeBlockBtn;
}

- (UIButton *)addIdentityBtn {
    if (!_addIdentityBtn) {
        _addIdentityBtn = [[UIButton alloc] init];
        _addIdentityBtn.layer.borderWidth = 1;
        _addIdentityBtn.layer.borderColor = [UIColor systemGrayColor].CGColor;
        [_addIdentityBtn setTitle:@"addIdentity" forState:UIControlStateNormal];
        [_addIdentityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addIdentityBtn addTarget:self action:@selector(addIdentifyClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addIdentityBtn;
}

- (UIButton *)removeIdentityBtn {
    if (!_removeIdentityBtn) {
        _removeIdentityBtn = [[UIButton alloc] init];
        _removeIdentityBtn.layer.borderWidth = 1;
        _removeIdentityBtn.layer.borderColor = [UIColor systemGrayColor].CGColor;
        [_removeIdentityBtn setTitle:@"removeIdentity" forState:UIControlStateNormal];
        [_removeIdentityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_removeIdentityBtn addTarget:self action:@selector(removeIdentifyClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeIdentityBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

@end
