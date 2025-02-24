import { AppStorageName, GlobalStyle, RouteManager, userApi } from 'common';
import { componentUtils } from '@kit.ArkUI';

PersistentStorage.persistProp(AppStorageName.TOKEN, '');

@Builder
export function LoginPageBuilder() {
  LoginPage()
}


@Component
struct LoginPage {
  @State activeBtn: number = -1
  @State username: string = ''
  @State password: string = ''
  @State marginBottom: number = 0
  @StorageLink(AppStorageName.TOKEN) token: string = '';
  @StorageLink(AppStorageName.windowHeight) windowHeight: number = 0;
  @StorageProp(AppStorageName.keyboardHeight) @Watch('onInput') keyboardHeight: number = 0;

  onInput() {
    let obj: componentUtils.ComponentInfo = componentUtils.getRectangleById('form');
    let hei = (this.windowHeight - px2vp(obj.size.height)) / 2
    this.marginBottom = this.keyboardHeight - hei > 0 ? this.keyboardHeight - hei : 0
  }

  async login() {
    await userApi.login(this.username, this.password)
    await userApi.getUserInfo()
    RouteManager.getInstance().pop()
  }

  @Builder
  btn1() {
    Row() {
      Image($r('app.media.entry_ic_login_phone'))
        .width(16)
        .height(16)
      Row()
        .width(2)
        .height('50%')
        .backgroundColor('#eee')
        .margin({ left: 15 })
      TextInput({ placeholder: '用户名', text: $$this.username })
        .layoutWeight(1)
        .fontColor('#818181')
        .fontWeight(500)
        .backgroundColor('#00ffffff')
        .placeholderColor('#cecece')
        .caretColor("#dadada")
        .cancelButton({
          style: CancelButtonStyle.INPUT,
          icon: {
            size: 18,
            src: $r('app.media.entry_ic_login_btn_clear'),
            color: '#cccccc'
          }
        })
        .onClick(() => {
          this.activeBtn = 1
        })
    }
    .width('100%')
    .height(50)
    .padding({ left: 15 })
    .borderRadius(12)
    .borderColor(this.activeBtn == 1 ? "#f68c95" : '#bbb')
    .borderWidth(this.activeBtn == 1 ? 2 : 1)
  }

  @Builder
  btn2() {
    Row() {
      Image($r("app.media.entry_ic_login_password"))
        .width(16)
        .height(16)
      Row()
        .width(2)
        .height('50%')
        .backgroundColor('#eee')
        .margin({ left: 15 })
      TextInput({ placeholder: '密码', text: $$this.password })
        .layoutWeight(1)
        .fontColor('#818181')
        .fontWeight(500)
        .backgroundColor('#00ffffff')
        .placeholderColor('#cecece')
        .caretColor("#dadada")
        .cancelButton({
          style: CancelButtonStyle.INPUT,
          icon: {
            size: 22,
            src: $r('app.media.entry_ic_login_btn_clear'),
            color: '#cccccc'
          }
        })
        .onClick(() => {
          this.activeBtn = 2
        })
    }
    .width('100%')
    .height(50)
    .padding({ left: 15 })
    .borderRadius(12)
    .borderColor(this.activeBtn == 2 ? "#f68c95" : '#bbb')
    .borderWidth(this.activeBtn == 2 ? 2 : 1)
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        Stack() {
          Image($r('app.media.entry_ic_login_back'))
            .width('100%')
          Image($r('app.media.entry_ic_login_back_up'))
            .width('100%')
        }.alignRules({
          'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
        })

        Column() {
          Text('登  录')
            .fontSize(30)
            .fontColor('#818181')
            .fontWeight(500)

          Column({ space: 20 }) {
            this.btn1()
            this.btn2()
            Text('未注册的号码登录后自动注册')
              .fontSize(14)
              .fontColor('#aaa')
              .width('100%')
          }
          .margin({ top: 35 })

          Button('登录', { type: ButtonType.Normal })
            .fontSize(20)
            .fontWeight(500)
            .width('100%')
            .height(50)
            .borderRadius(15)
            .backgroundColor("#e89297")
            .margin({ top: 35 })
            .onClick(() => {
              this.login()
            })
        }
        .width('100%')
        .borderRadius({ topLeft: 30, topRight: 30 })
        .backgroundColor('#fff')
        .padding(30)
        .alignRules({
          'center': { 'anchor': '__container__', 'align': VerticalAlign.Center },
          'middle': { 'anchor': '__container__', 'align': HorizontalAlign.Center }
        })
        .id('form')
        .offset({ x: 0, y: -this.marginBottom })
        .animation({ duration: 200 })

      }.width('100%')
      .height('100%')

    }.attributeModifier(GlobalStyle.navModifier)
  }
}