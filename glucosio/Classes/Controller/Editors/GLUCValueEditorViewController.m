#import <Realm/RLMRealm.h>
#import "GLUCValueEditorViewController.h"
#import "GLUCAppearanceController.h"
#import "UIColor+GLUCAdditions.h"

@implementation GLUCValueEditorViewController {

}

- (void) enableOrDisableSaveButton:(NSString *)forValue {
    NSNumber *intVal = @([forValue intValue]);
    self.saveButton.enabled = [self.editedObject validateValue:&intVal forKey:self.editedProperty error:NULL];
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [self cancelButtonItem];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField setFont:[GLUCAppearanceController valueEditorTextFieldFont]];
    [self.textField setTextColor:[UIColor glucosio_pink]];

    
    NSString *currentValue = [self.editedObject displayValueForKey:self.editedProperty];
    
    id val = [self.editedObject valueForKey:self.editedProperty];
    if ([[val class] isSubclassOfClass:[NSNumber class]]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
    [self enableOrDisableSaveButton:currentValue];
    
    if (self.textField) {
        self.textField.text = currentValue;
        self.textField.delegate = self;
        
        [self.textField becomeFirstResponder];
    }
    
}

- (IBAction) textChanged:(UITextField *)sender {
    [self enableOrDisableSaveButton:sender.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self enableOrDisableSaveButton:textField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL retVal = YES;

    [self enableOrDisableSaveButton:[textField.text stringByReplacingCharactersInRange:range withString:string]];

    return retVal;
}

- (IBAction) save:(UIButton *)sender {
    NSNumber *newVal = [NSNumber numberWithFloat:[self.textField.text doubleValue]];
    
    if (newVal) {
        if (self.editedProperty && self.editedProperty.length && self.editedObject) {
            [[self.editedObject realm] beginWriteTransaction];
            [self.editedObject setValue:newVal forKey:self.editedProperty];
            [[self.editedObject realm] commitWriteTransaction];
        }
    }
    
    [super save:sender];
}

@end
