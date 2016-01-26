XYAddImageView
=====================
添加图片的一个UI控件
------------------
![github](http://a3.qpic.cn/psb?/V10dnTrg38EPmY/goTEb3HTXogE.8uEfegLcfA3NAwyS1sk0PM1j0Gwx*M!/b/dHYBAAAAAAAA&bo=PgFLAgAAAAACeCo!&rf=viewer_4)

* [使用](#使用方法)

#### <a id = "使用方法"></a>使用方法
###### 基本使用
        XYAddImageView *img = [[XYAddImageView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 100) NumberOfImageForOneLine:4];
        [self.view addSubview:img];
###### 若添加图片张数无限制可设置代理监测添加图片事件
        img.delegate = self;
        
  必须响应一下事件:
  
        - (void)XYAddImageViewFrameDidIncrease:(XYAddImageView *)imageView;
        - (void)XYAddImageViewFrameDidDecrease:(XYAddImageView *)imageView;
