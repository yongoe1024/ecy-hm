import { IBestNavBar } from "@ibestservices/ibest-ui";
import { RouteManager, RouterParams } from "..";
import { GlobalStyle } from "../../globalStyle";
import { image } from '@kit.ImageKit';
import { http } from "@kit.NetworkKit";
import { fileIo } from '@kit.CoreFileKit';
import { util } from "@kit.ArkTS";
import { FileUtils } from "../../../../../Index";

@Builder
export function ImgCropPageBuilder() {
  ImgCropPage()
}

/**
 * 图片裁剪
 * 传入 路径，宽高比，圆角百分比（仅宽高比为1，才有圆角）
 * 其它参数： containerSize，是占屏幕的百分比缩放
 */
@Component
export struct ImgCropPage {
  // 入参
  @State ratio: number = 3 //宽高比
  @State isCircle: boolean = false // 圆角
  @State filePath: string = ''
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('windowWidth') windowWidth: number = 0;
  @StorageProp('windowHeight') windowHeight: number = 0;
  // 大小
  imageHeight: number = 0 //原始高度
  imageWidth: number = 0 //原始高度
  // 缩放
  @State imgScale: number = 1 //图片缩放比例
  @State curScale: number = 1 //上次缩放的比例
  @State baseScale: number = 1 // 初始比例
  maxScale: number = 4
  // 位移
  @State imgOffsetX: number = 0 //图片x轴
  @State imgOffsetY: number = 0 //图片y轴
  @State preOffsetX: number = 0 //上一次移动的x轴
  @State preOffsetY: number = 0 //上一次移动的y轴
  // 容器
  @State containerWidth: number = 0;
  @State containerHeight: number = 0;
  @State containerSize: string = '10%'

  /**
   * 下载图片
   */
  async downloadImageWithUrl(url: string): Promise<ArrayBuffer> {
    let res: http.HttpResponse = await http.createHttp().request(url)
    if (res.responseCode != 200) {
      return Promise.reject()
    }
    return (res.result as ArrayBuffer)
  }

