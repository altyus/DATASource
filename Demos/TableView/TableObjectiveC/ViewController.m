#import "ViewController.h"

#import "DATAStack.h"
#import "DATASource.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface ViewController ()

@property (nonatomic, weak) DATAStack *dataStack;
@property (nonatomic, strong) DATASource *dataSource;

@end

@implementation ViewController

- (instancetype)initWithDataStack:(DATAStack *)dataStack
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;

    _dataStack = dataStack;

    return self;
}

- (DATASource *)dataSource
{
    if (_dataSource) return _dataSource;

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];

    _dataSource = [[DATASource alloc] initWithTableView:self.tableView
                                           fetchRequest:request
                                         cellIdentifier:CellIdentifier
                                            mainContext:self.dataStack.mainContext
                                          configuration:^(UITableViewCell *cell, NSManagedObject *item, NSIndexPath *indexPath) {
                                              cell.textLabel.text = [item valueForKey:@"name"];
                                          }];

    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

    self.view.backgroundColor = [UIColor greenColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];

    self.tableView.dataSource = self.dataSource;
}

- (void)addAction
{
    [self.dataStack performInNewBackgroundContext:^(NSManagedObjectContext *backgroundContext) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                                  inManagedObjectContext:backgroundContext];
        NSManagedObject *user = [[NSManagedObject alloc] initWithEntity:entity
                                         insertIntoManagedObjectContext:backgroundContext];
        [user setValue:@"The Name" forKey:@"name"];
        [backgroundContext save:nil];
    }];
}

@end
