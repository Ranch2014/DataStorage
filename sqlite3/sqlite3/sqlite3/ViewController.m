//
//  ViewController.m
//  sqlite3
//
//  Created by 焦相如 on 6/1/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "ViewController.h"

#define DBNAME    @"personinfo.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDB];
    [self createTable];
//    [self insertData];
    [self deleteSome];
    [self query];
}

/** 初始化数据库 */
- (void)initializeDB {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *databasePath = [documents stringByAppendingString:DBNAME];
//    NSLog(@"databasePath--%@", databasePath);
    
    // 打开数据库（如果数据库文件不存在，sqlite3_open 函数会自动创建数据库文件）
    if (sqlite3_open([databasePath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}

/** 建表 */
- (void)createTable {
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    [self execSql:sqlCreateTable];
}

/** 删除数据 */
- (void)deleteSome {
    NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID > 2", TABLENAME];
    [self execSql:delete];
}

/** 执行 SQL 语句 */
- (void)execSql:(NSString *)sql {
    char *err;
    // 将OC字符串 转成 C语言字符串
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作失败");
    }
}

/** 插入数据 */
- (void)insertData {
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, @"张三", @"23", @"西城区"];
    
    NSString *sql2 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, @"老六", @"20", @"东城区"];
    [self execSql:sql1];
    [self execSql:sql2];
}

/** 查询 */
- (void)query {
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int identity = sqlite3_column_int(statement, 0);
            
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc] initWithUTF8String:name];
            
            int age = sqlite3_column_int(statement, 2);
            
            char *address = (char*)sqlite3_column_text(statement, 3);
            NSString *nsAddressStr = [[NSString alloc] initWithUTF8String:address];
            
            NSLog(@"id:%d name:%@  age:%d  address:%@", identity, nsNameStr, age, nsAddressStr);
        }
    }
    sqlite3_close(db);
}

@end
