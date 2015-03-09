# ThreadSafeSingleton
线程安全单例
==============
前一段时间因为工程中大量用的GCD，所以研究了一下，其中从effective-oc这本书中收获颇多。
所以自己就模仿写了一个线程安全单例。

其实从视野放大写，可以把这个单例看做一个功能块内核。
即主要拥有 “写入” 和 “读出”两个功能。

多线程编程中，我们希望读入的时候一定不能同时存在写入，否则可能读出的数据和预想的有差错。
同时又希望写入时又同时只能执行一个写入。

所以最终设计规则如下：
为了充分利用cup，写入和读出操作全部放入一个并发队列中。
但是注意：
虽然是并发队列，为了保证写 和 读操作的有序性，可以并发的读，但是绝对写的时候必须保证串行。

* 读操作如下：
```objc
- (NSString *)name {
    __block NSString *mName = nil;
    dispatch_sync(self.maquanQueue, ^{
        mName = _name;
    });
    return mName;
}
```
在maquanQueue并发队列中，同步并发读取数据。

* 写操作如下：
```
- (void)setName:(NSString *)name {
    dispatch_barrier_async(self.maquanQueue, ^{
        if (name != _name) {
            [_name release];
            _name = [name retain];
            sleep(3);
        }
    });
}
```
在maquanQueue并发队列中，用栅栏异步进行写操作。
栅栏dispatch_barrier_async保证写操作绝对原子性，并且此时并发队列只能执行这一个任务


理解浅薄，轻喷。
