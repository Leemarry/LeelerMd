![image-20240906110506448](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20240906110506448.png)

```
uploadwebCloudLists
```

docker run -d -p 9009:9000 --name=portainer --restart=always -v F:\docker\dockerc\portainer\run\docker.sock:/var/run/docker.sock -v F:\docker\dockerc\portainer\data:/data portainer/portainer



```
vi /etc/selinux/config
将SELINUX=enforcing改为SELINUX=disabled
然后 reboot重启系统


docker run -d --network=my-custom-network --name cloud-container -p 8086:8085 0a47a531c176
```



有return 与没有 区别很大

```javascript
async function async1() {
  console.log('async1 start');
  await async2();
  console.log('async1 end');
}
 
async function async2() {
  console.log('async2 start');
  return new Promise((resolve, reject) => {
    resolve();
    console.log('async2 promise');
  })
}
 
console.log('script start');
 
setTimeout(function() {
  console.log('setTimeout');
}, 0);
 
async1();

new Promise(function(resolve) {
  console.log('promise1');
  resolve();
}).then(function() {
  console.log('promise2');
}).then(function() {
  console.log('promise3');
});
 
console.log('script end')
// script start  async1 start  async2 start  async2 promise   promise1  script end  
```

