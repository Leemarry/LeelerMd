



# Http_request 目录

## 一、XMLHttpRequest



在使用 Fetch API 进行网络请求时，原生的 Fetch API 并不直接支持获取下载进度的功能，因为 Fetch API 主要是基于 Promise 的，它主要关注于请求的成功或失败，以及响应数据的处理，而不直接处理像进度跟踪这样的底层细节。

不过，你可以通过一些技巧或方法间接实现下载进度的跟踪。以下是一些常用的方法：

### 1. 使用 `XMLHttpRequest`

虽然 Fetch API 较为现代，但如果你需要跟踪下载进度，`XMLHttpRequest` 可能是一个更好的选择。`XMLHttpRequest` 提供了 `onprogress` 事件，可以用来追踪下载进度。

```javascript
var xhr = new XMLHttpRequest();
xhr.open('GET', 'your-file-url', true);
xhr.responseType = 'blob';

xhr.onprogress = function (e) {
    if (e.lengthComputable) {
        var percentComplete = (e.loaded / e.total) * 100;
        console.log(percentComplete + '% downloaded');
    }
};

xhr.onload = function () {
    if (this.status == 200) {
        // 处理响应数据
    }
};

xhr.send();
```
在上述代码中，我们创建了一个 XMLHttpRequest 对象，并设置了 onprogress 事件处理函数。在该函数中，通过判断 e.lengthComputable 是否为真，来确定是否可以计算下载进度。如果可以计算，则通过 e.loaded 和 e.total 计算出已下载的百分比，并将其打印到控制台

### 2.`XMLHttpRequest` 的进一步封装

```javascript
   xhrToDownload(options, onProgress, onSuccess, onError) {
            return new Promise((resolve, reject) => {
                const xhr = new XMLHttpRequest();
                xhr.open(options.method || 'GET', options.url);
                xhr.responseType = options.responseType || 'blob';

                xhr.onprogress = function(e) {
                    if (e.lengthComputable) {
                        const progress = (e.loaded / e.total) * 100;
                        onProgress && onProgress(progress);
                    }
                };

                xhr.onload = function(e) {
                    if (xhr.status === 200) {
                        // onSuccess && onSuccess(xhr.response);
                        console.log('上传成功', xhr);
                        resolve({ status: xhr.status, data: xhr.response })
                    } else {
                        onError && onError(xhr.statusText);
                        reject({ status: xhr.status, data: xhr.statusText }); // 拒绝 Promise
                    }
                }
                xhr.onerror = function(e) {
                    onError && onError(xhr.statusText);
                    reject({ status: xhr.status, data: xhr.statusText }); // 拒绝 Promise
                };
                xhr.send();
            });
        },
```

这个示例进一步封装了 `XMLHttpRequest`，使其可以返回一个 Promise，方便进行异步处理。

### 3. 创建 `a` 标签下载



```
        downloadFile(blob, fileName = '2.mp4') {
            // 创建a 标签
            const a = document.createElement('a');
            const blobUrl = URL.createObjectURL(blob);
            a.setAttribute('href', blobUrl);
            a.setAttribute('download', fileName);
            a.style.display = 'none';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(blobUrl)
        },
```

使用实例：

```
    async downloadVideo(row) {
            const url = row.path;
            if (!url) {
                return;
            }
            var index = this.tableData.findIndex(item => item.id === row.id);
            // 使用示例
            const response = await this.xhrToDownload({ url: url }, (progress) => {
                console.log('Download progress:', progress);
                if (index !== -1) {
                    this.tableData[index].downLoadProgress = progress
                }
            }, (res) => {
                // 这里处理 Blob，例如保存到 IndexedDB、FileSystem API 或其他
                console.log('Download successful:', res);
                // 如果你确实需要下载文件，可以在这里创建 <a> 标签并触发点击
            }, (error) => {
                console.error('Download failed:', error);
            })
            if (response && response.status === 200) {
                this.downloadFile(response.data)
            }
        },
```



## 二、 Fetch API



### 1. 使用 Fetch API

- **链式调用**：

  ```javascript
          fetch(url).then(res => {
              return res.blob()
          }).then(res => {
              console.log('res', res);
          })
  ```

  

- **async - await 语法糖**：

```
        // const response = await fetch(url)
        // const blod = await response.blob()
```