  async save(pixelMap: image.PixelMap) {
    const imagePackerApi = image.createImagePacker();
    let packOpts: image.PackingOption = { format: "image/jpeg", quality: 98 };
    let data: ArrayBuffer = await imagePackerApi.packing(pixelMap, packOpts)
    // data 为打包获取到的文件流，写入文件保存即可得到一张图片
    const context: Context = getContext(this);
    const path: string = context.cacheDir + `/${util.generateRandomUUID()}.jpg`;
    let file = fileIo.openSync(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
    // fileIo.unlinkSync(path);
    await imagePackerApi.packToFile(pixelMap, file.fd, packOpts)
    RouteManager.getInstance().popResult(path)
  }

  async finish() {
    let imageSource: image.ImageSource | null = null
    let pixelMap: image.PixelMap | null = null
    try {
      if (this.filePath.startsWith('http')) {
        imageSource = image.createImageSource(await this.downloadImageWithUrl(this.filePath));
      } else {
        let buffer = FileUtils.readArrayBuffer(this.filePath)
        imageSource = image.createImageSource(buffer);
      }
      pixelMap = await imageSource.createPixelMap()
      // 原始图信息
      let info = await pixelMap.getImageInfo()

      // 计算偏移
      // 实际裁剪 vp
      let realWidth = this.imageWidth * this.imgScale
      let realHeight = this.imageHeight * this.imgScale

      //  0点 ( realWidth-this.containerWidth)/2     ( realHeight-this.containerHeight)/2
      let x = -this.imgOffsetX + (realWidth - this.containerWidth) / 2
      let y = (realHeight - this.containerHeight) / 2 - this.imgOffsetY
      let x1 = x / this.imgScale
      let y1 = y / this.imgScale
      let x2 = x1 / (this.imageWidth / info.size.width)
      let y2 = y1 / (this.imageWidth / info.size.width)
      await pixelMap.crop({
        x: Math.round(x2),
        y: Math.round(y2),
        size: {
          height: Math.round(this.containerHeight / realHeight * info.size.height),
          width: Math.round(this.containerWidth / realWidth * info.size.width)
        }
      })
      await this.save(pixelMap)
    } catch (e) {
      console.error(e.code + e.message)
    } finally {
      pixelMap?.release();
      imageSource?.release();
    }
  }

  /**
   * 限制图片放大缩小的比例：保证图片清晰度
   * @param isReset 是否需要重置位置
   */
  limitScale(isReset:
    boolean
  ) {
    //当前图片的缩放比例是否小于1
    if (this.imgScale < this.baseScale) {
      this.imgScale = this.baseScale
      this.curScale = this.baseScale
      if (isReset) { //位置是否需要复原
        this.imgOffsetX = 0
        this.imgOffsetY = 0
      }
    }
    //当前图片的比例是否超过4倍
    else if (this.imgScale > this.baseScale * this.maxScale) {
      this.imgScale = this.baseScale * this.maxScale
      this.curScale = this.baseScale * this.maxScale
    }
    //变换的中途
    else {
      //可以操作，记录下图片的大小比例，应为下一次要继续算下去
      this.curScale = this.imgScale
    }
  }

  /**
   * 限制偏移
   */
  detectBoundary() {
    let maxOffsetX = this.imgScale * this.imageWidth / 2 - this.containerWidth / 2
    if (maxOffsetX <= 0) {
      this.imgOffsetX = 0
    } else if (this.imgOffsetX < -maxOffsetX) {
      this.imgOffsetX = -maxOffsetX
    } else if (this.imgOffsetX > maxOffsetX) {
      this.imgOffsetX = maxOffsetX
    }

    let maxOffsetY = this.imgScale * this.imageHeight / 2 - this.containerHeight / 2
    if (maxOffsetY <= 0) {
      this.imgOffsetY = 0
    } else if (this.imgOffsetY > maxOffsetY) {
      this.imgOffsetY = maxOffsetY
    } else if (this.imgOffsetY < -maxOffsetY) {
      this.imgOffsetY = -maxOffsetY
    }
  }

  /**
   * 图片
   */
  @Builder
  imgBuild() {
    Row() {
      Image(this.filePath)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .translate({ x: this.imgOffsetX, y: this.imgOffsetY })
        .scale({
          x: this.imgScale,
          y: this.imgScale,
          centerX: '50%',
          centerY: '50%'
        })
        .onComplete(msg => {
          if (msg) {
            let ratio = msg.width / msg.height
            if (ratio == this.ratio) {
              return
            }
            if (ratio < this.ratio) {
              this.curScale = this.ratio / ratio
              this.imgScale = this.ratio / ratio
              this.baseScale = this.ratio / ratio
            } else if (ratio > this.ratio) {
              this.curScale = ratio / this.ratio
              this.imgScale = ratio / this.ratio
              this.baseScale = ratio / this.ratio
            }
            if (msg.loadingStatus == 1) {
              this.imageWidth = px2vp(msg.contentWidth)
              this.imageHeight = px2vp(msg.contentHeight)
            }
          }
        })
    }
    .width(this.windowWidth < this.windowHeight ? this.containerSize : '')
    .height(this.windowHeight < this.windowWidth ? this.containerSize : '')
    .aspectRatio(this.ratio)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.containerWidth = Math.round(newValue.width as number)
      this.containerHeight = Math.round(newValue.height as number)
    })
  }

  /**
   * 裁剪
   */
  @Builder
  cropBuild() {
    Column() {
      Blank()
      Row()
        .width(this.containerWidth)
        .height(this.containerHeight)
        .borderRadius(this.ratio == 1 && this.isCircle ? this.containerWidth : 0)
        .borderWidth(2)
        .borderColor('#fff')

      Blank()
    }
    .width('100%')
    .height('100%')
  }

  build() {
    NavDestination() {
      Column() {
        IBestNavBar({
          title: "裁剪图片",
          isShowStatusBar: true,
          isShowRight: true,
          rightLabel: '确认',
          onRightClick: () => {
            this.finish()
          },
          onLeftClick: () => {
            RouteManager.getInstance().pop()
          }
        })
        Stack() {
          this.imgBuild()
          this.cropBuild()
        }
        .clip(true)
        .backgroundColor('#000')
        .gesture(
          PinchGesture()
            .onActionUpdate((event: GestureEvent) => {
              this.imgScale = this.curScale * event.scale
              this.detectBoundary()
            })
            .onActionEnd((event: GestureEvent) => {
              this.limitScale(true)
            })
        )
        .gesture(
          PanGesture()
            .onActionStart(() => {
              this.preOffsetX = this.imgOffsetX
              this.preOffsetY = this.imgOffsetY
            })
            .onActionUpdate((event: GestureEvent) => {
              this.imgOffsetX = this.preOffsetX + event.offsetX
              this.imgOffsetY = this.preOffsetY + event.offsetY
              this.detectBoundary()
            })
            .onActionEnd((event: GestureEvent) => {
            })
        )
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .attributeModifier(GlobalStyle.navModifier)
    .onReady((context: NavDestinationContext) => {
      if (context.pathInfo && context.pathInfo.param) {
        let params = context.pathInfo.param as RouterParams
        this.filePath = params.get('filePath') as string || ''
        this.isCircle = params.get('isCircle') as boolean || false
        this.ratio = params.get('ratio') as number || 1
        this.containerSize = params.get('containerSize') as string || '100%'
      }
    })
  }
}