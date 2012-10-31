//
//  ProjectSessionCell.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectSessionCell.h"
#import "Project.h"
#import "ProjectSession+Create.h"
#import "UIView+Frame.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectSessionCell()
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UIView *buttonHolder;
@property (weak, nonatomic) IBOutlet UIView *cellBackground;
@end

@implementation ProjectSessionCell

- (void)setupCell:(ProjectSession *)session {
    
    self.session = session;
    
    self.noteText.text = session.sessionNote;
    self.sessionTitleLabel.text = session.projectName;
    self.sessionTimeLabel.text = session.sessionTime;
    
    self.noteText.font = CELL_NOTE_FONT;
    self.sessionTimeLabel.font = CELL_TIME_FONT;
    self.sessionTitleLabel.font = CELL_TITLE_FONT;
    
    self.cellBackground.layer.cornerRadius = 5;
    
    //postavi novi frame za title
    self.sessionTitleLabel.frame = CGRectFromString(session.titleFrame);
    self.sessionTimeLabel.frame = CGRectFromString(session.timeFrame);
    self.noteText.frame = CGRectFromString(session.noteFrame);
    self.buttonHolder.frame = CGRectFromString(session.buttonFrame);
    self.cellBackground.frame = CGRectFromString(session.holderFrame);
    
}

- (IBAction)doEdit:(id)sender {
    [self.delegate cellWithModelWillEdit:self.session];
}

- (IBAction)doDelete:(id)sender {
    [self.delegate cellWithModelWillDelete:self.session];
}

@end