### 2. 使用 Stream API 和 ReadableStream

Fetch API 支持响应体作为 `ReadableStream`，但直接使用它来跟踪进度可能不太直观。不过，你可以通过监听流的读取操作来大致估计进度（虽然这通常不如 `XMLHttpRequest` 那样精确）。

```javascript
    //your_file_url fetch('http://127.0.0.1:456/proxy/DJI_0003.MP4')
    fetch('http://127.0.0.1:456/proxy/DJI_0003.MP4').then(response=>{
        console.log(response);
        const reader = response.body.getReader() //  ReadableStream
        const contentLength = response.headers.get('content-length')
        let readTotal = 0
        if(!contentLength){
            console.log('无法获取进度');
            return
        }
        const sizeTotal = parseInt(contentLength)
        const chunks =[]

        function read(){
            reader.read().then(({done,value})=>{
                if(done){
                    console.log('下载完成');
                    const type = response.headers.get('content-type')
                    const blob = new Blob(chunks,{type})
                    return
                }
                readTotal += value.length
                const progress = Math.ceil(readTotal/sizeTotal*100)
                console.log('下载进度：',progress);
                chunks.push(value)

                read()
            })
        }
        read()

    })

```

**注意**：上面的代码示例并不直接计算下载进度，因为 `ReadableStream` API 并不直接提供总大小信息（除非你在响应头中通过 `Content-Length` 获取）。你需要有一个方式来获取文件的总大小，以便能够计算进度。

### 3. 使用fetch下载并获取进度

```
简单获取下载进度
        fetchToDownlod(url, options, onProgress, onSuccess, onError) {
            try {
                // eslint-disable-next-line no-async-promise-executor
                return new Promise(async(resolve, reject) => {
                    const response = await fetch(url, options);
                    const reader = response.body.getReader();
                    // Step 2：获得总长度（length）
                    const contentLength = +response.headers.get('Content-Length');
                    console.log('contentLength', contentLength);
                    // Step 3：读取数据
                    let receivedLength = 0; // 当前接收到了这么多字节
                    const chunks = []; // 接收到的二进制块的数组（包括 body）

                    // eslint-disable-next-line no-constant-condition
                    while (true) {
                        const { done, value } = await reader.read();
                        if (done) {
                            // 如果没有更多的数据可读，则退出循环
                            break;
                        }
                        chunks.push(value);
                        receivedLength += value.length;
                        const progress = Math.round(receivedLength / contentLength * 100);
                        onProgress && onProgress(progress);
                    }
                    // 将响应体转换为 Blob 对象
                    const blob = new Blob(chunks, { type: 'application/octet-stream' });
                    if (response.status === 200) {
                        resolve({ status: response.status, blob });
                    }
                    if (response.status === 404) {
                        reject({ status: response.status, blob });
                    }
                });
            } catch (err) {
                console.log('err', err);
                return Promise.reject(err);
            }
        },
```

调用实例：

```
       async downloadVideo(row) {
            const url = row.path;
            if (!url) {
                return;
            }
            let fileName = 'text.mp4'
            const lastIndex = url.lastIndexOf('/');
            if (lastIndex !== -1) {
                fileName = url.substring(lastIndex + 1);
            }
            var index = this.tableData.findIndex(item => item.id === row.id);
            const options = {
                method: 'GET', // *GET, POST, PUT, DELETE, etc.
                mode: 'cors', // no-cors, *cors, same-origin
                cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
                credentials: 'same-origin', // include, *same-origin, omit
                responseType: 'blob', //重要代码
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Credentials': true,
                headers: {
                    'Content-Type': 'application/json'
                }
            }

            const res = await this.fetchToDownlod(url, options, (progress) => {
                // console.log('Download progress:', progress);
                if (index !== -1) {
                    this.tableData[index].downLoadProgress = progress
                }
            })
            console.log('res', res);
            if (!res || res.status !== 200) {
                return this.$message.error('下载失败')
            }
            this.downloadFile(res.blob, fileName)
        },
```



### 结论

如果你的应用需要精确地跟踪下载进度，并且你的环境允许，使用 `XMLHttpRequest` 可能是最直接和简单的方法。如果你正在寻找更现代的方法，并可以接受一些复杂性，你可以考虑使用 Service Workers 或 Stream API 来实现类似的功能。