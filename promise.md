









![image-20240908134145781](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908134145781.png)![image-20240908134436749](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908134436749.png)

![image-20240908134316770](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908134316770.png)



在 JavaScript 中，当你尝试在一个普通函数（非 `async` 函数）的返回值上调用 `.then()` 方法时，会遇到问题，因为这个返回值（在你的例子中是数字 `5`）并不是一个 `Promise` 对象。`.then()` 方法是 `Promise` 对象的一个方法，用于指定当 `Promise` 成功解决（fulfilled）或拒绝（rejected）时应该执行的操作。

在你的例子中，`p()` 函数直接返回了一个数字 `5`，而不是一个 `Promise`。因此，当你尝试调用 `p().then(...)` 时，JavaScript 会抛出一个错误，因为数字 `5` 没有 `.then()` 方法。

具体来说，错误可能类似于：

```
TypeError: p(...).then is not a function
```

如果你希望使用 `.then()` 方法来处理异步操作的结果，你需要确保你的函数返回一个 `Promise`。以下是一个修改后的例子，其中 `p` 函数现在是一个 `async` 函数，并且它返回一个解析为数字 `5` 的 `Promise`：

```javascript
async function p() {
  return 5; // 注意：虽然这里直接返回了数字5，但async函数会隐式地将返回值包装成一个已解决的Promise
}

p().then(res => console.log(res)); // 输出: 5
```

在这个修改后的例子中，`p()` 函数是一个 `async` 函数，它隐式地将其返回值（在这个例子中是数字 `5`）包装在一个 `Promise` 中。因此，你可以安全地在其返回值上调用 `.then()` 方法，并且 `.then()` 方法中的回调函数会接收到数字 `5` 作为参数。



**重点***

```
async  function async1 () {
  console.log('async1 start');
  await  new  Promise(resolve => {
    console.log('promise1')
  })
  console.log('async1 success');
  return 'async1 end'
}
console.log('srcipt start')
async1().then(res => console.log(res))
console.log('srcipt end')
```



![image-20240908165705513](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908165705513.png)



```
async  function async1 () {
  console.log('async1 start');
  await  new  Promise(resolve => {
    console.log('promise1')
    resolve('promise1 resolve')
  }).then(res => console.log(res))
  console.log('async1 success');
  return 'async1 end'
}
console.log('srcipt start')
async1().then(res => console.log(res))
console.log('srcipt end')
```

![image-20240908170059673](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908170059673.png)

可能有返回值但是是reject 怎么弄  ？

```
async  function async1 () {
  await async2();
  console.log('async1');
  return  'async1 success'
}
async  function async2 () {
  return  new  Promise((resolve, reject) => {
    console.log('async2')
    reject('error')
  })
}
async1().then(res => console.log(res))
```

![image-20240908170511795](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908170511795.png)

```javascript
async function async1 () {
  console.log('async1');
  throw  new  Error('error!!!')
  return 'async1 success'
}
async1().then(res => console.log(res))
```

使用catch

```
async  function async1 () {
  await async2();
  console.log('async1');
  return  'async1 success'
}
async  function async2 () {
  return  new  Promise((resolve, reject) => 
    console.log('async2')
    reject('error')
  })
}
async1().then(res => console.log(res)).catch((err)=>{
  console.log(err)
})
```



```javascript
async  function async1 () {
 try{
  await async2();
 }catch(e){
  console.log(e);
 }
  console.log('async1');
  return  'async1 success'
}
async  function async2 () {
  return  new  Promise((resolve, reject) => {
    console.log('async2')
    reject('error')
  })
}
async1().then(res => console.log(res))
```



```javascript
async  function async1 () {
    try{
        await async2();
    }catch(e){
        console.log(e);
    }
    console.log('async1');
    return  'async1 success'
}
async  function async2 () {
    return  new  Promise((resolve, reject) => {
        console.log('async2')
        reject('error')
    })
}
async1().then(res => console.log(res))
```

# promise 穿透 

[来45道Promise面试题一次爽到底(1.1w字用心整理)-腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1760585)

##### **3.8 题目八**

```javascript
Promise.resolve(1)
  .then(2)
  .then(Promise.resolve(3))
  .then(console.log)
```

![image-20240908181931258](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908181931258.png)

##### **7.2 题目二**

**7.promise p打印的思考 **

```javascript
  const p1 = new  Promise((resolve) => {
    setTimeout(() => {
      resolve('resolve3');
      console.log('timer1')
    }, 0)
    console.log(p1)
    resolve('resovle1');
    resolve('resolve2');

  })
```

在 JavaScript 中，变量在声明之前不能被访问。在你的代码中，你在定义`p1`的同时尝试访问它，这是不允许的。

在`const p1 = new Promise(...)`这一行，`p1`正在被定义，而在定义完成之前，你不能在初始化表达式内部使用`p1`。你应该将`console.log(p1)`放在`p1`已经完全初始化之后的位置，比如在`.then()`方法中或者其他异步操作完成后的回调中。

浏览器控制台：

![image-20240908195121332](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908195121332.png)

```javascript
  const p1 = new  Promise((resolve) => {
    setTimeout(() => {
      resolve('resolve3');
      console.log('timer1')
     
    }, 0)
    resolve('resovle1');
    resolve('resolve2');

  }).then(res => {
    console.log(res)
    console.log(p1)
  })
  #resovle1
  #Promise { <pending> }
  #timer1
```



![image-20240908194838727](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908194838727.png)

1

![image-20240908195531711](https://image-1302217890.cos.ap-beijing.myqcloud.com/image-20240908195531711.png)

如果没有then 

```javascript
let p = new  Promise((resolve, reject) => {
  console.log(7);
  setTimeout(() => {
      resolve(6);
      console.log(p)
  }, 0)
  resolve(1);
}) 
# Promise {<fulfilled>: 1}
```

#####  8.0  **状态吸收**

```
const p1 = new Promise(resolve=>{
    resolve()
})
const p2 = new Promise(resolve=>{
    resolve(p1)
})

console.log(p1);
console.log(p2)
```

