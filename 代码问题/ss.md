

是否使用当前设置的高度为起飞点海拔高度

```
                this.$store.commit('settings/setDefaultUavIndex', index)
                            'defaultUavIndex',
                this.$store.commit('settings/setDefaultHiveIndex', 0)
```

wpml

![image-20241023104711792](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241023104711792.png)

![image-20241023104156240](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241023104156240.png)

![image-20241023103137989](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241023103137989.png)

relativeToStartPoint



wps_use_this_home_alt_abs 没有用到

![image-20241023105525599](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241023105525599.png)

```
placemark.addElement("wpml:executeHeight").addText(String.valueOf(travelRecord.getWpAlt()));//航点执行高度  ???
```



```
folder.addElement("wpml:globalUseStraightLine").addText("1");
http://localhost:9528/
resource\kmz\121\航线任750.kmz  @Value("${spring.application.name}")  server.name
spring.application.name=uavsystem


```

```
private  String resourceminioName; //上传文件保存的本地目录
@Value("${accessFile.resourceName}")  resourceName
private  String resourceName; //上传文件保存的本地目录
```

```
String kzmPath = KmzUtil.genKmz(efTaskWpsDetails, efTaskWps1, wpsName, cid); // save kml file
if (kzmPath == null || kzmPath.isEmpty()) {
    LogUtil.logError("生成Kml航线失败!");
    return ResultUtil.error("生成Kml航线失败!");
}
File file = new File(kzmPath);
long size = file.length();  // 文件大小
// 是否minio上传
Result result = SaveFile.getKmzUrl(file,kzmPath,cid,BucketNameKmz);
if(result.getCode() == 0){
    LogUtil.logInfo("上传至minio失败!");
    return ResultUtil.error("上传至minio失败!");
}
String url  = result.getMessage().toString();
```

115.02089769965423


 docker load -i C:\Users\EFUAV\Desktop\docker\image\nginx-1.17.8.tar
  docker load -i C:\Users\EFUAV\Desktop\docker\image\jarjdk8.tar
efTaskWpsList   wpsWpCount   wpsWpIndex 

addTaskWps

```
   
```

```

```

// uploadKmz 保存问题

```
uploadKmz 上传kmz存储选择修改
```



```
                MinioClient minioClient =  MinioClient.builder()
                        .endpoint(Endpoint)
                        .credentials(AccessKey, SecretKey)
                        .build();
                        
                        
```

```
Result result = SaveFile.getStorageLocation(file,BucketNameKmz,cid);
if (result.getCode() == 0) {
return ResultUtil.error(result.getMessage());
} // 存储的
// 获取航线路径
    Result  result = SaveFile.getStorageLocation(path,BucketNameKmz);
    if (result.getCode() == 0){
        return ResultUtil.error("查询航线信息失败！");
    }
    String url = result.getMessage();
// 删除
Result  result1 = SaveFile.deleteStorageLocation(path,BucketNameKmz);
    if (result1.getCode() == 0){
        return ResultUtil.error("存储文件未删除干净，请联系管理员！");
    }
// minioClient.copyObject(BucketNameKmz, pathOld, BucketNameKmz, pathNew);
// 当个存储
    if (!minioService.putObject(bucketName, path, inputStream, contentType)) {
            return ResultUtil.error("保存文件失败(保存minio有误)！"); //生成kmzminio有误
        }


            
删除minio
removeObjects
            

```

s

```
检测minio 是否存储对象
       boolean flag=  minioService.checkStatObjectExists(BucketNameWord, applicationName + "/" + uCid + "/" + name);
```

```
删除minio一个文件

```

```
获取单个minio 路径 取出令牌
            String url = minioService.getObjectFullRealUrl(BucketNameKmz, path);
              EpUrl = minioService.getProxyObjectUrl(BucketNameWord, url);
```

```
仅minio存储
                if (!minioService.putObject(BucketNameWord, url, inputStream,  cMultiFile.getContentType())) {
                    return ResultUtil.error("保存文件失败(保存minio有误)！"); //生成kmzminio有误
                }
                minioService   uploadKmzToMinio
```



