#SQLite

##SQLite 简介
- SQLite 是一款轻型的嵌入式数据库
- 占用资源非常的低，在嵌入式设备中，可能只需要几百K的内存就够了
- 它的处理速度比 Mysql、PostgreSQL 还快

数据库（Database）是按照数据结构来组织、存储和管理数据的仓库。常用的关系型数据库:  

- PC端: Oracle、MySQL、SQL Server、Access、DB2、Sybase
- 嵌入式/移动端: SQLite

##常用 SQL 语句
- 增删改查

``` sql
create table t_student (id integer, name text, age inetger, score real) ; //建表

select * from t_student where age > 10;  //条件查询
select * from t_student limit 4, 8; //可以理解为：跳过最前面4条语句，然后取8条记录

insert into t_student (name, age) values (‘mj’, 10); //插入

update t_student set age = 5 where age > 10 and name != ‘jack’; //修改 

delete from t_student where age <=10 or age >30;
// 删表 : drop table if exists 表名;
// 删除表数据 ：delete from t_student;
```

- limit 常用来做分页查询

``` sql
第1页：limit 0, 5
第2页：limit 5, 5
第3页：limit 10, 5
…
第n页：limit 5*(n-1), 5

//取最前面的7条记录
select * from t_student limit 7;
//相当于select * from t_student limit 0, 7;
```

- 约束

建表时可以给特定的字段设置一些约束条件，常见的约束有：

``` sql
not null：规定字段的值不能为null
unique ：规定字段的值必须唯一
default ：指定字段的默认值
（建议：尽量给字段设定严格的约束，以保证数据的规范性）

// 示例代码：name 字段不能为 null，并且唯一; age 字段不能为 null，并且默认为1
create table t_student (id integer, name text not null unique, age integer not null default 1);
```

- 主键约束

``` sql
// integer 类型的 id 作为 t_student 表的主键
create table t_student (id integer primary key, name text, age integer);

//主键字段：只要声明为 primary key，就说明是一个主键字段；主键字段默认就包含了 not null 和 unique 两个约束
//如果想要让主键自动增长（必须是integer类型），应该增加 autoincrement
create table t_student (id integer primary key autoincrement, name text, age integer);
```

- 外键约束

	- 利用外键约束可以用来建立表与表之间的联系
	- 外键的一般情况是：一张表 (副表) 的某个字段，引用着另一张表 (主表) 的主键字段
	- 被约束的表称为副表，约束其他表的称为主表，外键设置在副表上的！

``` sql
// 新建一个外键
create table t_student (id integer primary key autoincrement, name text, age integer, class_idinteger, constraint fk_student_class foreignkey(class_id) references t_class(id));
```

- SQLite 数据库字段类型

``` sql
integer : 整型值
real : 浮点值
text : 文本字符串
blob : 二进制数据（比如文件）
```

##常用操作
- 打开数据库（如果数据库文件不存在，sqlite3_open函数会自动创建数据库文件）

``` Objective-C
int sqlite3_open(
    const char *filename,   // 数据库的文件路径
    sqlite3 **ppDb          // 数据库实例
);
```
- 执行任何SQL语句

``` c
int sqlite3_exec(
    sqlite3*,                                  // 一个打开的数据库实例
    const char *sql,                           // 需要执行的SQL语句
    int (*callback)(void*,int,char**,char**),  // SQL语句执行完毕后的回调
    void *,                                    // 回调函数的第1个参数
    char **errmsg                              // 错误信息
);
```

- 检查SQL语句的合法性（查询前的准备）

```c
int sqlite3_prepare_v2(
    sqlite3 *db,            // 数据库实例
    const char *zSql,       // 需要检查的SQL语句
    int nByte,              // SQL语句的最大字节长度
    sqlite3_stmt **ppStmt,  // sqlite3_stmt实例，用来获得数据库数据
    const char **pzTail
);
```

- 查询一行数据

``` c
int sqlite3_step(sqlite3_stmt*); // 如果查询到一行数据，就会返回SQLITE_ROW
```

- 利用 `sqlite3_stmt` 获得某一字段的值（字段的下标从0开始）

``` c
double sqlite3_column_double(sqlite3_stmt*, int iCol);  // 浮点数据

int sqlite3_column_int(sqlite3_stmt*, int iCol); // 整型数据

sqlite3_int64 sqlite3_column_int64(sqlite3_stmt*, int iCol); // 长整型数据

const void *sqlite3_column_blob(sqlite3_stmt*, int iCol); // 二进制文本数据

const unsigned char *sqlite3_column_text(sqlite3_stmt*, int iCol);  // 字符串数据
```

##Xcode 中使用方法

需要添加 `libsqlite3.0.tbd` 库，并在使用的文件中导入:

``` Objective-C
#import <sqlite3.h>
```

详细运用见代码。



主要参考：  
[http://www.jianshu.com/p/24aa120ac998](http://www.jianshu.com/p/24aa120ac998)

[http://blog.csdn.net/totogo2010/article/details/7702207](http://blog.csdn.net/totogo2010/article/details/7702207)