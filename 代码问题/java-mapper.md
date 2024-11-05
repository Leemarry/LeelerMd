

{id=wps_id}   对于wps_id 为  sql的字段 ，id是dao层参数


```
        <result property="wpsId" column="wps_id" jdbcType="INTEGER"/>
        <collection property="efTaskWpsList"
                    column="{id=wps_id}"
                    select="com.efuav.parkingapron.dao.db1.EfTaskWpsDao.queryById"
                    ofType="com.efuav.parkingapron.entity.EfTaskWps"/>
```



spring 读取配置文件

```
Properties prop = PropertiesLoaderUtils.loadProperties(new ClassPathResource("application.properties"));
String BasePath = prop.getProperty("BasePath");
@Value("${accessFile.location}")
private String location; //上传文件保存的本地目录

getBasePath 
getLocation
SecretKey
```

```
Properties prop1 = PropertiesLoaderUtils.loadProperties(new ClassPathResource("application.yml"));
AccessKey = prop1.getProperty("AccessKey");
```

```
@Value("${BasePath:C://efuav/UavSystem/}")
public String BasePath;
@Value("${tempBasePath:C://efuav/UavSystem/}")
private String tempBasePath;
@Value("${minio.AccessKey}")
private String AccessKey;
@Value("${minio.SecretKey}")
private String SecretKey;
@Value("${minio.Endpoint}")
private String Endpoint;
@Value("${minio.EndpointExt}")
private String EndpointExt;
@Value("${minio.BucketNameKmz}")
private String BucketNameKmz;
@Value("${minio.BucketNameWord}")
private String BucketNameWord;
@Value("${spring.application.name}")
private String applicationName;

String location = ParkingapronApplication.appConfig.getLocation();
```