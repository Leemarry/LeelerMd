likai

![image-20240913150700836](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20240913150700836.png)



![image-20240914101357741](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20240914101357741.png)



```
起飞 1100  对的上 
降落  1103
返航  1102


前后左右 开源


'点击开始缩放 -'" class="blackCircleButton" icon="el-icon-minus" @click="doCommand(1171, 0, 3, 0, 0)">
```



```
fz2j0h3sgi1j6

x3o8dlf4i44
```
asss  389db664123f48baab90d31bea123b12    wh001



```
import axios from 'axios'

var getRouter //用来获取后台拿到的路由

router.beforeEach((to, from, next) => {
  if (!getRouter) {//不加这个判断，路由会陷入死循环
    if (!getObjArr('router')) {
      axios.get('https://www.easy-mock.com/mock/5a5da330d9b48c260cb42ca8/example/antrouter').then(res => {
        getRouter = res.data.data.router//后台拿到路由
        saveObjArr('router', getRouter) //存储路由到localStorage

        routerGo(to, next)//执行路由跳转方法
      })
    } else {//从localStorage拿到了路由
      getRouter = getObjArr('router')//拿到路由
      routerGo(to, next)
    }
  } else {
    next()
  }

})


function routerGo(to, next) {
  getRouter = filterAsyncRouter(getRouter) //过滤路由
  router.addRoutes(getRouter) //动态添加路由
  global.antRouter = getRouter //将路由数据传递给全局变量，做侧边栏菜单渲染工作
  next({ ...to, replace: true })
}

function saveObjArr(name, data) { //localStorage 存储数组对象的方法
  localStorage.setItem(name, JSON.stringify(data))
}

function getObjArr(name) { //localStorage 获取数组对象的方法
  return JSON.parse(window.localStorage.getItem(name));

}

```





// 含有 开源无人机指令 不清楚有没有  待测试

```
        submitBeforeDoCommand() {
            this.uavDoVisible = false;
            // 1101,0,0,0,0,10
            // this.doCommand(command, parm1, parm2, parm3, parm4, timeout)
            // this.uavlist
            // for (let index = 0; index < this.uavlist.length; index++) {
            //     const element = array[index];
            //     this.uavsdoCommand(1102,0,0,0,0,10)
            // }
            this.uavsdoCommand(1101, 0, 0, 0, 0, 8)
        },
```



```


```

不是dev

```



```



```



```

