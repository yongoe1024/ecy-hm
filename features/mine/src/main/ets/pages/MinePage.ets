import { AppStorageName, Avatar, GlobalStyle, RouteManager, RouteTable, UploadFile, userApi, UserModel } from "common";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { IBestButton, IBestCell, IBestCellGroup, IBestToast } from "@ibestservices/ibest-ui";


@Component
export struct MinePage {
  @StorageProp(AppStorageName.USER) user: UserModel | undefined = undefined;

  async uploadAvatar() {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 过滤选择媒体文件类型为IMAGE
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    photoSelectOptions.maxSelectNumber = 1; // 选择媒体文件的最大数目
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    let photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoViewPicker.select(photoSelectOptions)
    let path = photoSelectResult.photoUris[0]
    await UploadFile.upload({
      url: '/user/avatar',
      filePath: path
    })
  }

  build() {
    Column({ space: 20 }) {
      //1.基本信息
      Column() {
        Avatar({
          radius: 70,
          src: this.user?.avatar,
          avatarSize: 68,
          onclick: () => {
            if (this.user) {
              this.uploadAvatar()
            }
          }
        })
        Text(this.user?.name ?? '请登录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .lineHeight(25)
          .fontColor('#fff')
          .onClick(() => {
            if (!this.user) {
              RouteManager.getInstance().push(RouteTable.ENTRY_LOGIN)
            }
          })
      }
      .backgroundImage($r("app.media.mine_ic_bg"))
      .backgroundImageSize(ImageSize.Cover)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(300)

      Column({ space: 20 }) {
        IBestCellGroup({ inset: true }) {
          IBestCell({
            title: '清理缓存',
            isLink: true,
            cellSize: 'large'
          })
          IBestCell({
            title: '隐私协议',
            isLink: true,
            cellSize: 'large'
          })
          IBestCell({
            title: '系统设置',
            isLink: true,
            hasBorder: false,
            cellSize: 'large'
          })
        }

        IBestButton({
          btnWidth: '80%',
          text: '退出登录',
          type: 'danger',
          onClickBtn: () => {
            userApi.logout()
            IBestToast.show({
              type: "success",
              message: "退出成功"
            })
          }
        })

      }
      .width('100%')
      .padding({ left: 18, right: 18 })
      .offset({ x: 0, y: -80 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f1f1')
  }
}