```
uploadKmzToMinio修改  uploadKmzToMinio修改  
  MultipartFile cMultiFile = new MockMultipartFile("file", file.getName(), null, new FileInputStream(file));
            long size = cMultiFile.getSize();
            
                            if (file != null && file.exists()) {
//                    file.delete();
                    FileUtil.deleteDirectory(file.getParent());
                }
```

```
 resourceminioName 生成kmz efTaskKmz
 String path = ParkingapronApplication.appConfig.getBasePath() + "temp" + File.separator + "kmz" + File.separator;
```

```
    @Value("${accessFile.resourceminioName}")
    private  String resourceminioName; //上传文件保存的本地目录
    @Value("${accessFile.resourceName}")
    private  String resourceName; //上传文件保存的本地目录
```

```

    /**
     *  解析KMZ文件
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping("/kmz")
    public Result kmzControll(@RequestBody Map<String, Object> map) throws Exception {
        String strKmzPath = map.getOrDefault("strKmz", null).toString(); // strKmz 防止空指针 默认null
        // System.out.println("strKmz-->" + strKmz); // resource\kmz\121\航11.kmz
        if (strKmzPath == null || !strKmzPath.endsWith("kmz")) {
            return ResultUtil.error("参数为空字符串或其他异常，返回错误信息或进行其他处理");
        }
        String newFilePath = "";
        try {
            if(!PhotoStorage){
                String path = strKmzPath.replace(resourceminioName+"/"+BucketNameKmz,"" );

                InputStream inputStream= minioService.downloadFile2(BucketNameKmz,path);
                //存储到本地文件内
                try (FileOutputStream fos = new FileOutputStream(location+File.separator+"temp"+File.separator+"localFilePath.kmz")) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer))!= -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                    System.out.println("文件成功存储到本地。");
                } catch (IOException e) {
                    e.printStackTrace();
                    System.out.println("存储到本地文件时出现错误。");
                } finally {
                    if (inputStream!= null) {
                        try {
                            inputStream.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }

                newFilePath = location+File.separator+"temp"+File.separator+"localFilePath.kmz";
            }else{
                String oldFilePath = strKmzPath.replace(resourceName, location);
                newFilePath = oldFilePath;
            }

            File file = new File(newFilePath); //new File("C:/efuav/UavSystem/kmz/121/航11.kmz");
            List<String> kmzPointDataList = new ArrayList<>();
            try (ZipFile zipFile = new ZipFile(file)) {
                Enumeration<? extends ZipEntry> entries = zipFile.entries();
                while (entries.hasMoreElements()) {
                    ZipEntry entry = entries.nextElement();
                    if (!entry.isDirectory()) {
                        String key = entry.getName().toLowerCase();
                        if (key.endsWith(".kml")) {
                            SAXReader saxReader = new SAXReader();
                            Document document = saxReader.read(zipFile.getInputStream(entry));
                            Element rootElement = document.getRootElement();
                            Element folderElement = rootElement.element("Document").element("Folder");
                            for (Object obj : folderElement.elements("Placemark")) {
                                Element placemark = (Element) obj;
                                Element pointElement = placemark.element("Point");
                                Element coordinatesElement = pointElement.element("coordinates");
                                if (coordinatesElement!= null) {
                                    String coordinates = coordinatesElement.getText().trim();;
                                    kmzPointDataList.add(coordinates);
                                }
                            }

                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            // ZipUtil.unzip(file.getAbsolutePath(), kmlDir2.getAbsolutePath());
            return ResultUtil.success("解析成功", kmzPointDataList);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("解析失败,请联系管理员!");

        }
//        return kmzData;
    }
}

KmzUtil.genKmz  KmlUtil.uploadKmzToMinio(
```

![image-20241101110641805](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241101110641805.png)

![image-20241101110903682](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241101110903682.png)